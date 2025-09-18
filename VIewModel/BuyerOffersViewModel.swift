import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class BuyerOffersViewModel: ObservableObject {
    @Published var receivedOffers: [Offer] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }
    
    func fetchReceivedOffers() {
        guard let buyerId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        listener = db.collection("offers")
            .whereField("buyerId", isEqualTo: buyerId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching received offers: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                self.receivedOffers = documents.compactMap { Offer(document: $0) }
                self.isLoading = false
            }
    }

    func acceptOffer(offer: Offer) {
        let offerId = offer.id
        
        let transactionData: [String: Any] = [
            "bidId": offerId,
            "propertyId": "", // This flow doesn't have a property context
            "buyerId": offer.buyerId,
            "sellerId": offer.sellerId,
            "buyerName": offer.buyerName,
            "propertyName": "Direct Offer from \(offer.sellerName)",
            "bidAmount": offer.offerAmount,
            "measure": offer.measure,
            "estimatedHarvest": 0, // This flow doesn't have a property context
            "createdAt": Timestamp(date: Date())
        ]
        
        let batch = db.batch()
        let offerRef = db.collection("offers").document(offerId)
        batch.updateData(["status": OfferStatus.accepted.rawValue], forDocument: offerRef)
        let transactionRef = db.collection("transactions").document()
        batch.setData(transactionData, forDocument: transactionRef)
        
        batch.commit { [weak self] error in
            if let error = error {
                self?.errorMessage = "Failed to accept offer."
                print("Accept offer batch commit failed: \(error)")
            }
        }
    }
    
    func declineOffer(offer: Offer) {
        let offerId = offer.id
        db.collection("offers").document(offerId).updateData(["status": OfferStatus.declined.rawValue])
    }
}
