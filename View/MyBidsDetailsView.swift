
import SwiftUI

struct MyBidsDetailsView: View {
    @StateObject private var viewModel = MyBidsDetailsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading Your Bids...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.detailedBids.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "gavel.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Bids Found")
                            .font(.title2)
                        Text("You haven't placed any bids yet.")
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.detailedBids) { detail in
                            BidDetailRowView(detail: detail)
                                .swipeActions(edge: .trailing) {
                                    if detail.myBid.status == .pending {
                                        Button(role: .destructive) {
                                            // THIS IS THE UPDATED BUTTON ACTION
                                            // It now runs the async function in a Task.
                                            Task {
                                                await viewModel.withdraw(bidDetails: detail)
                                            }
                                        } label: {
                                            Label("Withdraw", systemImage: "trash.fill")
                                        }
                                    }
                                }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.fetchDetailedBids()
                    }
                }
            }
            .navigationTitle("My Bids")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.fetchDetailedBids()
            }
        }
    }
}

// All the subviews below are the same, but included for completeness.
struct BidDetailRowView: View {
    let detail: BidDetails
    
    private var statusColor: Color {
        switch detail.myBid.status {
        case .pending: return .orange
        case .inactive: return .blue
        case .cancelled: return .gray
        case .expired: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(detail.property.sellerName)
                    .font(.headline)
                    .fontWeight(.bold)
                Spacer()
                Text(detail.myBid.status.rawValue)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .clipShape(Capsule())
            }
            Divider()
            VStack(spacing: 8) {
                BidInfoRow(label: "My Bid", amount: detail.myBid.bidAmount, measure: detail.myBid.measure, isHighlighted: true)
                if let highestBid = detail.highestBid {
                    BidInfoRow(label: "Highest Bid", amount: highestBid.bidAmount, measure: highestBid.measure)
                }
                BidInfoRow(label: "Harvest Date", value: detail.property.nextHarvestDate.dateValue().formatted(date: .abbreviated, time: .omitted))
                BidInfoRow(label: "Est. Harvest", value: "\(detail.property.estimateHarvestUnits) units")
            }
        }
        .padding(.vertical, 8)
    }
}

struct BidInfoRow: View {
    let label: String
    let value: String?
    let amount: Double?
    let measure: String?
    let isHighlighted: Bool
    init(label: String, value: String, isHighlighted: Bool = false) { self.label = label; self.value = value; self.amount = nil; self.measure = nil; self.isHighlighted = isHighlighted }
    init(label: String, amount: Double, measure: String, isHighlighted: Bool = false) { self.label = label; self.value = nil; self.amount = amount; self.measure = measure; self.isHighlighted = isHighlighted }
    var body: some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(.secondary)
            Spacer()
            if let value = value {
                Text(value).fontWeight(isHighlighted ? .bold : .regular)
            } else if let amount = amount, let measure = measure {
                Text("LKR \(String(format: "%.2f", amount))").fontWeight(isHighlighted ? .bold : .regular) + Text(" / \(measure)").font(.caption).foregroundColor(.secondary)
            }
        }
    }
}

struct MyBidsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MyBidsDetailsView()
    }
}
