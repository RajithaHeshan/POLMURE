import SwiftUI
import MapKit

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showAlert = false
    
    @State private var pinLocation = CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718)
    @State private var isDragging = false
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    ))

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    SignUpFormFields(viewModel: viewModel)
                    
                    LocationPicker(
                        pinLocation: $pinLocation,
                        cameraPosition: $cameraPosition,
                        isDragging: $isDragging,
                        viewModel: viewModel
                    )
                    
                    Button(action: viewModel.signUp) {
                        Text("Create Account")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .padding(.top, 20)
                    
                }
                .padding()
            }
            .navigationTitle("Create Account")
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: viewModel.errorMessage) {
                if viewModel.errorMessage != nil {
                    showAlert = true
                }
            }
            .alert("Error", isPresented: $showAlert, actions: {
                Button("OK") {}
            }, message: {
                Text(viewModel.errorMessage ?? "An unknown error occurred.")
            })
        }
    }
}

private struct SignUpFormFields: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        Group {
            VStack(alignment: .leading, spacing: 5) {
                Text("Username")
                    .font(.headline)
                TextField("Enter your username", text: $viewModel.username)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textContentType(.username)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Full Name")
                    .font(.headline)
                TextField("Enter your full name", text: $viewModel.fullName)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textContentType(.name)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Buyer or seller")
                    .font(.headline)
                
                HStack {
                    Picker("Select user type", selection: $viewModel.userType) {
                        ForEach(SignUpViewModel.UserType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(.thinMaterial)
                .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Email")
                    .font(.headline)
                TextField("Enter your email", text: $viewModel.email)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Password")
                    .font(.headline)
                SecureField("Enter your password", text: $viewModel.password)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textContentType(.newPassword)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Confirm Password")
                    .font(.headline)
                SecureField("Re-enter your password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10)
                    .textContentType(.newPassword)
            }
        }
    }
}

private struct LocationPicker: View {
    @Binding var pinLocation: CLLocationCoordinate2D
    @Binding var cameraPosition: MapCameraPosition
    @Binding var isDragging: Bool
    @ObservedObject var viewModel: SignUpViewModel
    
    @State private var isMapFullScreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Select your location")
                .font(.headline)
            
            ZStack(alignment: .topTrailing) {
                MapView(
                    pinLocation: $pinLocation,
                    cameraPosition: $cameraPosition,
                    isDragging: $isDragging,
                    viewModel: viewModel
                )
                
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
            .cornerRadius(10)
            .fullScreenCover(isPresented: $isMapFullScreen) {
                FullScreenMapView(
                    pinLocation: $pinLocation,
                    cameraPosition: $cameraPosition,
                    isDragging: $isDragging,
                    viewModel: viewModel
                )
            }
        }
    }
}

private struct MapView: View {
    @Binding var pinLocation: CLLocationCoordinate2D
    @Binding var cameraPosition: MapCameraPosition
    @Binding var isDragging: Bool
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: pinLocation) {
                        Image(systemName: "mappin")
                            .font(.system(size: 44))
                            .foregroundColor(.accentColor)
                            .shadow(color: .black.opacity(0.25), radius: 4, y: 8)
                            .offset(y: -22)
                            .gesture(
                                LongPressGesture(minimumDuration: 0.25)
                                    .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
                                    .onChanged { value in
                                        switch value {
                                        case .first(true):
                                            isDragging = true
                                        case .second(true, let drag):
                                            if let location = drag?.location, let newCoordinate = proxy.convert(location, from: .global) {
                                                pinLocation = newCoordinate
                                            }
                                        default:
                                            break
                                        }
                                    }
                                    .onEnded { value in
                                        isDragging = false
                                        viewModel.location = pinLocation
                                    }
                            )
                    }
                }
                .onAppear { viewModel.location = pinLocation }
            }
            
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
            .padding()
            .shadow(radius: 5)
        }
    }
    
    private func zoomIn() {
        guard let currentRegion = cameraPosition.region else { return }
        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta / 2, longitudeDelta: currentRegion.span.longitudeDelta / 2)
        let newRegion = MKCoordinateRegion(center: currentRegion.center, span: newSpan)
        withAnimation { cameraPosition = .region(newRegion) }
    }
    
    private func zoomOut() {
        guard let currentRegion = cameraPosition.region else { return }
        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 2, longitudeDelta: currentRegion.span.longitudeDelta * 2)
        let newRegion = MKCoordinateRegion(center: currentRegion.center, span: newSpan)
        withAnimation { cameraPosition = .region(newRegion) }
    }
}

private struct FullScreenMapView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var pinLocation: CLLocationCoordinate2D
    @Binding var cameraPosition: MapCameraPosition
    @Binding var isDragging: Bool
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            MapView(
                pinLocation: $pinLocation,
                cameraPosition: $cameraPosition,
                isDragging: $isDragging,
                viewModel: viewModel
            )
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

