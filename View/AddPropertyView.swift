//import SwiftUI
//import MapKit
//import CoreLocation
//
//struct AddPropertyView: View {
//    @Environment(\.dismiss) var dismiss
//    @StateObject private var viewModel: AddPropertyViewModel
//    @EnvironmentObject var sessionStore: SessionStore
//    
//    @State private var cameraPosition: MapCameraPosition
//    
//    private var navigationTitle: String {
//        viewModel.isEditing ? "Edit Property" : "Add Property"
//    }
//    
//    init(propertyToEdit: Property? = nil) {
//        _viewModel = StateObject(wrappedValue: AddPropertyViewModel(propertyToEdit: propertyToEdit))
//        
//        let initialRegion = MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: propertyToEdit?.location.latitude ?? 7.8731, longitude: propertyToEdit?.location.longitude ?? 80.7718),
//            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
//        )
//        _cameraPosition = State(initialValue: .region(initialRegion))
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                ScrollView {
//                    VStack(alignment: .leading, spacing: 24) {
//                        FormField(label: "PROPERTY Name") {
//                            TextField("Enter property name", text: $viewModel.propertyName)
//                        }
//                        
//                        FormField(label: "Seller Name") {
//                            TextField("Enter seller name", text: $viewModel.sellerName)
//                        }
//                        
//                        FormField(label: "Mobile Number") {
//                            TextField("Enter mobile number", text: $viewModel.mobileNumber)
//                                .keyboardType(.phonePad)
//                        }
//                        
//                        FormField(label: "Estimate Harvest") {
//                            HStack {
//                                TextField("Units", value: $viewModel.estimateHarvestUnits, formatter: NumberFormatter())
//                                    .keyboardType(.numberPad)
//                                Text("units")
//                                    .foregroundColor(.secondary)
//                                Spacer()
//                                Stepper("", value: $viewModel.estimateHarvestUnits, in: 0...10000)
//                            }
//                        }
//                        
//                        FormField(label: "Next Harvest") {
//                            HStack {
//                                DatePicker(
//                                    "",
//                                    selection: $viewModel.nextHarvestDate,
//                                    displayedComponents: .date
//                                )
//                                Spacer()
//                            }
//                        }
//                        
//                        PropertyLocationPicker(cameraPosition: $cameraPosition, viewModel: viewModel)
//                        
//                        Button(action: {
//                            if let userId = sessionStore.appUser?.id {
//                                viewModel.saveProperty(userId: userId)
//                            }
//                        }) {
//                            Text("Confirm")
//                                .fontWeight(.semibold)
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.green)
//                                .cornerRadius(12)
//                        }
//                        .padding(.top)
//
//                    }
//                    .padding()
//                }
//                .navigationTitle(navigationTitle)
//                .navigationBarTitleDisplayMode(.inline)
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: { dismiss() }) {
//                            Image(systemName: "arrow.backward")
//                                .foregroundColor(.black)
//                        }
//                    }
//                }
//                .alert(isPresented: $viewModel.showAlert) {
//                    Alert(
//                        title: Text(viewModel.saveSuccess ? "Success" : "Error"),
//                        message: Text(viewModel.alertMessage),
//                        dismissButton: .default(Text("OK")) {
//                            if viewModel.saveSuccess {
//                                dismiss()
//                            }
//                        }
//                    )
//                }
//                
//                if viewModel.isLoading {
//                    Color.black.opacity(0.4).ignoresSafeArea()
//                    ProgressView("Saving...")
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.6))
//                        .cornerRadius(12)
//                }
//            }
//        }
//    }
//}
//
//extension AddPropertyViewModel {
//    var isEditing: Bool {
//        propertyToEdit != nil
//    }
//}
//
//struct PropertyLocationPicker: View {
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: AddPropertyViewModel
//    @State private var isMapFullScreen = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Select your Location")
//                .font(.headline)
//            
//            ZStack(alignment: .topTrailing) {
//                PropertyLocationMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
//                
//                Button(action: { isMapFullScreen.toggle() }) {
//                    Image(systemName: "arrow.up.left.and.arrow.down.right")
//                        .padding(10)
//                        .background(.regularMaterial)
//                        .clipShape(Circle())
//                }
//                .padding()
//                .shadow(radius: 5)
//            }
//            .frame(height: 200)
//            .cornerRadius(12)
//            .fullScreenCover(isPresented: $isMapFullScreen) {
//                PropertyFullScreenMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
//            }
//            
//            HStack {
//                Image(systemName: "location.fill")
//                    .foregroundColor(.secondary)
//                Text(viewModel.selectedPlaceName ?? "Move map to select location")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(.thinMaterial)
//            )
//        }
//    }
//}
//
//struct PropertyLocationMapView: View {
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: AddPropertyViewModel
//
//    var body: some View {
//        ZStack {
//            Map(position: $cameraPosition)
//                .onMapCameraChange(frequency: .onEnd) { context in
//                    viewModel.location = context.region.center
//                    viewModel.reverseGeocodeLocation()
//                }
//                .overlay {
//                    Image(systemName: "mappin")
//                        .font(.system(size: 44))
//                        .foregroundColor(.red)
//                        .shadow(color: .black.opacity(0.25), radius: 4, y: 8)
//                        .offset(y: -22)
//                }
//            
//            VStack {
//                Spacer()
//                HStack {
//                    Spacer()
//                    VStack(spacing: 10) {
//                        Button(action: zoomIn) {
//                            Image(systemName: "plus")
//                                .padding(10)
//                                .background(.regularMaterial)
//                                .clipShape(Circle())
//                        }
//                        Button(action: zoomOut) {
//                            Image(systemName: "minus")
//                                .padding(10)
//                                .background(.regularMaterial)
//                                .clipShape(Circle())
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//    
//    private func zoomIn() {
//        guard let currentRegion = cameraPosition.region else { return }
//        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta / 2, longitudeDelta: currentRegion.span.longitudeDelta / 2)
//        withAnimation {
//            cameraPosition = .region(MKCoordinateRegion(center: currentRegion.center, span: newSpan))
//        }
//    }
//    
//    private func zoomOut() {
//        guard let currentRegion = cameraPosition.region else { return }
//        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 2, longitudeDelta: currentRegion.span.longitudeDelta * 2)
//        withAnimation {
//            cameraPosition = .region(MKCoordinateRegion(center: currentRegion.center, span: newSpan))
//        }
//    }
//}
//
//struct PropertyFullScreenMapView: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: AddPropertyViewModel
//    
//    @State private var fullScreenCameraPosition: MapCameraPosition
//
//    init(cameraPosition: Binding<MapCameraPosition>, viewModel: AddPropertyViewModel) {
//        _cameraPosition = cameraPosition
//        self.viewModel = viewModel
//        _fullScreenCameraPosition = State(initialValue: .region(MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
//            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0))
//        ))
//    }
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            PropertyLocationMapView(cameraPosition: $fullScreenCameraPosition, viewModel: viewModel)
//                .ignoresSafeArea()
//                .onDisappear {
//                    self.cameraPosition = fullScreenCameraPosition
//                }
//
//            Button(action: { dismiss() }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.largeTitle)
//                    .foregroundColor(.secondary)
//                    .background(.white, in: Circle())
//            }
//            .padding()
//        }
//    }
//}
//
//struct FormField<Content: View>: View {
//    let label: String
//    @ViewBuilder let content: Content
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(label)
//                .font(.subheadline)
//                .foregroundColor(.secondary)
//                .fontWeight(.medium)
//            
//            content
//        }
//    }
//}
//
//struct AddPropertyView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPropertyView()
//            .environmentObject(SessionStore())
//    }
//}


