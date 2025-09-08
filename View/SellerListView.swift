
import SwiftUI
import MapKit

struct SellersListView: View {
    @StateObject private var viewModel = SellersListViewModel()
    @State private var searchText = ""
    @State private var sortOption = "Any"
    @State private var harvestEstimate: Double = 0
    
 
    @State private var selectedLocationName: String = "Any"
    @State private var isShowingMapView = false

    private var filteredProperties: [Property] {
     
        let propertiesToFilter = viewModel.properties

       
        let searchedProperties = if searchText.isEmpty {
            propertiesToFilter
        } else {
            propertiesToFilter.filter { property in
                property.propertyName.localizedCaseInsensitiveContains(searchText) ||
                property.sellerName.localizedCaseInsensitiveContains(searchText) ||
                property.cityName.localizedCaseInsensitiveContains(searchText)
            }
        }


        let locatedProperties = if selectedLocationName == "Any" {
            searchedProperties
        } else {
            searchedProperties.filter { $0.cityName.localizedCaseInsensitiveContains(selectedLocationName) }
        }

        let finalProperties = locatedProperties.filter {
            $0.estimateHarvestUnits >= Int(harvestEstimate)
        }

        return finalProperties
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom)

                FilterSortView(
                    sortOption: $sortOption,
                    harvestEstimate: $harvestEstimate,
                    selectedLocationName: $selectedLocationName,
                    isShowingMapView: $isShowingMapView
                )
                .padding(.horizontal)
                .padding(.bottom)

                List {
                    ForEach(filteredProperties) { property in
                        SellerCardView(property: property)
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
                        // Handle back action
                    }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            .sheet(isPresented: $isShowingMapView) {
                SellerLocationPickerView(selectedLocationName: $selectedLocationName)
            }
        }
    }
}

struct FilterSortView: View {
    @Binding var sortOption: String
    @Binding var harvestEstimate: Double
    @Binding var selectedLocationName: String
    @Binding var isShowingMapView: Bool
    
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
                HStack {
                    Text("Estimate Harvest")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(harvestEstimate)) units")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Slider(value: $harvestEstimate, in: 0...10000, step: 100)
                    .accentColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Select Your Location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    isShowingMapView.toggle()
                }) {
                    HStack {
                        Text(selectedLocationName)
                        Spacer()
                        Image(systemName: "map")
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
        }
    }
}

struct SellerLocationPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocationName: String
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
    )
    @State private var currentLocationName: String = "Move map to select..."
    private let geocoder = CLGeocoder()

    var body: some View {
        NavigationView {
            ZStack {
                Map(position: $cameraPosition)
                    .onMapCameraChange(frequency: .onEnd) { context in
                        reverseGeocode(coordinate: context.region.center)
                    }
                    .ignoresSafeArea()
                    .overlay {
                        Image(systemName: "mappin")
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                            .shadow(color: .black.opacity(0.25), radius: 4, y: 8)
                            .offset(y: -22)
                    }
                
                VStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Text(currentLocationName)
                            .font(.headline)
                            .padding()
                            .background(.regularMaterial)
                            .cornerRadius(12)
                        
                        Button(action: {
                            selectedLocationName = currentLocationName
                            dismiss()
                        }) {
                            Text("Confirm Location")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func reverseGeocode(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.currentLocationName = placemark.locality ?? placemark.name ?? "Unknown Location"
            }
        }
    }
}


struct SellerCardView: View {
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

                SellerDetailRow(key: "Property Name:", value: property.propertyName)
                SellerDetailRow(key: "City:", value: property.cityName)
                SellerDetailRow(key: "Estimate Haravest:", value: "\(property.estimateHarvestUnits) units")
                SellerDetailRow(key: "Next Haravest:", value: "\(property.daysUntilNextHarvest) Days")
                SellerDetailRow(key: "Highest Bid:", value: "100 per units") // Placeholder
                
                HStack {
                    Text("Status:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("Available") // Placeholder
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


// MARK: - Preview
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


