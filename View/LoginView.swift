import SwiftUI

struct LoginView: View {

    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.accentColor)
                    .padding(.bottom, 20)
                
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(spacing: 15) {
                    TextField("Email", text: $viewModel.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)

                    SecureField("Password", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(10)
                }
                
                Button("Forgot Password?", action: viewModel.forgotPassword)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                Button(action: viewModel.login) {
                    Text("Log In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 10)

                Divider()
                    .padding(.vertical, 15)

                // Updated "Sign in with Google" button
                Button(action: viewModel.signInWithGoogle) {
                    HStack {
                        Image("google") // Your custom icon from assets
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                        
                        Text("Sign in with Google")
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                    Button("Sign Up", action: viewModel.createAccount)
                        .fontWeight(.semibold)
                }
                .font(.subheadline)

            }
            .padding(30)
            .navigationTitle("Log In")
            .navigationBarHidden(true)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

