import SwiftUI

struct PropertyListView: View {
    @StateObject private var viewModel = PropertyListViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom)

                List {
                    ForEach(viewModel.properties) { property in
                        NavigationLink(destination: Text("Detail view for \(property.propertyName)")) {
                            ListingPropertyCardView(property: property)
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                // Handle edit action
                                // e.g., viewModel.edit(property)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Handle delete action
                                // e.g., viewModel.delete(property)
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    
                    AddPropertyButton()
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .background(Color(.systemGray6))
            }
            .navigationTitle("Property")
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
            Image("seller")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 160)
                .background(Color(.systemGray5))
                .cornerRadius(12)
                .clipped()


            VStack(alignment: .leading, spacing: 8) {
                Text(property.sellerName)
                    .font(.headline)
                    .fontWeight(.bold)
                
                ListingPropertyDetailRow(key: "Property Name:", value: property.propertyName)
                ListingPropertyDetailRow(key: "City:", value: property.cityName)
                ListingPropertyDetailRow(key: "Mobile:", value: property.mobileNumber)
                ListingPropertyDetailRow(key: "Estimate Haravest:", value: "\(property.estimateHarvestUnits) units")
                ListingPropertyDetailRow(key: "Next Haravest:", value: "\(property.daysUntilNextHarvest) Days")
                
                HStack {
                    Text("Status:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Available") // Assuming status is always available for now
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
        NavigationLink(destination: AddPropertyView()) {
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

// MARK: - Preview
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

