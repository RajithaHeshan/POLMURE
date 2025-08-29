import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class PropertyListViewModel: ObservableObject {
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
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in, cannot fetch properties.")
            return
        }
        
        listenerRegistration?.remove()
        
        self.listenerRegistration = db.collection("properties")
            .whereField("ownerId", isEqualTo: userId)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Error getting properties: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents found for this user.")
                    self.properties = []
                    return
                }
                
                self.properties = documents.compactMap { document -> Property? in
                    return Property(snapshot: document)
                }
            }
    }
    
    func delete(_ property: Property) {
        db.collection("properties").document(property.id).delete { error in
            if let error = error {
                print("Error removing document: \(error.localizedDescription)")
            } else {
                print("Property successfully deleted.")
            }
        }
    }
}
