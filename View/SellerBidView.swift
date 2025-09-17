import SwiftUI
import FirebaseFirestore

struct SellerBidView: View {
    let property: Property
    @StateObject private var viewModel: SellerBidViewModel

    
    init(property: Property, bidder: AppUser) {
        self.property = property
        _viewModel = StateObject(wrappedValue: SellerBidViewModel(property: property, bidder: bidder))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    SellerDetailsCard(property: property)
                    SellerRatingCard()
                   
                    BiddingInfoCard(
                        property: property,
                        viewModel: viewModel
                    )
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Sellers Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.saveSuccess ? "Success" : "Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView("Placing Bid...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(16)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
            }
        }
    }
}



struct SellerDetailsCard: View {
    let property: Property
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image("seller")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text(property.sellerName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<5) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 8) {
                BidDetailRow(label: "Estimate Haravest", value: "\(property.estimateHarvestUnits) units")
                BidDetailRow(label: "City", value: property.cityName)
                BidDetailRow(label: "Highest Bid", value: "150 units")
                BidDetailRow(label: "Harvest Date", value: property.nextHarvestDate.dateValue().formatted(.dateTime.day().month().year()))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct SellerRatingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seller Rating")
                .font(.headline)
                .fontWeight(.bold)
            
            RatingRow(label: "Product availability Rating")
            RatingRow(label: "Unit size rating")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct BiddingInfoCard: View {
    let property: Property
    @ObservedObject var viewModel: SellerBidViewModel

    let measures = ["Per Unit", "Per Kilo"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bidding")
                .font(.headline)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                BidDetailRow(label: "Highest Bid(Per Unit)", value: viewModel.highestBidPerUnit != nil ? String(format: "%.2f", viewModel.highestBidPerUnit!.bidAmount) : "N/A")
                BidDetailRow(label: "Highest Bid by(Per Unit)", value: viewModel.highestBidPerUnit?.bidderName ?? "N/A")
                BidDetailRow(label: "Highest Bid (Per Kilo)", value: viewModel.highestBidPerKilo != nil ? String(format: "%.2f", viewModel.highestBidPerKilo!.bidAmount) : "N/A")
                BidDetailRow(label: "Highest Bid by (Per Kilo)", value: viewModel.highestBidPerKilo?.bidderName ?? "N/A")
                BidDetailRow(label: "Your highest bid (Per unit)", value: viewModel.yourBidPerUnit != nil ? String(format: "%.2f", viewModel.yourBidPerUnit!) : "")
                BidDetailRow(label: "Your highest bid (Per Kilo)", value: viewModel.yourBidPerKilo != nil ? String(format: "%.2f", viewModel.yourBidPerKilo!) : "")
                BidDetailRow(label: "Contact Number", value: property.mobileNumber)
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Place you Bid")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("123", text: $viewModel.bidAmountString)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .keyboardType(.decimalPad)

                Text("Mesure")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Measure", selection: $viewModel.selectedMeasure) {
                    ForEach(measures, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )

                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    DatePicker("", selection: $viewModel.startDate, displayedComponents: .date)
                    Text("to")
                    DatePicker("", selection: $viewModel.endDate, displayedComponents: .date)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            Button(action: { viewModel.saveBid() }) {
                Text("Bid")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(16)
            }
            .padding(.top)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct BidDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

struct RatingRow: View {
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            HStack(spacing: 2) {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
            }
        }
    }
}

struct SellerBidView_Previews: PreviewProvider {
    static var previews: some View {
        
        SellerBidView(property: Property.mock, bidder: AppUser.mock)
    }
}

