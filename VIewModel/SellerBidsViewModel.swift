
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
        
        // 1. Manually create a dictionary representing the transaction
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
        
        // 2. Use a batch write to perform both actions at once for safety.
        let batch = db.batch()
        
        // Action A: Update the bid status to 'Active'
        let bidRef = db.collection("bids").document(bidId)
        batch.updateData(["status": BidStatus.active.rawValue], forDocument: bidRef)
        
        // Action B: Create the new transaction document from our dictionary
        let transactionRef = db.collection("transactions").document()
        batch.setData(transactionData, forDocument: transactionRef)
        
        // 3. Commit both changes to the database
        batch.commit { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to confirm bid and create transaction."
                print("Batch commit failed: \(error)")
            } else {
                // Update the UI instantly
                if let index = self?.bidInfos.firstIndex(where: { $0.id == bidId }) {
                    self?.bidInfos[index].bid.status = .active
                }
            }
        }
    }
    
    // MARK: - Private Helper Functions
    
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

        guard let user = AppUser(snapshot: docSnapshot) else {
             throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode AppUser with ID '\(userId)'."])
        }
        
        return user
    }

    private func fetchProperty(withId propertyId: String) async throws -> Property {
        let docSnapshot = try await db.collection("properties").document(propertyId).getDocument()

        guard let property = Property(snapshot: docSnapshot as! QueryDocumentSnapshot) else {
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode property with ID '\(propertyId)'."])
        }
        
        return property
    }
}
