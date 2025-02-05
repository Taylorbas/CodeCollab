//
//  PasswordSetup.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import SwiftUI
import Firebase
import Combine

struct PasswordSetupScreen: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var isPasswordSet = false

    var userId: String

    var body: some View {
        NavigationView {
            VStack {
                // Input fields for password and confirmation
                Form {
                    Section(header: Text("Set Your Password")) {
                        SecureField("Enter Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }

                        Button(action: {
                            handlePasswordSetup()
                        }) {
                            Text("Save Password")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()

                // Confirmation after successful password set
                if isPasswordSet {
                    Text("Password set successfully!")
                        .foregroundColor(.green)
                        .padding()
                }
            }
            .navigationTitle("Set Your Password")
        }
    }

    private func handlePasswordSetup() {
        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            return
        }

        if !validatePassword(password) {
            errorMessage = "Password does not meet requirements"
            return
        }

        // Hash and store the password using Firestore
        setPassword(userId: userId, password: password)
    }

    private func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let regex = try! NSRegularExpression(pattern: passwordRegex)
        let range = NSRange(location: 0, length: password.count)
        return regex.firstMatch(in: password, options: [], range: range) != nil
    }

    private func setPassword(userId: String, password: String) {
        // Hashing password logic before saving it (Optional, you could use a hashing function)
        let hashedPassword = password // Replace with actual hashing logic if necessary

        // Store password in Firestore
        Firestore.firestore().collection("users").document(userId).updateData([
            "password": hashedPassword
        ]) { error in
            if let error = error {
                errorMessage = "Error setting password: \(error.localizedDescription)"
            } else {
                errorMessage = nil
                isPasswordSet = true
            }
        }
    }
}
