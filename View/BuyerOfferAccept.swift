import SwiftUI

struct BuyerOfferAcceptView: View {
    @StateObject private var viewModel = BuyerOffersViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.receivedOffers.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "tag.slash")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Offers Received Yet")
                            .font(.title2)
                    }
                } else {
                    List(viewModel.receivedOffers) { offer in
                        ReceivedOfferRowView(offer: offer, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Received Offers")
            .onAppear {
                viewModel.fetchReceivedOffers()
            }
        }
    }
}

struct ReceivedOfferRowView: View {
    let offer: Offer
    @ObservedObject var viewModel: BuyerOffersViewModel
    
    private var statusColor: Color {
        switch offer.status {
        case .pending: return .orange
        case .cancelled: return .gray
        case .accepted: return .green
        case .declined: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Offer from: \(offer.sellerName)")
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
                Divider()
                HStack(spacing: 16) {
                    Text("Actions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button("Decline") {
                        viewModel.declineOffer(offer: offer)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button("Accept") {
                        viewModel.acceptOffer(offer: offer)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding(.vertical, 8)
    }
}
