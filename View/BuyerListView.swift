import SwiftUI
import MapKit

struct BuyersListView: View {
    @StateObject private var viewModel = BuyersListViewModel()
    
    @State private var searchText = ""
    @State private var scaleOption = "Any"
    @State private var sortOption = "Any"
    @State private var selectedLocationName: String = "Any"
    @State private var isShowingMapView = false

    private var filteredBuyers: [AppUser] {
        var filtered = viewModel.buyers

        // 1. Filter by search text (if any)
        if !searchText.isEmpty {
            filtered = filtered.filter { buyer in
                buyer.fullName.localizedCaseInsensitiveContains(searchText) ||
                (buyer.selectedPlaceName ?? "").localizedCaseInsensitiveContains(searchText)
            }
        }

        // 2. Filter by selected location name
        if selectedLocationName != "Any" {
            filtered = filtered.filter { buyer in
                (buyer.selectedPlaceName ?? "").localizedCaseInsensitiveContains(selectedLocationName)
            }
        }
        
        // Sorting logic for "Highest price" or "Highest Rating" could be added here later.

        return filtered
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        BuyerFilterView(
                            searchText: $searchText,
                            scaleOption: $scaleOption,
                            sortOption: $sortOption,
                            selectedLocationName: $selectedLocationName,
                            isShowingMapView: $isShowingMapView
                        )
                        
                        LazyVStack(spacing: 16) {
                            // The ForEach loop now uses the filtered list.
                            ForEach(filteredBuyers) { buyer in
                                BuyerCardView(buyer: buyer)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Buyers")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .background(Color(.systemGray6))
            .sheet(isPresented: $isShowingMapView) {
                BuyerLocationPickerView(selectedLocationName: $selectedLocationName)
            }
        }
    }
}


// MARK: - Subviews

struct BuyerFilterView: View {
    @Binding var searchText: String
    @Binding var scaleOption: String
    @Binding var sortOption: String
    @Binding var selectedLocationName: String
    @Binding var isShowingMapView: Bool
    
    let scaleOptions = ["Any", "Small", "Medium", "Large"]
    let sortOptions = ["Any", "Highest price", "Highest Rating"]

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search...", text: $searchText)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
            
            FilterPicker(label: "Scale", selection: $scaleOption, options: scaleOptions)
            FilterPicker(label: "Sort By", selection: $sortOption, options: sortOptions)

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

struct BuyerLocationPickerView: View {
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


struct FilterPicker: View {
    let label: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        Menu {
            Picker(label, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option)
                }
            }
        } label: {
            HStack {
                Text(selection)
                Spacer()
                Image(systemName: "chevron.down")
            }
            .foregroundColor(.primary)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray4)))
        }
    }
}

struct BuyerCardView: View {
    let buyer: AppUser

    var body: some View {
        HStack(spacing: 16) {
            Image("seller") // Placeholder image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(buyer.fullName)
                    .font(.headline)
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
        .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
    }
}


// MARK: - Preview
struct BuyersListView_Previews: PreviewProvider {
    static var previews: some View {
        BuyersListView()
    }
}