import SwiftUI
import MapKit
import CoreLocation

struct AddPropertyView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: AddPropertyViewModel
    @EnvironmentObject var sessionStore: SessionStore
    
    @State private var cameraPosition: MapCameraPosition
    
    init(propertyToEdit: Property? = nil) {
        _viewModel = StateObject(wrappedValue: AddPropertyViewModel(propertyToEdit: propertyToEdit))
        
        let initialRegion: MKCoordinateRegion
        if let property = propertyToEdit {
            let center = CLLocationCoordinate2D(latitude: property.location.latitude, longitude: property.location.longitude)
            initialRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        } else {
            initialRegion = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
                span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
            )
        }
        _cameraPosition = State(initialValue: .region(initialRegion))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    AddPropertyFormField(label: "PROPERTY Name") {
                        TextField("Enter property name", text: $viewModel.propertyName)
                    }
                    
                    AddPropertyFormField(label: "Seller Name") {
                        TextField("Enter seller name", text: $viewModel.sellerName)
                    }
                    
                    AddPropertyFormField(label: "Mobile Number") {
                        TextField("Enter mobile number", text: $viewModel.mobileNumber)
                            .keyboardType(.phonePad)
                    }
                    
                    AddPropertyFormField(label: "Estimate Harvest") {
                        HStack {
                            TextField("Units", value: $viewModel.estimateHarvestUnits, formatter: NumberFormatter())
                                .keyboardType(.numberPad)
                            Text("units")
                                .foregroundColor(.secondary)
                            Spacer()
                            Stepper("", value: $viewModel.estimateHarvestUnits, in: 0...10000)
                        }
                    }
                    
                    AddPropertyFormField(label: "Next Harvest") {
                        HStack {
                            DatePicker("", selection: $viewModel.nextHarvestDate, displayedComponents: .date)
                            Spacer()
                        }
                    }
                    
                    AddPropertyLocationPicker(cameraPosition: $cameraPosition, viewModel: viewModel)
                    
                    Button(action: {
                        if let userId = sessionStore.appUser?.id {
                            viewModel.saveProperty(userId: userId)
                        } else {
                            // Handle the case where the user is not logged in, if necessary
                            viewModel.alertMessage = "You must be logged in to add a property."
                            viewModel.saveSuccess = false
                            viewModel.showAlert = true
                        }
                    }) {
                        Text(viewModel.propertyToEdit == nil ? "Confirm" : "Update")
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
            .navigationTitle(viewModel.propertyToEdit == nil ? "Add Property" : "Edit Property")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            .onAppear {
                viewModel.requestLocationPermission()
            }
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
                ProgressView("Saving...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(16)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
            }
        }
    }
}

