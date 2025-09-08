import SwiftUI

struct SellerBidView: View {
    @State private var placeBidAmount = ""
    @State private var selectedMeasure = "Per Unit"
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    SellerDetailsCard()
                    SellerRatingCard()
                    BiddingInfoCard(
                        placeBidAmount: $placeBidAmount,
                        selectedMeasure: $selectedMeasure,
                        startDate: $startDate,
                        endDate: $endDate
                    )
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Sellers Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct SellerDetailsCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Image("seller") // Placeholder image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 6) {
                    Text("Heshan Dunumala")
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
                BidDetailRow(label: "Estimate Haravest", value: "2500 units")
                BidDetailRow(label: "City", value: "Warakapola")
                BidDetailRow(label: "Highest Bid", value: "150 units")
                BidDetailRow(label: "Harvest Date", value: "6/27/2025")
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
    @Binding var placeBidAmount: String
    @Binding var selectedMeasure: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    let measures = ["Per Unit", "Per Kilo"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bidding")
                .font(.headline)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                BidDetailRow(label: "Highest Bid(Per Unit)", value: "")
                BidDetailRow(label: "Highest Bid by(Per Unit)", value: "")
                BidDetailRow(label: "Highest Bid (Per Kilo)", value: "")
                BidDetailRow(label: "Highest Bid by (Per Kilo)", value: "")
                BidDetailRow(label: "Your highest bid (Per unit)", value: "")
                BidDetailRow(label: "Your highest bid (Per Kilo)", value: "")
                BidDetailRow(label: "Contact Number", value: "")
            }
            
            // Bid Placement Form
            VStack(alignment: .leading, spacing: 16) {
                Text("Place you Bid")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("123", text: $placeBidAmount)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .keyboardType(.decimalPad)

                Text("Mesure")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Measure", selection: $selectedMeasure) {
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
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                    Text("to")
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            
            Button(action: {}) {
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
        SellerBidView()
    }
}

