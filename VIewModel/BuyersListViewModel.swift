//import SwiftUI
//import FirebaseFirestore
//
//@MainActor
//class BuyersListViewModel: ObservableObject {
//    @Published var buyers: [AppUser] = []
//    
//    private var db = Firestore.firestore()
//    private var listenerRegistration: ListenerRegistration?
//
//    init() {
//        fetchBuyers()
//    }
//    
//    deinit {
//        listenerRegistration?.remove()
//    }
//
//    func fetchBuyers() {
//        listenerRegistration?.remove()
//        
//        
//        self.listenerRegistration = db.collection("users")
//            .whereField("userType", isEqualTo: UserType.buyer.rawValue)
//            .addSnapshotListener { [weak self] (querySnapshot, error) in
//                guard let self = self else { return }
//                if let error = error {
//                    print("Error getting buyers: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let documents = querySnapshot?.documents else {
//                    print("No buyer documents found")
//                    return
//                }
//                
//              
//                self.buyers = documents.compactMap { document -> AppUser? in
//                    return AppUser(snapshot: document)
//                }
//            }
//    }
//}
//

import SwiftUI
import FirebaseFirestore

@MainActor
class BuyersListViewModel: ObservableObject {
    @Published var buyers: [AppUser] = []
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init() {
        fetchBuyers()
    }
    
    deinit {
        listenerRegistration?.remove()
    }

    func fetchBuyers() {
        listenerRegistration?.remove()
        
        self.listenerRegistration = db.collection("users")
            .whereField("userType", isEqualTo: UserType.buyer.rawValue)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting buyers: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No buyer documents found")
                    return
                }
                
                // This now correctly uses the new init?(snapshot:) initializer
                self.buyers = documents.compactMap { document -> AppUser? in
                    return AppUser(snapshot: document)
                }
            }
    }
}