// MARK: - Subviews with Unique Names

struct AddPropertyLocationPicker: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel
    @State private var isMapFullScreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select your Location")
                .font(.headline)
            
            AddPropertyMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
                .frame(height: 200)
                .cornerRadius(12)
                .overlay(
                    Button(action: { isMapFullScreen.toggle() }) {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .padding(10)
                            .background(.regularMaterial)
                            .clipShape(Circle())
                    }
                    .padding(8),
                    alignment: .topTrailing
                )
            
            HStack {
                Image(systemName: "location.fill").foregroundColor(.secondary)
                Text(viewModel.cityName ?? "Move map to select location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12).fill(.thinMaterial))
        }
        .fullScreenCover(isPresented: $isMapFullScreen) {
            AddPropertyFullScreenMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
        }
    }
}

struct AddPropertyMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel

    var body: some View {
        Map(position: $cameraPosition)
            .onMapCameraChange(frequency: .onEnd) { context in
                viewModel.location = context.region.center
                viewModel.reverseGeocode()
            }
            .overlay {
                Image(systemName: "mappin")
                    .font(.system(size: 44))
                    .foregroundColor(.red)
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 8)
                    .offset(y: -22)
            }
    }
}

struct AddPropertyFullScreenMapView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: AddPropertyViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AddPropertyMapView(cameraPosition: $cameraPosition, viewModel: viewModel)
                .ignoresSafeArea()

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

struct AddPropertyFormField<Content: View>: View {
    let label: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fontWeight(.medium)
            
            content
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
        }
    }
}


// MARK: - Preview
struct AddPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddPropertyView()
                .environmentObject(SessionStore())
        }
    }
}

