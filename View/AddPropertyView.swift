import SwiftUI
import MapKit
import CoreLocation

@MainActor
class AddPropertyViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Form State
    @Published var propertyName = "warakapola1"
    @Published var address = ""
    @Published var mobileNumber = ""
    @Published var estimateHarvestUnits = 3200
    @Published var nextHarvestDate = Date()
    
    // Location State
    @Published var location: CLLocationCoordinate2D?
    @Published var selectedPlaceName: String?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var geocodeDebounceTask: Task<Void, Never>?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            self.selectedPlaceName = "Location access denied."
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location.coordinate
        reverseGeocodeLocation()
    }
    
    func reverseGeocodeLocation() {
        guard let location = self.location else { return }
        
        geocodeDebounceTask?.cancel()
        geocodeDebounceTask = Task {
            do {
                try await Task.sleep(nanoseconds: 500_000_000) // 0.5s debounce
                let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                if let placemarks = try? await geocoder.reverseGeocodeLocation(clLocation),
                   let placemark = placemarks.first {
                    self.selectedPlaceName = placemark.locality ?? placemark.name ?? "Unknown Place"
                } else {
                    self.selectedPlaceName = "Could not determine city"
                }
            } catch {
                print("Geocode task cancelled")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        self.selectedPlaceName = "Location unavailable"
    }
}


struct AddPropertyView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = AddPropertyViewModel()
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    ))
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    FormField(label: "PROPERTY Name") {
                        TextField("Enter property name", text: $viewModel.propertyName)
                    }
                    
                    FormField(label: "Address") {
                        TextField("Enter property address", text: $viewModel.address)
                    }
                    
                    FormField(label: "Mobile Number") {
                        TextField("Enter mobile number", text: $viewModel.mobileNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    FormField(label: "Estimate Harvest") {
                        HStack {
                            TextField("Units", value: $viewModel.estimateHarvestUnits, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                            Text("units")
                                .foregroundColor(.secondary)
                            Spacer()
                            Stepper("", value: $viewModel.estimateHarvestUnits, in: 0...10000)
                        }
                    }
                    
                    FormField(label: "Next Harvest") {
                        HStack {
                            DatePicker(
                                "",
                                selection: $viewModel.nextHarvestDate,
                                displayedComponents: .date
                            )
                            Spacer()
                        }
                    }
                    
                    PropertyLocationPicker(cameraPosition: $cameraPosition, viewModel: viewModel)
                    
                    Button(action: {}) {
                        Text("Confirm")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.top)

                }
                .padding()
            }
            .navigationTitle("Add Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct PropertyLocationPicker: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel
    @State private var isMapFullScreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select your Location")
                .font(.headline)
            
            ZStack(alignment: .topTrailing) {
                PropertyLocationMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
                
                Button(action: { isMapFullScreen.toggle() }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .padding(10)
                        .background(.regularMaterial)
                        .clipShape(Circle())
                }
                .padding()
                .shadow(radius: 5)
            }
            .frame(height: 200)
            .cornerRadius(12)
            .fullScreenCover(isPresented: $isMapFullScreen) {
                PropertyFullScreenMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.secondary)
                Text(viewModel.selectedPlaceName ?? "Move map to select location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
            )
        }
    }
}

struct PropertyLocationMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel

    var body: some View {
        ZStack {
            Map(position: $cameraPosition)
                .onMapCameraChange(frequency: .onEnd) { context in
                    viewModel.location = context.region.center
                    viewModel.reverseGeocodeLocation()
                }
                .overlay {
                    Image(systemName: "mappin")
                        .font(.system(size: 44))
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.25), radius: 4, y: 8)
                        .offset(y: -22)
                }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 10) {
                        Button(action: zoomIn) {
                            Image(systemName: "plus")
                                .padding(10)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                        Button(action: zoomOut) {
                            Image(systemName: "minus")
                                .padding(10)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    private func zoomIn() {
        guard let currentRegion = cameraPosition.region else { return }
        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta / 2, longitudeDelta: currentRegion.span.longitudeDelta / 2)
        withAnimation {
            cameraPosition = .region(MKCoordinateRegion(center: currentRegion.center, span: newSpan))
        }
    }
    
    private func zoomOut() {
        guard let currentRegion = cameraPosition.region else { return }
        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 2, longitudeDelta: currentRegion.span.longitudeDelta * 2)
        withAnimation {
            cameraPosition = .region(MKCoordinateRegion(center: currentRegion.center, span: newSpan))
        }
    }
}

struct PropertyFullScreenMapView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel
    
    @State private var fullScreenCameraPosition: MapCameraPosition

    init(cameraPosition: Binding<MapCameraPosition>, viewModel: AddPropertyViewModel) {
        _cameraPosition = cameraPosition
        self.viewModel = viewModel
        _fullScreenCameraPosition = State(initialValue: .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
        ))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            PropertyLocationMapView(cameraPosition: $fullScreenCameraPosition, viewModel: viewModel)
                .ignoresSafeArea()
                .onDisappear {
                    self.cameraPosition = fullScreenCameraPosition
                }

            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                    .background(.white, in: Circle())
            }
            .padding()
        }
    }
}

struct FormField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            content
        }
    }
}

struct AddPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        AddPropertyView()
    }
}
