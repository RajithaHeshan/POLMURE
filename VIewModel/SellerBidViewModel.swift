import SwiftUI
import FirebaseFirestore

@MainActor
class SellerBidViewModel: ObservableObject {
    
    @Published var bidAmountString = ""
    @Published var selectedMeasure = "Per Unit"
    @Published var startDate = Date()
    @Published var endDate = Date()
    
    
    @Published var yourBidPerUnit: Double?
    @Published var yourBidPerKilo: Double?
    
   
    @Published var highestBidPerUnit: Bid?
    @Published var highestBidPerKilo: Bid?
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var saveSuccess = false
    
    private let property: Property
    private let bidder: AppUser
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?

    init(property: Property, bidder: AppUser) {
        self.property = property
        self.bidder = bidder
        fetchBids() // This now fetches both your bids and the highest bids
    }
    
    deinit {
        listener?.remove()
    }

    func saveBid() {
        guard let bidAmount = Double(bidAmountString), bidAmount > 0 else {
            alertMessage = "Please enter a valid bid amount."
            showAlert = true
            return
        }
        
        isLoading = true
        
        let bidData: [String: Any] = [
            "propertyId": property.id,
            "bidderId": bidder.id,
            "bidderName": bidder.fullName,
            "bidAmount": bidAmount,
            "measure": selectedMeasure,
            "startDate": Timestamp(date: startDate),
            "endDate": Timestamp(date: endDate),
            "createdAt": Timestamp(date: Date())
        ]

        Task {
            do {
                try await db.collection("bids").addDocument(data: bidData)
                alertMessage = "Your bid was placed successfully!"
                saveSuccess = true
            } catch {
                print("🔥🔥🔥 Firestore Save Error: \(error.localizedDescription)")
                alertMessage = "Failed to place your bid. Please try again."
                saveSuccess = false
            }
            isLoading = false
            showAlert = true
        }
    }
    
    private func fetchBids() {
        listener?.remove()
        
        listener = db.collection("bids")
            .whereField("propertyId", isEqualTo: property.id)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self, let documents = querySnapshot?.documents else {
                    print("Error fetching bids: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let allBids = documents.compactMap { try? $0.data(as: Bid.self) }
                
                // Find the current user's highest bids
                let myBids = allBids.filter { $0.bidderId == self.bidder.id }
                self.yourBidPerUnit = myBids.filter { $0.measure == "Per Unit" }.map { $0.bidAmount }.max()
                self.yourBidPerKilo = myBids.filter { $0.measure == "Per Kilo" }.map { $0.bidAmount }.max()
                
                // Find the overall highest bids from all users
                self.highestBidPerUnit = allBids.filter { $0.measure == "Per Unit" }.max(by: { $0.bidAmount < $1.bidAmount })
                self.highestBidPerKilo = allBids.filter { $0.measure == "Per Kilo" }.max(by: { $0.bidAmount < $1.bidAmount })
            }
    }
}
