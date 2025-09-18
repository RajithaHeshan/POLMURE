//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//
//@MainActor
//class TransactionsViewModel: ObservableObject {
//    @Published var transactions: [Transaction] = []
//    @Published var isLoading = false
//    private var listener: ListenerRegistration?
//    
//    deinit {
//        listener?.remove()
//    }
//
//    func fetchTransactions(for user: AppUser) {
//        isLoading = true
//        listener?.remove()
//
//        var query: Query
//        if user.userType == .buyer {
//            query = Firestore.firestore().collection("transactions")
//                .whereField("buyerId", isEqualTo: user.id)
//        } else {
//            query = Firestore.firestore().collection("transactions")
//                .whereField("sellerId", isEqualTo: user.id)
//        }
//        
//        self.listener = query
//            .order(by: "createdAt", descending: true)
//            .addSnapshotListener { [weak self] querySnapshot, error in
//                guard let self = self else { return }
//                self.isLoading = false
//                
//                if let error = error {
//                    print("Error fetching transactions: \(error)")
//                    return
//                }
//                
//                guard let documents = querySnapshot?.documents else { return }
//                
//               
//                self.transactions = documents.compactMap { Transaction(document: $0) }
//            }
//    }
//}
//
//
//struct TransactionsView: View {
//    @StateObject private var viewModel = TransactionsViewModel()
//    @EnvironmentObject var sessionStore: SessionStore
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                if viewModel.isLoading {
//                    ProgressView()
//                } else if viewModel.transactions.isEmpty {
//                    VStack {
//                        Image(systemName: "doc.text.magnifyingglass")
//                            .font(.largeTitle)
//                            .foregroundColor(.secondary)
//                        Text("No Transactions Yet")
//                            .font(.title2)
//                    }
//                } else {
//                    List(viewModel.transactions) { transaction in
//                        TransactionRowView(transaction: transaction)
//                    }
//                }
//            }
//            .navigationTitle("Transactions")
//            .onAppear {
//                if let user = sessionStore.appUser {
//                    viewModel.fetchTransactions(for: user)
//                }
//            }
//        }
//    }
//}
//
//
//struct TransactionRowView: View {
//    let transaction: Transaction
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(transaction.propertyName)
//                .font(.headline)
//            
//            Text("Buyer: \(transaction.buyerName)")
//                .font(.subheadline)
//            
//            HStack {
//                Text("Amount: LKR \(String(format: "%.2f", transaction.bidAmount)) / \(transaction.measure)")
//                Spacer()
//                Text(transaction.createdAt.dateValue().formatted(date: .abbreviated, time: .omitted))
//            }
//            .font(.caption)
//            .foregroundColor(.secondary)
//            
//            Text("Estimated Harvest: \(transaction.estimatedHarvest) units")
//                .font(.caption)
//                .foregroundColor(.secondary)
//        }
//        .padding(.vertical, 4)
//    }
//}


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// The ViewModel for this screen is unchanged.
@MainActor
class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    private var listener: ListenerRegistration?
    
    deinit {
        listener?.remove()
    }

    func fetchTransactions(for user: AppUser) {
        isLoading = true
        listener?.remove()

        var query: Query
        if user.userType == .buyer {
            query = Firestore.firestore().collection("transactions")
                .whereField("buyerId", isEqualTo: user.id)
        } else {
            query = Firestore.firestore().collection("transactions")
                .whereField("sellerId", isEqualTo: user.id)
        }
        
        self.listener = query
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    print("Error fetching transactions: \(error)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else { return }
                
                self.transactions = documents.compactMap { Transaction(document: $0) }
            }
    }
}


struct TransactionsView: View {
    @StateObject private var viewModel = TransactionsViewModel()
    @EnvironmentObject var sessionStore: SessionStore
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.transactions.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Transactions Yet")
                            .font(.title2)
                    }
                } else {
                    List(viewModel.transactions) { transaction in
                        // We now pass the current user's type to the row view
                        TransactionRowView(
                            transaction: transaction,
                            currentUserType: sessionStore.appUser?.userType ?? .buyer
                        )
                    }
                }
            }
            .navigationTitle("Transactions")
            .onAppear {
                if let user = sessionStore.appUser {
                    viewModel.fetchTransactions(for: user)
                }
            }
        }
    }
}

// =================================================================
// THIS IS THE UPDATED ROW VIEW
// =================================================================
struct TransactionRowView: View {
    let transaction: Transaction
    let currentUserType: UserType
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // This logic checks who is logged in and displays the other party's name.
            if currentUserType == .buyer {
                Text("Seller: \(transaction.sellerName)")
                    .font(.headline)
            } else {
                Text("Buyer: \(transaction.buyerName)")
                    .font(.headline)
            }
            
            // This provides context for the transaction (e.g., "Direct Offer")
            Text(transaction.propertyName)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                // Display the amount
                Text("Amount: LKR \(String(format: "%.2f", transaction.bidAmount)) / \(transaction.measure)")
                Spacer()
                // Display the date
                Text(transaction.createdAt.dateValue().formatted(date: .abbreviated, time: .omitted))
            }
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}
