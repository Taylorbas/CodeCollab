//
//  TutLoginView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/20/24.
//

import SwiftUI

struct TutLoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var showPassword = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Tutor Login")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack {
                if showPassword {
                    TextField("Password", text: $password)
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)
                        .autocapitalization(.none)
                }
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye" : "eye.slash")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }

            Button(action: {
                authViewModel.logIn(email: email, password: password)
            }) {
                Text("Login")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            Spacer()

            HStack {
                Text("Don't have an account?")
                Button(action: {
                    // Navigation action to sign-up for tutors
                }) {
                    Text("Sign Up")
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
    }
}

struct TutLoginView_Previews: PreviewProvider {
    static var previews: some View {
        TutLoginView()
            .environmentObject(AuthViewModel())
    }
}
