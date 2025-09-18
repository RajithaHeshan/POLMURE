//import SwiftUI
//
//struct BuyerOfferView: View {
//   
//    let buyer: AppUser
//
//    
//    @State private var offerAmount = ""
//    @State private var selectedMeasure = "Per Unit"
//    @State private var startDate = Date()
//    @State private var endDate = Date()
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 24) {
//                    BuyerOfferInfoCard(buyer: buyer)
//                    BuyerOfferRatingCard()
//                    PlaceOfferView(
//                        offerAmount: $offerAmount,
//                        selectedMeasure: $selectedMeasure,
//                        startDate: $startDate,
//                        endDate: $endDate
//                    )
//                }
//                .padding()
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("offers")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {}) {
//                        Image(systemName: "arrow.backward")
//                            .foregroundColor(.black)
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//struct BuyerOfferInfoCard: View {
//    let buyer: AppUser
//
//    var body: some View {
//        HStack(spacing: 16) {
//            Image("seller")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 80, height: 80)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//            
//            VStack(alignment: .leading, spacing: 4) {
//                Text(buyer.fullName)
//                    .font(.title2)
//                    .fontWeight(.bold)
//                Text("City: \(buyer.selectedPlaceName ?? "N/A")")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                Text("Phone No: \(buyer.mobileNumber)")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            Spacer()
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//struct BuyerOfferRatingCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Buyer Rating")
//                .font(.headline)
//                .fontWeight(.bold)
//            
//            BuyerOfferRatingRow(label: "Collection")
//            BuyerOfferRatingRow(label: "Arrival Time")
//            BuyerOfferRatingRow(label: "Payment")
//            BuyerOfferRatingRow(label: "Negotiation")
//            BuyerOfferRatingRow(label: "Staff")
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//struct PlaceOfferView: View {
//    @Binding var offerAmount: String
//    @Binding var selectedMeasure: String
//    @Binding var startDate: Date
//    @Binding var endDate: Date
//
//    let measures = ["Per Unit", "Per Kilo"]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Place Your Offer")
//                .font(.headline)
//                .fontWeight(.bold)
//
//      
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Your offer")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                TextField("123", text: $offerAmount)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
//                    .keyboardType(.numberPad)
//            }
//
//          
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Mesure")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                Picker("Measure", selection: $selectedMeasure) {
//                    ForEach(measures, id: \.self) { Text($0) }
//                }
//                .pickerStyle(.menu)
//                .padding(.horizontal)
//                .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
//            }
//
//         
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Date")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                HStack {
//                    DatePicker("", selection: $startDate, displayedComponents: .date)
//                    Text("to")
//                    DatePicker("", selection: $endDate, displayedComponents: .date)
//                }
//                .padding(8)
//                .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
//            }
//            
//            Button(action: {}) {
//                Text("Offer")
//                    .fontWeight(.semibold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.green)
//                    .cornerRadius(16)
//            }
//            .padding(.top)
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//
//
//struct BuyerOfferRatingRow: View {
//    let label: String
//    
//    var body: some View {
//        HStack {
//            Text(label)
//                .font(.subheadline)
//            Spacer()
//            HStack(spacing: 4) {
//                ForEach(0..<5) { _ in
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.caption)
//                }
//            }
//        }
//    }
//}
//
//
//
//struct BuyerOfferView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            BuyerOfferView(buyer: AppUser.mock)
//        }
//    }
//}
//
//


