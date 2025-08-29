import SwiftUI

struct SellersListView: View {
    @State private var searchText = ""
    @State private var sortOption = "Any"
    @State private var harvestEstimate: Double = 50

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom)

                FilterSortView(sortOption: $sortOption, harvestEstimate: $harvestEstimate)
                    .padding(.horizontal)
                    .padding(.bottom)

                List {
                   
                    ForEach(0..<3) { _ in
                        SellerCardView()
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.plain)
                .background(Color(.systemGray6))
            }
            .navigationTitle("Sellers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct FilterSortView: View {
    @Binding var sortOption: String
    @Binding var harvestEstimate: Double
    
    let sortOptions = ["Any", "Nearest", "Highest Bid"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sort By")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Menu {
                    Picker(selection: $sortOption, label: EmptyView()) {
                        ForEach(sortOptions, id: \.self) { option in
                            Text(option).tag(option)
                        }
                    }
                } label: {
                    HStack {
                        Text(sortOption)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .foregroundColor(.primary)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Estimate Harvest")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Slider(value: $harvestEstimate, in: 0...100, step: 1)
                    .accentColor(.blue)
            }
        }
    }
}


struct SellerCardView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("seller")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 160)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .clipped()

            VStack(alignment: .leading, spacing: 8) {
                Text("Heshan Dunumala")
                    .font(.headline)
                    .fontWeight(.bold)

                SellerDetailRow(key: "Property Name:", value: "Warakapola 1")
                SellerDetailRow(key: "City:", value: "Warakapola")
                SellerDetailRow(key: "Estimate Haravest:", value: "2500 units")
                SellerDetailRow(key: "Next Haravest:", value: "4 Days")
                SellerDetailRow(key: "Highest Bid:", value: "100 per units")
                
                HStack {
                    Text("Status:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Available")
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

struct SellerDetailRow: View {
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



struct SellersListView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            SellersListView()
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


