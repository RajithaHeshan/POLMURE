import Foundation
import FirebaseFirestore
import FirebaseAuth

@MainActor
class UserPropertiesViewModel: ObservableObject {
    @Published var properties: [Property] = []
    private var listener: ListenerRegistration?
    
    init() {
        fetchProperties()
    }
    
    deinit {
        listener?.remove()
    }
    
    func fetchProperties() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = Firestore.firestore().collection("properties")
            .whereField("ownerId", isEqualTo: userId)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self, let documents = querySnapshot?.documents else {
                    print("Error fetching user properties: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                
                self.properties = documents.compactMap { queryDocumentSnapshot -> Property? in
                    return Property(snapshot: queryDocumentSnapshot)
                }
            }
    }
}