//import SwiftUI
//
//struct BuyerOfferView: View {
//    let buyer: AppUser
//    @EnvironmentObject var sessionStore: SessionStore
//    @Environment(\.dismiss) var dismiss
//    
//    @StateObject private var viewModel = BuyerOfferViewModel()
//
//    var body: some View {
//        ZStack {
//            ScrollView {
//                VStack(spacing: 24) {
//                    BuyerOfferInfoCard(buyer: buyer)
//                    PlaceOfferView(viewModel: viewModel)
//                    
//                    
//                    Button(action: {
//                        if let seller = sessionStore.appUser {
//
//                            viewModel.saveOffer(seller: seller, buyer: buyer)
//                        } else {
//                            
//                            viewModel.alertMessage = "Could not identify the seller. Please try logging out and back in."
//                            viewModel.saveSuccess = false
//                            viewModel.showAlert = true
//                        }
//                    }) {
//                        Text("Send Offer")
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color.green)
//                            .cornerRadius(16)
//                    }
//                    .padding(.top)
//                }
//                .padding()
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("Make an Offer")
//            .navigationBarTitleDisplayMode(.inline)
//            .alert(isPresented: $viewModel.showAlert) {
//                Alert(
//                    title: Text(viewModel.saveSuccess ? "Success" : "Error"),
//                    message: Text(viewModel.alertMessage),
//                    dismissButton: .default(Text("OK")) {
//                        if viewModel.saveSuccess {
//                            dismiss()
//                        }
//                    }
//                )
//            }
//            
//            if viewModel.isLoading {
//                Color.black.opacity(0.4).ignoresSafeArea()
//                ProgressView("Sending...")
//            }
//        }
//    }
//}
//
//// Subview for the form fields
//struct PlaceOfferView: View {
//    @ObservedObject var viewModel: BuyerOfferViewModel
//    let measures = ["Per Unit", "Per Kilo"]
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Place Your Offer")
//                .font(.headline)
//                .fontWeight(.bold)
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Your offer")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                TextField("Amount", text: $viewModel.offerAmountString)
//                    .padding()
//                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
//                    .keyboardType(.decimalPad)
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Measure")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                Picker("Measure", selection: $viewModel.selectedMeasure) {
//                    ForEach(measures, id: \.self) { Text($0) }
//                }
//                .pickerStyle(.segmented)
//            }
//
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Date")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//                DatePicker("Offer Date", selection: $viewModel.date, displayedComponents: .date)
//                    .labelsHidden()
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//// Unchanged subviews - included for completeness
//struct BuyerOfferInfoCard: View {
//    let buyer: AppUser
//    var body: some View {
//        HStack(spacing: 16) {
//            Image("seller").resizable().aspectRatio(contentMode: .fill).frame(width: 80, height: 80).clipShape(RoundedRectangle(cornerRadius: 12))
//            VStack(alignment: .leading, spacing: 4) {
//                Text(buyer.fullName).font(.title2).fontWeight(.bold)
//                Text("City: \(buyer.selectedPlaceName ?? "N/A")").font(.subheadline).foregroundColor(.secondary)
//                Text("Phone No: \(buyer.mobileNumber)").font(.subheadline).foregroundColor(.secondary)
//            }
//            Spacer()
//        }
//        .padding().background(Color.white).cornerRadius(16).shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}


import SwiftUI

struct BuyerOfferView: View {
    let buyer: AppUser
    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.dismiss) var dismiss
    
   
    @StateObject private var viewModel = BuyerOfferViewModel()

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    // This is your original layout
                    BuyerOfferInfoCard(buyer: buyer)
                    BuyerOfferRatingCard()
                    PlaceOfferView(
                        viewModel: viewModel,
                        sessionStore: sessionStore,
                        buyer: buyer
                    )
                }
                .padding()
            }
            .background(Color(.systemGray6))
            .navigationTitle("Make an Offer")
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(
                    title: Text(viewModel.saveSuccess ? "Success" : "Error"),
                    message: Text(viewModel.alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if viewModel.saveSuccess {
                            dismiss()
                        }
                    }
                )
            }
            
            if viewModel.isLoading {
                Color.black.opacity(0.4).ignoresSafeArea()
                ProgressView("Sending...")
            }
        }
    }
}



struct PlaceOfferView: View {
    @ObservedObject var viewModel: BuyerOfferViewModel
    
    
    var sessionStore: SessionStore
    var buyer: AppUser

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
                TextField("Amount", text: $viewModel.offerAmountString)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
                    .keyboardType(.decimalPad)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Measure")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                // The picker style has been removed to return to the default menu
                Picker("Measure", selection: $viewModel.selectedMeasure) {
                    ForEach(measures, id: \.self) { Text($0) }
                }
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Date")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                DatePicker("Offer Date", selection: $viewModel.date, displayedComponents: .date)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            }
            
            Button(action: {
                if let seller = sessionStore.appUser {
                    viewModel.saveOffer(seller: seller, buyer: buyer)
                } else {
                    viewModel.alertMessage = "Could not identify the seller. Please try logging out and back in."
                    viewModel.saveSuccess = false
                    viewModel.showAlert = true
                }
            }) {
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



struct BuyerOfferInfoCard: View {
    let buyer: AppUser
    var body: some View {
        HStack(spacing: 16) {
            Image("seller").resizable().aspectRatio(contentMode: .fill).frame(width: 80, height: 80).clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 4) {
                Text(buyer.fullName).font(.title2).fontWeight(.bold)
                Text("City: \(buyer.selectedPlaceName ?? "N/A")").font(.subheadline).foregroundColor(.secondary)
                Text("Phone No: \(buyer.mobileNumber)").font(.subheadline).foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding().background(Color.white).cornerRadius(16).shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct BuyerOfferRatingCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Buyer Rating").font(.headline).fontWeight(.bold)
            BuyerOfferRatingRow(label: "Collection")
            BuyerOfferRatingRow(label: "Arrival Time")
            BuyerOfferRatingRow(label: "Payment")
            BuyerOfferRatingRow(label: "Negotiation")
            BuyerOfferRatingRow(label: "Staff")
        }
        .padding().frame(maxWidth: .infinity, alignment: .leading).background(Color.white).cornerRadius(16).shadow(color: .black.opacity(0.05), radius: 10, y: 5)
    }
}

struct BuyerOfferRatingRow: View {
    let label: String
    var body: some View {
        HStack {
            Text(label).font(.subheadline)
            Spacer()
            HStack(spacing: 4) {
                ForEach(0..<5) { _ in Image(systemName: "star.fill").foregroundColor(.yellow).font(.caption) }
            }
        }
    }
}
