//import SwiftUI
//
//struct SellerDetailView: View {
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 24) {
//                   
//                    DetailSellerInfoCard()
//                    DetailSellerRatingInfoCard()
//                    DetailBiddingInfoCard()
//                }
//                .padding()
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("Sellers Details")
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
//struct DetailSellerInfoCard: View {
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack(spacing: 16) {
//                Image("seller")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("Heshan Dunumala")
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    HStack(spacing: 4) {
//                        ForEach(0..<5) { _ in
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.yellow)
//                                .font(.caption)
//                        }
//                    }
//                }
//                Spacer()
//            }
//            
//            VStack(spacing: 8) {
//                // Using the renamed helper view
//                DetailBidInfoRow(label: "Estimate Haravest", value: "2500 units")
//                DetailBidInfoRow(label: "City", value: "Warakapola")
//                DetailBidInfoRow(label: "Highest Bid", value: "150 units")
//                DetailBidInfoRow(label: "Harvest Date", value: "6/27/2025")
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//
//struct DetailSellerRatingInfoCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Seller Rating")
//                .font(.headline)
//                .fontWeight(.bold)
//            
//            
//            DetailRatingInfoRow(label: "Product availability Rating")
//            DetailRatingInfoRow(label: "Unit size rating")
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//// Renamed from BiddingInfoCard to avoid conflict
//struct DetailBiddingInfoCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Bidding")
//                .font(.headline)
//                .fontWeight(.bold)
//
//            VStack(alignment: .leading, spacing: 8) {
//                // Using the renamed helper view
//                DetailBidInfoRow(label: "Highest Bid(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per unit)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Contact Number", value: "")
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//// Renamed from BidDetailRow to avoid conflict
//struct DetailBidInfoRow: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        HStack {
//            Text(label)
//                .foregroundColor(.secondary)
//            Spacer()
//            Text(value)
//                .fontWeight(.medium)
//        }
//        .font(.subheadline)
//    }
//}
//
//// Renamed from RatingRow to avoid conflict
//struct DetailRatingInfoRow: View {
//    let label: String
//    
//    var body: some View {
//        HStack {
//            Text(label)
//                .font(.subheadline)
//            Spacer()
//            HStack(spacing: 2) {
//                ForEach(0..<5) { _ in
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.subheadline)
//                }
//            }
//        }
//    }
//}
//
//struct SellerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        SellerDetailView()
//    }
//}
//
//
//
//
//
//
//
//
//            
//            
//
//
//import SwiftUI
//import FirebaseFirestore
//
//struct SellerDetailView: View {
//    
//    
//    let property: Property
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 24) {
//                    // The property data is now passed down to the sub-views
//                    DetailSellerInfoCard(property: property)
//                    DetailSellerRatingInfoCard()
//                    DetailBiddingInfoCard(property: property)
//                }
//                .padding()
//            }
//            .background(Color(.systemGray6))
//            .navigationTitle("Sellers Details")
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
//struct DetailSellerInfoCard: View {
//    let property: Property
//
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack(spacing: 16) {
//                Image("seller")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//
//                VStack(alignment: .leading, spacing: 6) {
//                    // Displaying dynamic data
//                    Text(property.sellerName)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    HStack(spacing: 4) {
//                        ForEach(0..<5) { _ in
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.yellow)
//                                .font(.caption)
//                        }
//                    }
//                }
//                Spacer()
//            }
//            
//            VStack(spacing: 8) {
//                // Displaying dynamic data
//                DetailBidInfoRow(label: "Estimate Haravest", value: "\(property.estimateHarvestUnits) units")
//                DetailBidInfoRow(label: "City", value: property.cityName)
//                DetailBidInfoRow(label: "Highest Bid", value: "150 units") // Placeholder
//                DetailBidInfoRow(label: "Harvest Date", value: property.nextHarvestDate.dateValue().formatted(.dateTime.day().month().year()))
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//
//struct DetailSellerRatingInfoCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Seller Rating")
//                .font(.headline)
//                .fontWeight(.bold)
//            
//            DetailRatingInfoRow(label: "Product availability Rating")
//            DetailRatingInfoRow(label: "Unit size rating")
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//struct DetailBiddingInfoCard: View {
//    let property: Property
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Bidding")
//                .font(.headline)
//                .fontWeight(.bold)
//
//            VStack(alignment: .leading, spacing: 8) {
//                // Displaying dynamic data
//                DetailBidInfoRow(label: "Highest Bid(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per unit)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Contact Number", value: property.mobileNumber)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//// MARK: - Helper Views (Unchanged)
//
//struct DetailBidInfoRow: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        HStack {
//            Text(label)
//                .foregroundColor(.secondary)
//            Spacer()
//            Text(value)
//                .fontWeight(.medium)
//        }
//        .font(.subheadline)
//    }
//}
//
//struct DetailRatingInfoRow: View {
//    let label: String
//    
//    var body: some View {
//        HStack {
//            Text(label)
//                .font(.subheadline)
//            Spacer()
//            HStack(spacing: 2) {
//                ForEach(0..<5) { _ in
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.subheadline)
//                }
//            }
//        }
//    }
//}
//
//
//
//struct SellerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        // This preview requires a mock object to function.
//        // For this to work, ensure your Property.swift file has a static var mock.
//        SellerDetailView(property: Property.mock)
//    }
//}
//



