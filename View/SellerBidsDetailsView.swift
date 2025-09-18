//Accept BIDS from Buyer

//import SwiftUI
//
//struct SellerBidsDetailsView: View {
//    @StateObject private var viewModel = SellerBidsViewModel()
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                if viewModel.isLoading {
//                    ProgressView("Loading Bids...")
//                } else if viewModel.bidInfos.isEmpty {
//                    VStack {
//                        Image(systemName: "tag.slash.fill")
//                            .font(.largeTitle)
//                            .foregroundColor(.secondary)
//                        Text("No Bids Found")
//                            .font(.title2)
//                        Text("No one has placed bids on your properties yet.")
//                            .foregroundColor(.secondary)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal)
//                    }
//                } else {
//                    List {
//                        ForEach(viewModel.bidInfos) { info in
//                            SellerBidRowView(info: info, viewModel: viewModel)
//                        }
//                    }
//                    .listStyle(PlainListStyle())
//                }
//            }
//            .navigationTitle("Bids on My Properties")
//            .onAppear {
//                viewModel.fetchBidsForSeller()
//            }
//        }
//    }
//}
//
//struct SellerBidRowView: View {
//    let info: SellerBidInfo
//    @ObservedObject var viewModel: SellerBidsViewModel
//    
//    private var statusColor: Color {
//        switch info.bid.status {
//        case .pending: return .orange
//        case .active: return .green
//        case .cancelled: return .gray
//        case .expired: return .red
//        }
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            HStack {
//                VStack(alignment: .leading) {
//                    Text(info.property.propertyName)
//                        .font(.headline)
//                        .fontWeight(.bold)
//                    Text("Bid by: \(info.buyer.fullName)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                Spacer()
//                Text(info.bid.status.rawValue)
//                    .font(.caption.bold())
//                    .foregroundColor(.white)
//                    .padding(.horizontal, 8)
//                    .padding(.vertical, 4)
//                    .background(statusColor)
//                    .clipShape(Capsule())
//            }
//            
//            Divider()
//            
//            VStack(spacing: 8) {
//                BidInfoRow(label: "Bid Amount", amount: info.bid.bidAmount, measure: info.bid.measure, isHighlighted: true)
//                BidInfoRow(label: "Harvest Date", value: info.property.nextHarvestDate.dateValue().formatted(date: .abbreviated, time: .omitted))
//            }
//            
//            if info.bid.status == .pending {
//                Divider()
//                HStack {
//                    Text("Actions")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    Spacer()
//                    Button("Confirm Bid") {
//                        viewModel.confirmBid(bidInfo: info)
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.green)
//                }
//            }
//        }
//        .padding(.vertical, 8)
//    }
//}
//
//
//struct SellerBidsDetailsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SellerBidsDetailsView()
//    }
//}
//

import SwiftUI

struct SellerBidsDetailsView: View {
    @StateObject private var viewModel = SellerBidsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading Bids...")
                } else if viewModel.bidInfos.isEmpty {
                    VStack {
                        Image(systemName: "tag.slash.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No Bids Found")
                            .font(.title2)
                        Text("No one has placed bids on your properties yet.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                } else {
                    List {
                        ForEach(viewModel.bidInfos) { info in
                            SellerBidRowView(info: info, viewModel: viewModel)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Bids on My Properties")
            .onAppear {
                viewModel.fetchBidsForSeller()
            }
        }
    }
}

struct SellerBidRowView: View {
    let info: SellerBidInfo
    @ObservedObject var viewModel: SellerBidsViewModel
    
    private var statusColor: Color {
        switch info.bid.status {
        case .pending: return .orange
        case .inactive: return .blue
        case .cancelled: return .gray
        case .expired: return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text(info.property.propertyName)
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("Bid by: \(info.buyer.fullName)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(info.bid.status.rawValue)
                    .font(.caption.bold())
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor)
                    .clipShape(Capsule())
            }
            
            Divider()
            
            VStack(spacing: 8) {
                BidInfoRow(label: "Bid Amount", amount: info.bid.bidAmount, measure: info.bid.measure, isHighlighted: true)
                BidInfoRow(label: "Harvest Date", value: info.property.nextHarvestDate.dateValue().formatted(date: .abbreviated, time: .omitted))
            }
            
            if info.bid.status == .pending {
                Divider()
                HStack {
                    Text("Actions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button("Confirm Bid") {
                        viewModel.confirmBid(bidInfo: info)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct SellerBidsDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SellerBidsDetailsView()
    }
}
