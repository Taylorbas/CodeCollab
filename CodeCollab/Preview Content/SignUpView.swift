//
//  SignUpView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/3/24.
//


import SwiftUI
struct SignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = "" // Error message state
    @State private var showError = false // Boolean to toggle error visibility
    // Error states for each field
    @State private var fullNameError = false
    @State private var phoneNumberError = false
    @State private var emailError = false
    @State private var passwordError = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    Text("Student Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.bottom, 100)
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                            .padding(.bottom, 10)
                    }
                    TextField("Full Name", text: $fullName, onEditingChanged: { _ in
                        fullNameError = false
                    })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(fullNameError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    TextField("Phone Number", text: $phoneNumber, onEditingChanged: { _ in
                        phoneNumberError = false
                    })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(phoneNumberError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    TextField("E-mail Address", text: $email, onEditingChanged: { _ in
                        emailError = false
                    })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(emailError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password, onCommit: {
                        passwordError = false
                    })
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(passwordError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    Button(action: {
                        // Validation checks
                        fullNameError = fullName.isEmpty
                        phoneNumberError = phoneNumber.isEmpty
                        emailError = email.isEmpty || !isValidEmail(email)
                        passwordError = password.isEmpty
                        if fullNameError || phoneNumberError || emailError || passwordError {
                            showError = true
                            errorMessage = "Please fill in all information."
                            if emailError && !email.isEmpty {
                                errorMessage = "Enter a valid email."
                            }
                        } else {
                            showError = false
                            authViewModel.signUp(fullName: fullName, phoneNumber: phoneNumber, email: email, password: password)
                        }
                    }) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                            .font(.title2)
                    }
                }
            }
        }
    }
    // Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailFormat = "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AuthViewModel())
    }
}
