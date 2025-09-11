import SwiftUI

struct OfferView: View {

    @State private var offerAmount = ""
    @State private var selectedMeasure = "Per Unit"
    @State private var startDate = Date()
    @State private var endDate = Date()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    OfferSellerInfoCard()
                    OfferBuyerRatingCard()
                    PlaceOfferCard(
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

// MARK: - Subviews

struct OfferSellerInfoCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("seller") // Placeholder image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Sadul Perera")
                    .font(.title2)
                    .fontWeight(.bold)
                Text("City: Warakapola")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Phone No: 071107161")
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

struct OfferBuyerRatingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Buyer Rating")
                .font(.headline)
                .fontWeight(.bold)
            
            OfferRatingRow(label: "Collection")
            OfferRatingRow(label: "Arrival Time")
            OfferRatingRow(label: "Payment")
            OfferRatingRow(label: "Negotiation")
            OfferRatingRow(label: "Staff")
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct PlaceOfferCard: View {
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
            
            // Offer Form
            VStack(alignment: .leading, spacing: 16) {
                Text("Your offer")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                TextField("123", text: $offerAmount)
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

// MARK: - Helper Views

struct OfferRatingRow: View {
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



struct OfferView_Previews: PreviewProvider {
    static var previews: some View {
        OfferView()
    }
}

