//
//  SignUpView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/3/24.
//


import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var rangerID = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var showError = false
    @State private var isLoading = false
    
    private let userQueries = UserQueries()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                Color("color1").ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 40) {
                        ZStack {
                            Ellipse()
                                .frame(width: 458, height: 428)
                                .padding(.trailing, -500)
                                .foregroundColor(Color("color2"))
                                .padding(.top, -200)
                            
                            Text("Create \nAccount")
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                                .padding(.top, 100)
                        }
                        
                        VStack(spacing: 20) {
                            VStack(spacing: 0) {
                                CustomTextField(placeHolder: "Full Name", imageName: "person", bColor: Color("textColor2"), tOpacity: 1.0, value: $fullName)
                                CustomTextField(placeHolder: "Ranger ID", imageName: "person", bColor: Color("textColor2"), tOpacity: 1.0, value: $rangerID)
                                CustomTextField(placeHolder: "Phone Number", imageName: "phone", bColor: Color("textColor2"), tOpacity: 1.0, value: $phoneNumber)
                                CustomTextField(placeHolder: "Email", imageName: "envelope", bColor: Color("textColor2"), tOpacity: 1.0, value: $email)
                                CustomTextField(placeHolder: "Password", imageName: "lock", bColor: Color("textColor2"), tOpacity: 1.0, value: $password, isSecure: true)
                                CustomTextField(placeHolder: "Confirm Password", imageName: "lock", bColor: Color("textColor2"), tOpacity: 1.0, value: $confirmPassword, isSecure: true)
                            }
                            
                            if showError {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                                    .padding(.bottom, 10)
                            }
                            
                            VStack(alignment: .trailing) {
                                Button(action: signUp) {
                                    if isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        CustomButton(title: "SIGN UP", bgColor: Color("color2"))
                                    }
                                }
                                .disabled(isLoading)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    HStack {
                        Text("Already have an Account?")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                        NavigationLink(destination: SignInView()) {
                            Text("SIGN IN")
                                .font(.system(size: 18))
                                .foregroundColor(Color("color1"))
                                .fontWeight(.bold)
                        }
                    }
                    .frame(height: 63)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("color2"))
                    .ignoresSafeArea()
                }
                
                TopBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
    
    private func signUp() {
        if fullName.isEmpty || rangerID.isEmpty || phoneNumber.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            showError = true
            errorMessage = "Please fill in all fields."
            return
        }
        
        if password != confirmPassword {
            showError = true
            errorMessage = "Passwords do not match."
            return
        }
        
        if !isValidEmail(email) {
            showError = true
            errorMessage = "Invalid email format."
            return
        }
        
        isLoading = true
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                try await userQueries.registerUser(
                    parksideID: authResult.user.uid,
                    email: email,
                    username: fullName,
                    role: "Student"
                )
                isLoading = false
                showError = false
                authViewModel.isAuthenticated = true
                presentationMode.wrappedValue.dismiss()
            } catch {
                isLoading = false
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthViewModel())
    }
}
