//
//  TutSignUp.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/20/24.
//

import SwiftUI
struct TutSignUpView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        NavigationView {
            ZStack {
                Color.green // Set background color
                    .ignoresSafeArea() // Covers the entire screen
                VStack(spacing: 20) {
                    Text("Tutor Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 100)
                    TextField("Full Name", text: $fullName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    TextField("Phone Number", text: $phoneNumber)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    TextField("E-mail Address", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .font(.system(size: 18))
                    Button(action: {
                        // Calling the signUp function from the AuthViewModel
                        authViewModel.signUp(fullName: fullName, phoneNumber: phoneNumber, email: email, password: password)
                    }) {
                        Text("Create Account")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline) // Removes title space
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss() // Custom back button action
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.purple)
                            .font(.title2)
                    }
                }
            }
        }
    }
}
struct TutSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        TutSignUpView()
            .environmentObject(AuthViewModel()) // Injecting a mock AuthViewModel for preview
    }
}
