import SwiftUI
import MapKit

struct SignUpView: View {
    
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showAlert = false
    
    @State private var pinLocation = CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718)
    
    @State private var cameraPosition: MapCameraPosition = .region(MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    ))

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
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
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Select your location")
                            .font(.headline)
                        
                        MapReader { proxy in
                            Map(position: $cameraPosition) {
                                Annotation("Your Location", coordinate: pinLocation) {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.title)
                                        .foregroundColor(.red)
                                        .gesture(
                                            DragGesture()
                                                .onChanged { value in
                                                    if let newCoordinate = proxy.convert(value.location, from: .local) {
                                                        self.pinLocation = newCoordinate
                                                    }
                                                }
                                                .onEnded { value in
                                                    viewModel.location = self.pinLocation
                                                }
                                        )
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(10)
                            .onAppear {
                                viewModel.location = self.pinLocation
                            }
                        }
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

