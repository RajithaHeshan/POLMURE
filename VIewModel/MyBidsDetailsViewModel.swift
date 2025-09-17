import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

struct BidDetails: Identifiable {
    var id: String { myBid.id ?? UUID().uuidString }
    let myBid: Bid
    let property: Property
    let highestBid: Bid?
    
    var status: String {
        if myBid.endDate.dateValue() < Date() {
            return "Expired"
        }
        return "Active"
    }
}

@MainActor
class MyBidsDetailsViewModel: ObservableObject {
    
    @Published var detailedBids: [BidDetails] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    
    init() {
        fetchDetailedBids()
    }
    
    func fetchDetailedBids() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "Error: You must be logged in to see your bids."
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let myBids = try await fetchBids(for: userId)
                
                var details: [BidDetails] = []
                try await withThrowingTaskGroup(of: BidDetails?.self) { group in
                    for bid in myBids {
                        group.addTask {
                            do {
                                async let property = self.fetchProperty(withId: bid.propertyId)
                                async let highestBid = self.fetchHighestBid(forProperty: bid.propertyId)
                                return try await BidDetails(myBid: bid, property: property, highestBid: highestBid)
                            } catch {
                                print("Skipping bid for property \(bid.propertyId), as property was not found or has an error: \(error.localizedDescription)")
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
                
                self.detailedBids = details.sorted(by: { $0.myBid.createdAt.dateValue() > $1.myBid.createdAt.dateValue() })
                
            } catch {
                self.errorMessage = error.localizedDescription
                print("🔥🔥🔥 Error fetching detailed bids: \(error)")
            }
            
            isLoading = false
        }
    }
    
    func withdraw(bidDetails: BidDetails) {
        guard let bidId = bidDetails.myBid.id else { return }
        db.collection("bids").document(bidId).delete()
    }
    
    private func fetchBids(for userId: String) async throws -> [Bid] {
        let snapshot = try await db.collection("bids").whereField("bidderId", isEqualTo: userId).getDocuments()
        // This automatic decoding for Bid is fine because its `id` is optional.
        return snapshot.documents.compactMap { try? $0.data(as: Bid.self) }
    }
    
    // =================================================================
    // THIS IS THE MANUAL DECODING FUNCTION THAT WILL FIX YOUR ERROR
    // =================================================================
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
            throw NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not decode property with ID '\(propertyId)'. A field is missing or has the wrong data type in Firestore."])
        }
        
        // This uses the init() from your Property.swift file
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
    
    private func fetchHighestBid(forProperty propertyId: String) async throws -> Bid? {
        let snapshot = try await db.collection("bids")
            .whereField("propertyId", isEqualTo: propertyId)
            .order(by: "bidAmount", descending: true)
            .limit(to: 1)
            .getDocuments()
        return try? snapshot.documents.first?.data(as: Bid.self)
    }
}
