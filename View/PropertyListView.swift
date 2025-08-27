

import SwiftUI

struct Property: Identifiable {
    let id = UUID()
    let ownerName: String
    let propertyName: String
    let city: String
    let estimateHarvest: Int
    let nextHarvestDays: Int
    let highestBid: Int
    let status: String
    let imageName: String
}


struct PropertyListView: View {
    @State private var searchText = ""
    
  
    let properties: [Property] = [
        Property(ownerName: "Heshan Dunumala", propertyName: "Warakapola 1", city: "Warakapola", estimateHarvest: 2500, nextHarvestDays: 4, highestBid: 100, status: "Available", imageName: "https://placehold.co/300x500/a1e0b8/3d8c5b?text=Farmer"),
        Property(ownerName: "Heshan Dunumala", propertyName: "Warakapola 1", city: "Warakapola", estimateHarvest: 2500, nextHarvestDays: 4, highestBid: 100, status: "Available", imageName: "https://placehold.co/300x500/a1e0b8/3d8c5b?text=Farmer"),
        Property(ownerName: "Heshan Dunumala", propertyName: "Warakapola 1", city: "Warakapola", estimateHarvest: 2500, nextHarvestDays: 4, highestBid: 100, status: "Available", imageName: "https://placehold.co/300x500/a1e0b8/3d8c5b?text=Farmer")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(properties) { property in
                            ListingPropertyCardView(property: property)
                        }
                        
                        AddPropertyButton()
                            .padding(.top)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back action
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .background(Color(.systemGray6).ignoresSafeArea())
        }
    }
}


struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search...", text: $text)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct ListingPropertyCardView: View {
    let property: Property

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: property.imageName)) { image in
                image.resizable()
                     .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color(.systemGray5)
            }
            .frame(width: 100, height: 160)
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 8) {
                Text(property.ownerName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                ListingPropertyDetailRow(key: "Property Name:", value: property.propertyName)
                ListingPropertyDetailRow(key: "City:", value: property.city)
                ListingPropertyDetailRow(key: "Estimate Haravest:", value: "\(property.estimateHarvest) units")
                ListingPropertyDetailRow(key: "Next Haravest:", value: "\(property.nextHarvestDays) Days")
                ListingPropertyDetailRow(key: "Highest Bid:", value: "\(property.highestBid) per units")
                
                HStack {
                    Text("Status:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text(property.status)
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

struct ListingPropertyDetailRow: View {
    let key: String
    let value: String

    var body: some View {
        HStack {
            Text(key)
                .font(.footnote)
                .foregroundColor(.secondary)
            Text(value)
                .font(.footnote)
                .fontWeight(.medium)
            Spacer()
        }
    }
}

struct AddPropertyButton: View {
    var body: some View {
        Button(action: {
            
        }) {
            Text("Add your Property")
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}


struct PropertyListView_Previews: PreviewProvider {
    static var previews: some View {
        
        TabView {
            PropertyListView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            Text("Requirement Screen")
                .tabItem {
                    Label("Requirement", systemImage: "list.bullet.rectangle")
                }
            
            Text("Transactions Screen")
                .tabItem {
                    Label("Transactions", systemImage: "dollarsign.arrow.circle.fill")
                }
            
            Text("Account Screen")
                .tabItem {
                    Label("Account", systemImage: "person.fill")
                }
        }
    }
}
