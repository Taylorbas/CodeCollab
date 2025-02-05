//
//  LoginScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/17/24.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = false
    @State private var passwordError = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.blue
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Log In")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purple)
                        .padding(.bottom, 150)
                    
                    TextField("E-mail", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(emailError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .keyboardType(.emailAddress)
                        .onChange(of: email) { _ in emailError = false }
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(passwordError ? Color.red : Color.black, lineWidth: 2)
                        )
                        .onChange(of: password) { _ in passwordError = false }
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .padding([.horizontal, .bottom], 20)
                    }
                    
                    Button(action: {
                        validateFields()
                        if !emailError && !passwordError {
                            authViewModel.logIn(email: email, password: password)
                        }
                    }) {
                        Text("Log In")
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
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                            .font(.title2)
                    }
                }
            }
        }
    }

    private func validateFields() {
        emailError = email.isEmpty || !email.contains("@")
        passwordError = password.isEmpty

        if emailError {
            authViewModel.errorMessage = "Please enter a valid email"
        } else if passwordError {
            authViewModel.errorMessage = "Please enter a password"
        } else {
            authViewModel.errorMessage = nil // Clear error if all fields are valid
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
