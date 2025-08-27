//import SwiftUI
//import MapKit
//import PhotosUI
//
//struct SignUpView: View {
//    
//    @StateObject private var viewModel = SignUpViewModel()
//    @State private var showAlert = false
//    
//    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
//        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
//    ))
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 20) {
//                    
//                    ProfileImageView(viewModel: viewModel)
//                        
//                    SignUpFormFields(viewModel: viewModel)
//                        
//                    if viewModel.userType == .buyer {
//                        LocationPicker(
//                            cameraPosition: $cameraPosition,
//                            viewModel: viewModel
//                        )
//                    }
//                        
//                    Button(action: viewModel.signUp) {
//                        Text("Create Account")
//                            .fontWeight(.semibold)
//                            .frame(maxWidth: .infinity)
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .padding(.top, 20)
//                        
//                }
//                .padding()
//            }
//            .navigationTitle("Create Account")
//            .navigationBarTitleDisplayMode(.inline)
//            .onChange(of: viewModel.errorMessage) {
//                if viewModel.errorMessage != nil {
//                    showAlert = true
//                }
//            }
//            .alert("Error", isPresented: $showAlert, actions: {
//                Button("OK") {}
//            }, message: {
//                Text(viewModel.errorMessage ?? "An unknown error occurred.")
//            })
//        }
//    }
//}
//
//private struct ProfileImageView: View {
//    @ObservedObject var viewModel: SignUpViewModel
//
//    var body: some View {
//        HStack {
//            Spacer()
//            if let image = viewModel.profileImage {
//                image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 120, height: 120)
//                    .clipShape(Circle())
//                    .padding(.bottom)
//            } else {
//                ZStack {
//                    Circle()
//                        .fill(.thinMaterial)
//                    Image(systemName: "person.fill")
//                        .font(.system(size: 60))
//                        .foregroundColor(.secondary)
//                }
//                .frame(width: 120, height: 120)
//                .padding(.bottom)
//            }
//            Spacer()
//        }
//    }
//}
//
//private struct SignUpFormFields: View {
//    @ObservedObject var viewModel: SignUpViewModel
//
//    var body: some View {
//        Group {
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Username")
//                    .font(.headline)
//                TextField("Enter your username", text: $viewModel.username)
//                    .padding()
//                    .background(.thinMaterial)
//                    .cornerRadius(10)
//                    .textContentType(.username)
//                    .autocapitalization(.none)
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Full Name")
//                    .font(.headline)
//                TextField("Enter your full name", text: $viewModel.fullName)
//                    .padding()
//                    .background(.thinMaterial)
//                    .cornerRadius(10)
//                    .textContentType(.name)
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Buyer or seller")
//                    .font(.headline)
//                
//                HStack {
//                    Picker("Select user type", selection: $viewModel.userType) {
//                        ForEach(UserType.allCases, id: \.self) { type in
//                            Text(type.rawValue).tag(type)
//                        }
//                    }
//                    .pickerStyle(.menu)
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .padding(.vertical, 12)
//                .background(.thinMaterial)
//                .cornerRadius(10)
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Email")
//                    .font(.headline)
//                TextField("Enter your email", text: $viewModel.email)
//                    .padding()
//                    .background(.thinMaterial)
//                    .cornerRadius(10)
//                    .textContentType(.emailAddress)
//                    .keyboardType(.emailAddress)
//                    .autocapitalization(.none)
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Password")
//                    .font(.headline)
//                SecureField("Enter your password", text: $viewModel.password)
//                    .padding()
//                    .background(.thinMaterial)
//                    .cornerRadius(10)
//                    .textContentType(.newPassword)
//            }
//            
//            VStack(alignment: .leading, spacing: 5) {
//                Text("Confirm Password")
//                    .font(.headline)
//                SecureField("Re-enter your password", text: $viewModel.confirmPassword)
//                    .padding()
//                    .background(.thinMaterial)
//                    .cornerRadius(10)
//                    .textContentType(.newPassword)
//            }
//        }
//    }
//}
//
//private struct LocationPicker: View {
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: SignUpViewModel
//    
//    @State private var isMapFullScreen = false
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            Text("Select your location")
//                .font(.headline)
//            
//            ZStack(alignment: .topTrailing) {
//                SignUpMapView(
//                    cameraPosition: $cameraPosition,
//                    viewModel: viewModel
//                )
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
//            .cornerRadius(10)
//            .fullScreenCover(isPresented: $isMapFullScreen) {
//                SignUpFullScreenMapView(
//                    cameraPosition: $cameraPosition,
//                    viewModel: viewModel
//                )
//            }
//            
//            HStack {
//                Image(systemName: "location.fill")
//                    .foregroundColor(.secondary)
//                Text(viewModel.selectedPlaceName ?? "Move map to select location")
//                    .font(.subheadline)
//                    .foregroundColor(.secondary)
//            }
//            .padding(.horizontal)
//            .padding(.vertical, 12)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(.thinMaterial)
//            .cornerRadius(10)
//        }
//    }
//}
//
//private struct SignUpMapView: View {
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: SignUpViewModel
//
//    var body: some View {
//        ZStack(alignment: .bottomTrailing) {
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
//            VStack(spacing: 10) {
//                Button(action: zoomIn) {
//                    Image(systemName: "plus")
//                        .padding(10)
//                        .background(.regularMaterial)
//                        .clipShape(Circle())
//                }
//                Button(action: zoomOut) {
//                    Image(systemName: "minus")
//                        .padding(10)
//                        .background(.regularMaterial)
//                        .clipShape(Circle())
//                }
//            }
//            .padding()
//            .shadow(radius: 5)
//        }
//        .onAppear {
//            if let initialCenter = cameraPosition.region?.center {
//                viewModel.location = initialCenter
//                viewModel.reverseGeocodeLocation()
//            }
//        }
//    }
//    
//    private func zoomIn() {
//        guard let currentRegion = cameraPosition.region else { return }
//        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta / 2, longitudeDelta: currentRegion.span.longitudeDelta / 2)
//        let newRegion = MKCoordinateRegion(center: currentRegion.center, span: newSpan)
//        withAnimation { cameraPosition = .region(newRegion) }
//    }
//    
//    private func zoomOut() {
//        guard let currentRegion = cameraPosition.region else { return }
//        let newSpan = MKCoordinateSpan(latitudeDelta: currentRegion.span.latitudeDelta * 2, longitudeDelta: currentRegion.span.longitudeDelta * 2)
//        let newRegion = MKCoordinateRegion(center: currentRegion.center, span: newSpan)
//        withAnimation { cameraPosition = .region(newRegion) }
//    }
//}
//
//private struct SignUpFullScreenMapView: View {
//    @Environment(\.dismiss) var dismiss
//    @Binding var cameraPosition: MapCameraPosition
//    @ObservedObject var viewModel: SignUpViewModel
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            SignUpMapView(
//                cameraPosition: $cameraPosition,
//                viewModel: viewModel
//            )
//            .ignoresSafeArea()
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
//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}


import SwiftUI
import MapKit
import PhotosUI

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showAlert = false
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    ))

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    ProfileImageView(viewModel: viewModel)
                        
                    SignUpFormFields(viewModel: viewModel)
                        
                    if viewModel.userType == .buyer {
                        LocationPicker(
                            cameraPosition: $cameraPosition,
                            viewModel: viewModel
                        )
                    }
                        
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

