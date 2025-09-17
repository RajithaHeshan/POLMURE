import Foundation
import FirebaseFirestore

@MainActor
class SellersListViewModel: ObservableObject {
    @Published var properties: [Property] = []
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init() {
        fetchProperties()
    }
    
    deinit {
        listenerRegistration?.remove()
    }

    func fetchProperties() {
        listenerRegistration?.remove()
        
     
        self.listenerRegistration = db.collection("properties")
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting all properties: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents in properties collection")
                    return
                }
                
                self.properties = documents.compactMap { document -> Property? in
                    return Property(snapshot: document)
                }
            }
    }
}
