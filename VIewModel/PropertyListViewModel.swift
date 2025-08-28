import Foundation
import FirebaseFirestore
import Combine

@MainActor
class PropertyListViewModel: ObservableObject {
    @Published var properties = [Property]()
    private var listener: ListenerRegistration?
    private let db = Firestore.firestore()

    init() {
        fetchProperties()
    }

    deinit {
        listener?.remove()
    }

    func fetchProperties() {
        listener = db.collection("properties")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error fetching properties: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No properties found.")
                    return
                }
                
                self.properties = documents.compactMap { document in
                    do {
                        return try document.data(as: Property.self)
                    } catch {
                        print("Error decoding property: \(error.localizedDescription)")
                        return nil
                    }
                }
            }
    }
}