//import SwiftUI
//import FirebaseFirestore
//
//struct SellerDetailView: View {
//    // This view correctly receives a property from the previous screen.
//    let property: Property
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                DetailSellerInfoCard(property: property)
//                DetailSellerRatingInfoCard()
//                DetailBiddingInfoCard(property: property)
//            }
//            .padding()
//        }
//        .background(Color(.systemGray6))
//        .navigationTitle("Sellers Details")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}
//
//// MARK: - Subviews with Unique Names
//
//struct DetailSellerInfoCard: View {
//    let property: Property
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack(spacing: 16) {
//                Image("seller")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 80, height: 100)
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//
//                VStack(alignment: .leading, spacing: 6) {
//                    Text(property.sellerName)
//                        .font(.title2)
//                        .fontWeight(.bold)
//                    
//                    HStack(spacing: 4) {
//                        ForEach(0..<5) { _ in
//                            Image(systemName: "star.fill")
//                                .foregroundColor(.yellow)
//                                .font(.caption)
//                        }
//                    }
//                }
//                Spacer()
//            }
//            
//            VStack(spacing: 8) {
//                DetailBidInfoRow(label: "Estimate Haravest", value: "\(property.estimateHarvestUnits) units")
//                DetailBidInfoRow(label: "City", value: property.cityName)
//                DetailBidInfoRow(label: "Highest Bid", value: "150 units") // Placeholder
//                DetailBidInfoRow(label: "Harvest Date", value: property.nextHarvestDate.dateValue().formatted(.dateTime.day().month().year()))
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//
//struct DetailSellerRatingInfoCard: View {
//    var body: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("Seller Rating")
//                .font(.headline)
//                .fontWeight(.bold)
//            
//            DetailRatingInfoRow(label: "Product availability Rating")
//            DetailRatingInfoRow(label: "Unit size rating")
//        }
//        .padding()
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//struct DetailBiddingInfoCard: View {
//    let property: Property
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Bidding")
//                .font(.headline)
//                .fontWeight(.bold)
//
//            VStack(alignment: .leading, spacing: 8) {
//                DetailBidInfoRow(label: "Highest Bid(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by(Per Unit)", value: "")
//                DetailBidInfoRow(label: "Highest Bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Highest Bid by (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per unit)", value: "")
//                DetailBidInfoRow(label: "Your highest bid (Per Kilo)", value: "")
//                DetailBidInfoRow(label: "Contact Number", value: property.mobileNumber)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(16)
//        .shadow(color: .black.opacity(0.05), radius: 10, y: 5)
//    }
//}
//
//// MARK: - Helper Views with Unique Names
//
//struct DetailBidInfoRow: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        HStack {
//            Text(label)
//                .foregroundColor(.secondary)
//            Spacer()
//            Text(value)
//                .fontWeight(.medium)
//        }
//        .font(.subheadline)
//    }
//}
//
//struct DetailRatingInfoRow: View {
//    let label: String
//    
//    var body: some View {
//        HStack {
//            Text(label)
//                .font(.subheadline)
//            Spacer()
//            HStack(spacing: 2) {
//                ForEach(0..<5) { _ in
//                    Image(systemName: "star.fill")
//                        .foregroundColor(.yellow)
//                        .font(.subheadline)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - Preview
//struct SellerDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        // This preview now correctly uses the shared mock object.
//        SellerDetailView(property: Property.mock)
//    }
//}
//

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

// MARK: - Helper Views with Unique Names

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

