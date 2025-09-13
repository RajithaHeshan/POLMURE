import SwiftUI
import FirebaseFirestore

struct SellerDetailView: View {
    
    let property: Property

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                DetailSellerInfoCard(property: property)
                DetailSellerRatingInfoCard()
                DetailBiddingInfoCard(property: property)
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("Sellers Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct DetailSellerInfoCard: View {
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
                DetailBidInfoRow(label: "Estimate Haravest", value: "\(property.estimateHarvestUnits) units")
                DetailBidInfoRow(label: "City", value: property.cityName)
                DetailBidInfoRow(label: "Highest Bid", value: "150 units") // Placeholder
                DetailBidInfoRow(label: "Harvest Date", value: property.nextHarvestDate.dateValue().formatted(.dateTime.day().month().year()))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}


struct DetailSellerRatingInfoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Seller Rating")
                .font(.headline)
                .fontWeight(.bold)
            
            DetailRatingInfoRow(label: "Product availability Rating")
            DetailRatingInfoRow(label: "Unit size rating")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct DetailBiddingInfoCard: View {
    let property: Property
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Bidding")
                .font(.headline)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 8) {
                DetailBidInfoRow(label: "Highest Bid(Per Unit)", value: "")
                DetailBidInfoRow(label: "Highest Bid by(Per Unit)", value: "")
                DetailBidInfoRow(label: "Highest Bid (Per Kilo)", value: "")
                DetailBidInfoRow(label: "Highest Bid by (Per Kilo)", value: "")
                DetailBidInfoRow(label: "Your highest bid (Per unit)", value: "")
                DetailBidInfoRow(label: "Your highest bid (Per Kilo)", value: "")
                DetailBidInfoRow(label: "Contact Number", value: property.mobileNumber)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}



struct DetailBidInfoRow: View {
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

struct DetailRatingInfoRow: View {
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


struct SellerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        SellerDetailView(property: Property.mock)
    }
}

