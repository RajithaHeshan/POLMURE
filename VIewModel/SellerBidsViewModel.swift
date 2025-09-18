
//Accept BIDS from Buyer

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

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
    
    init() {
        fetchBidsForSeller()
    }
    
    func fetchBidsForSeller() {
        guard let sellerId = Auth.auth().currentUser?.uid else {
            errorMessage = "You must be logged in as a seller to view bids."
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let propertyIDs = try await fetchSellerPropertyIDs(sellerId: sellerId)
                
                if propertyIDs.isEmpty {
                    self.bidInfos = []
                    self.isLoading = false
                    return
                }
                
                let bids = try await fetchBids(for: propertyIDs)
                
                var details: [SellerBidInfo] = []
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
                
                self.bidInfos = details.sorted(by: { $0.bid.createdAt.dateValue() > $1.bid.createdAt.dateValue() })
                
            } catch {
                self.errorMessage = error.localizedDescription
                print("🔥🔥🔥 Error fetching seller bids: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func confirmBid(bidInfo: SellerBidInfo) {
        guard let bidId = bidInfo.bid.id else { return }
        
        db.collection("bids").document(bidId).updateData(["status": BidStatus.active.rawValue]) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to confirm bid."
            } else {
                if let index = self?.bidInfos.firstIndex(where: { $0.id == bidId }) {
                    self?.bidInfos[index].bid.status = .active
                }
            }
        }
    }
    

    
    private func fetchSellerPropertyIDs(sellerId: String) async throws -> [String] {
        let snapshot = try await db.collection("properties").whereField("ownerId", isEqualTo: sellerId).getDocuments()
        return snapshot.documents.map { $0.documentID }
    }
    
    private func fetchBids(for propertyIDs: [String]) async throws -> [Bid] {
        let snapshot = try await db.collection("bids").whereField("propertyId", in: propertyIDs).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Bid.self) }
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