private struct ProfileImageView: View {
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        HStack {
            Spacer()
            if let image = viewModel.profileImage {
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .padding(.bottom)
            } else {
                ZStack {
                    Circle()
                        .fill(.thinMaterial)
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)
                }
                .frame(width: 120, height: 120)
                .padding(.bottom)
            }
            Spacer()
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
                        ForEach(UserType.allCases, id: \.self) { type in
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
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: SignUpViewModel
    
    @State private var isMapFullScreen = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select your location")
                .font(.headline)
            
            ZStack(alignment: .topTrailing) {
                SignUpMapView(
                    cameraPosition: $cameraPosition,
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
                SignUpFullScreenMapView(
                    cameraPosition: $cameraPosition,
                    viewModel: viewModel
                )
            }
            
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.secondary)
                Text(viewModel.selectedPlaceName ?? "Move map to select location")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .cornerRadius(10)
        }
    }
}

private struct SignUpMapView: View {
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
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
        .onAppear {
            if let initialCenter = cameraPosition.region?.center {
                viewModel.location = initialCenter
                viewModel.reverseGeocodeLocation()
            }
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

private struct SignUpFullScreenMapView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var cameraPosition: MapCameraPosition
    @ObservedObject var viewModel: SignUpViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            SignUpMapView(
                cameraPosition: $cameraPosition,
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
