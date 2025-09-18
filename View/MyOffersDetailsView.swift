
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

@MainActor
class MyOffersViewModel: ObservableObject {
    @Published var sentOffers: [Offer] = []
    @Published var isLoading = false
    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    func fetchSentOffers() {
        guard let sellerId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        self.listener = Firestore.firestore().collection("offers")
            .whereField("sellerId", isEqualTo: sellerId)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self, let documents = snapshot?.documents else {
                    print("Error fetching sent offers: \(error?.localizedDescription ?? "Unknown")")
                    return
                }
                
                self.sentOffers = documents.compactMap { Offer(document: $0) }
                self.isLoading = false
            }
    }

    func cancelOffer(offer: Offer) {
        Firestore.firestore().collection("offers").document(offer.id)
            .updateData(["status": OfferStatus.cancelled.rawValue])
    }
}


struct MyOffersDetailsView: View {
    @StateObject private var viewModel = MyOffersViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.sentOffers.isEmpty {
                    Text("You haven't sent any offers yet.")
                } else {
                    List {
                        ForEach(viewModel.sentOffers) { offer in
                            SentOfferRowView(offer: offer)
                                .swipeActions {
                                    if offer.status == .pending {
                                        Button("Cancel", role: .destructive) {
                                            viewModel.cancelOffer(offer: offer)
                                        }
                                    }
                                }
                        }
                    }
                }
            }
            .navigationTitle("Sent Offers")
            .onAppear {
                viewModel.fetchSentOffers()
            }
        }
    }
}


struct SentOfferRowView: View {
    let offer: Offer
    
    private var statusColor: Color {
        switch offer.status {
        case .pending: return .orange
        case .cancelled: return .gray
        case .accepted: return .green
        case .declined: return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Offer to: \(offer.buyerName)")
                    .font(.headline)
                Spacer()
                Text(offer.status.rawValue)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .clipShape(Capsule())
            }
            Text("Amount: LKR \(String(format: "%.2f", offer.offerAmount)) / \(offer.measure)")
                .font(.subheadline)
            Text("Date: \(offer.offerDate.dateValue().formatted(date: .abbreviated, time: .omitted))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if offer.status == .pending {
                Text("Swipe left to cancel")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}
