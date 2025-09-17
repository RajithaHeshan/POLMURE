import SwiftUI

struct BuyerDetailView: View {
    
    let buyer: AppUser

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                BuyerDetailInfoCard(buyer: buyer)
                BuyerDetailRatingCard()
            }
            .padding()
        }
        .background(Color(.systemGray6))
        .navigationTitle("Buyer Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct BuyerDetailInfoCard: View {
    let buyer: AppUser

    var body: some View {
        HStack(spacing: 16) {
            Image("seller")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(buyer.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                Text("City: \(buyer.selectedPlaceName ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Phone No: \(buyer.mobileNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct BuyerDetailRatingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buyer Rating")
                .font(.headline)
                .fontWeight(.bold)
            
            BuyerRatingRow(label: "Collection")
            BuyerRatingRow(label: "Arrival Time")
            BuyerRatingRow(label: "Payment")
            BuyerRatingRow(label: "Negotiation")
            BuyerRatingRow(label: "Staff")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}



struct BuyerRatingRow: View {
    let label: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<5) { _ in
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
            }
        }
    }
}



struct BuyerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
           
            BuyerDetailView(buyer: AppUser.mock)
        }
    }
}
