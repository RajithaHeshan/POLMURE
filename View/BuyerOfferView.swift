import SwiftUI

struct BuyerOfferView: View {
   
    let buyer: AppUser

    
    @State private var offerAmount = ""
    @State private var selectedMeasure = "Per Unit"
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    BuyerOfferInfoCard(buyer: buyer)
                    BuyerOfferRatingCard()
                    PlaceOfferView(
                        offerAmount: $offerAmount,
                        selectedMeasure: $selectedMeasure,
                        startDate: $startDate,
                        endDate: $endDate
                    )
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("offers")
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



struct BuyerOfferInfoCard: View {
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

struct BuyerOfferRatingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buyer Rating")
                .font(.headline)
                .fontWeight(.bold)
            
            BuyerOfferRatingRow(label: "Collection")
            BuyerOfferRatingRow(label: "Arrival Time")
            BuyerOfferRatingRow(label: "Payment")
            BuyerOfferRatingRow(label: "Negotiation")
            BuyerOfferRatingRow(label: "Staff")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct PlaceOfferView: View {
    @Binding var offerAmount: String
    @Binding var selectedMeasure: String
    @Binding var startDate: Date
    @Binding var endDate: Date

    let measures = ["Per Unit", "Per Kilo"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Place Your Offer")
                .font(.headline)
                .fontWeight(.bold)

      
            VStack(alignment: .leading, spacing: 8) {
                Text("Your offer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("123", text: $offerAmount)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
                    .keyboardType(.numberPad)
            }

          
            VStack(alignment: .leading, spacing: 8) {
                Text("Mesure")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Picker("Measure", selection: $selectedMeasure) {
                    ForEach(measures, id: \.self) { Text($0) }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            }

         
            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    DatePicker("", selection: $startDate, displayedComponents: .date)
                    Text("to")
                    DatePicker("", selection: $endDate, displayedComponents: .date)
                }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            }
            
            Button(action: {}) {
                Text("Offer")
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



struct BuyerOfferRatingRow: View {
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



struct BuyerOfferView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyerOfferView(buyer: AppUser.mock)
        }
    }
}


