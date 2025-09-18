//import Foundation
//import FirebaseFirestore
//
//@MainActor
//class BuyerOfferViewModel: ObservableObject {
//    @Published var offerAmountString = ""
//    @Published var selectedMeasure = "Per Unit"
//    @Published var date = Date()
//    
//    @Published var isLoading = false
//    @Published var showAlert = false
//    @Published var alertMessage = ""
//    @Published var saveSuccess = false
//    
//    private let db = Firestore.firestore()
//
//    func saveOffer(seller: AppUser, buyer: AppUser) {
//        guard let offerAmount = Double(offerAmountString), offerAmount > 0 else {
//            alertMessage = "Please enter a valid offer amount."
//            showAlert = true
//            return
//        }
//        
//        isLoading = true
//        
//        let offerData: [String: Any] = [
//            "sellerId": seller.id,
//            "buyerId": buyer.id,
//            "buyerName": buyer.fullName,
//            "sellerName": seller.fullName,
//            "offerAmount": offerAmount,
//            "measure": selectedMeasure,
//            "offerDate": Timestamp(date: date),
//            "createdAt": Timestamp(date: Date()),
//            "status": OfferStatus.pending.rawValue
//        ]
//        
//        db.collection("offers").addDocument(data: offerData) { [weak self] error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                print("🔥🔥🔥 Firestore Save Error: \(error.localizedDescription)")
//                self.alertMessage = "Failed to send your offer. Please try again."
//                self.saveSuccess = false
//            } else {
//                self.alertMessage = "Your offer was sent successfully!"
//                self.saveSuccess = true
//            }
//            
//            self.isLoading = false
//            self.showAlert = true
//        }
//    }
//}

import Foundation
import FirebaseFirestore

@MainActor
class BuyerOfferViewModel: ObservableObject {
    @Published var offerAmountString = ""
    @Published var selectedMeasure = "Per Unit"
    @Published var date = Date()
    
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    @Published var saveSuccess = false
    
    private let db = Firestore.firestore()

    func saveOffer(seller: AppUser, buyer: AppUser) {
        guard let offerAmount = Double(offerAmountString), offerAmount > 0 else {
            alertMessage = "Please enter a valid offer amount."
            saveSuccess = false
            showAlert = true
            return
        }
        
        isLoading = true
        
        let offerData: [String: Any] = [
            "sellerId": seller.id,
            "buyerId": buyer.id,
            "buyerName": buyer.fullName,
            "sellerName": seller.fullName,
            "offerAmount": offerAmount,
            "measure": selectedMeasure,
            "offerDate": Timestamp(date: date),
            "createdAt": Timestamp(date: Date()),
            "status": OfferStatus.pending.rawValue
        ]
        
        Task {
            do {
                try await db.collection("offers").addDocument(data: offerData)
                alertMessage = "Your offer was sent successfully!"
                saveSuccess = true
            } catch {
                print("🔥🔥🔥 Firestore Save Error: \(error.localizedDescription)")
                alertMessage = "Failed to send offer: \(error.localizedDescription)"
                saveSuccess = false
            }
            
            isLoading = false
            showAlert = true
        }
    }
}
