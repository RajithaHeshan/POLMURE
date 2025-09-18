
//Accept BIDS from Buyer

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

// A struct to hold all the info a seller needs for a single bid
struct SellerBidInfo: Identifiable {
    var id: String { bid.id ?? UUID().uuidString }
    
    var bid: Bid
    let buyer: AppUser
    let property: Property
}

@MainActor
class SellerBidsViewModel: ObservableObject {
    
    @Published var bidInfos: [SellerBidInfo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        fetchBidsForSeller()
    }
    
    deinit {
        // Important: Stop listening for changes when the view disappears
        listener?.remove()
    }
    
    func fetchBidsForSeller() {
        guard let sellerId = Auth.auth().currentUser?.uid else {
            errorMessage = "You must be logged in as a seller to view bids."
            return
        }
        
        isLoading = true
        listener?.remove() // Stop any previous listener
        
        Task {
            do {
                // First, find all property IDs that belong to the current seller
                let propertyIDs = try await fetchSellerPropertyIDs(sellerId: sellerId)
                
                if propertyIDs.isEmpty {
                    self.bidInfos = []
                    self.isLoading = false
                    return
                }
                
                // Set up a real-time listener on the bids collection
                self.listener = db.collection("bids")
                    .whereField("propertyId", in: propertyIDs)
                    .addSnapshotListener { [weak self] querySnapshot, error in
                        guard let self = self, let documents = querySnapshot?.documents else {
                            print("Error fetching bid snapshots: \(error?.localizedDescription ?? "Unknown")")
                            return
                        }
                        
                        // We need to manually set the ID on each bid
                        let bids = documents.compactMap { doc -> Bid? in
                            var bid = try? doc.data(as: Bid.self)
                            bid?.id = doc.documentID
                            return bid
                        }
                        
                        // We still need to fetch the related user/property data
                        Task {
                            await self.fetchDetails(for: bids)
                        }
                    }
                
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                print("🔥🔥🔥 Error setting up seller bids listener: \(error)")
            }
        }
    }
    
    private func fetchDetails(for bids: [Bid]) async {
        var details: [SellerBidInfo] = []
        
        do {
            try await withThrowingTaskGroup(of: SellerBidInfo?.self) { group in
                for bid in bids {
                    group.addTask {
                        do {
                            async let buyer = self.fetchUser(withId: bid.bidderId)
                            async let property = self.fetchProperty(withId: bid.propertyId)
                            return try await SellerBidInfo(bid: bid, buyer: buyer, property: property)
                        } catch {
                            print("Skipping a bid due to an error fetching related data: \(error.localizedDescription)")
                            return nil
                        }
                    }
                }
                for try await detail in group {
                    if let detail = detail {
                        details.append(detail)
                    }
                }
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }

        self.bidInfos = details.sorted(by: { $0.bid.createdAt.dateValue() > $1.bid.createdAt.dateValue() })
        self.isLoading = false
    }

    // This function now uses the listener for UI updates.
    func confirmBid(bidInfo: SellerBidInfo) {
        guard let bidId = bidInfo.bid.id else { return }
        
        let transactionData: [String: Any] = [
            "bidId": bidId,
            "propertyId": bidInfo.property.id,
            "buyerId": bidInfo.buyer.id,
            "sellerId": bidInfo.property.ownerId,
            "buyerName": bidInfo.buyer.fullName,
            "propertyName": bidInfo.property.propertyName,
            "bidAmount": bidInfo.bid.bidAmount,
            "measure": bidInfo.bid.measure,
            "estimatedHarvest": bidInfo.property.estimateHarvestUnits,
            "createdAt": Timestamp(date: Date())
        ]
        
        let batch = db.batch()
        let bidRef = db.collection("bids").document(bidId)
        batch.updateData(["status": BidStatus.active.rawValue], forDocument: bidRef)
        let transactionRef = db.collection("transactions").document()
        batch.setData(transactionData, forDocument: transactionRef)
        
        batch.commit { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to confirm bid and create transaction."
                print("Batch commit failed: \(error)")
            }
            // No need to update the local array here. The listener does it for us.
        }
    }
    
    // MARK: - Private Helper Functions
    
    private func fetchSellerPropertyIDs(sellerId: String) async throws -> [String] {
        let snapshot = try await db.collection("properties").whereField("ownerId", isEqualTo: sellerId).getDocuments()
        return snapshot.documents.map { $0.documentID }
    }
    
    private func fetchUser(withId userId: String) async throws -> AppUser {
        let docSnapshot = try await db.collection("users").document(userId).getDocument()

        guard let data = docSnapshot.data(), docSnapshot.exists else {
            throw NSError(domain: "DataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document with ID '\(userId)' was not found."])
        }

        let id = docSnapshot.documentID
        let username = data["username"] as? String ?? ""
        let fullName = data["fullName"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let mobileNumber = data["mobileNumber"] as? String ?? ""
        let userTypeString = data["userType"] as? String ?? "Buyer"
        let userType = UserType(rawValue: userTypeString) ?? .buyer
        let createdAt = data["createdAt"] as? Timestamp ?? Timestamp()
        let location = data["location"] as? GeoPoint
        let selectedPlaceName = data["selectedPlaceName"] as? String
        
        return AppUser(id: id, username: username, fullName: fullName, email: email, userType: userType, createdAt: createdAt, mobileNumber: mobileNumber, location: location, selectedPlaceName: selectedPlaceName)
    }

    private func fetchProperty(withId propertyId: String) async throws -> Property {
        let docSnapshot = try await db.collection("properties").document(propertyId).getDocument()

        guard let data = docSnapshot.data(), docSnapshot.exists else {
            throw NSError(domain: "DataError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Property document with ID '\(propertyId)' was not found."])
        }
        
        guard
            let ownerId = data["ownerId"] as? String,
            let propertyName = data["propertyName"] as? String,
            let sellerName = data["sellerName"] as? String,
            let mobileNumber = data["mobileNumber"] as? String,
            let estimateHarvestUnits = data["estimateHarvestUnits"] as? Int,
            let nextHarvestDate = data["nextHarvestDate"] as? Timestamp,
            let location = data["location"] as? GeoPoint,
            let cityName = data["cityName"] as? String,
            let createdAt = data["createdAt"] as? Timestamp
        else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode property with ID '\(propertyId)'."])
        }
        
        let property = Property(
            id: docSnapshot.documentID,
            ownerId: ownerId,
            propertyName: propertyName,
            sellerName: sellerName,
            mobileNumber: mobileNumber,
            estimateHarvestUnits: estimateHarvestUnits,
            nextHarvestDate: nextHarvestDate,
            location: location,
            cityName: cityName,
            createdAt: createdAt
        )
        
        return property
    }
}
