//
//  AuthViewModel.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/3/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String? // Holds error messages for login and sign-up
    private var auth = Auth.auth()
    private var db = Firestore.firestore()
    
    func signUp(fullName: String, phoneNumber: String, email: String, password: String) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Error signing up: \(error.localizedDescription)"
                return
            }
            guard let user = authResult?.user else {
                self?.errorMessage = "No user returned during signup"
                return
            }
            print("User signed up with UID: \(user.uid)")
            
            // Save user info and update isAuthenticated after completion
            self?.saveUserInfo(userId: user.uid, fullName: fullName, phoneNumber: phoneNumber, email: email) {
                self?.isAuthenticated = true
                self?.errorMessage = nil // Clear any error message on successful sign-up
            }
        }
    }
    
    func logIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Error logging in: \(error.localizedDescription)"
                return
            }
            guard authResult != nil else {
                self?.errorMessage = "Invalid login combination: Please check Email and Password"
                return
            }
            print("User logged in!")
            self?.isAuthenticated = true
            self?.errorMessage = nil // Clear any error message on successful login
        }
    }
    
    private func saveUserInfo(userId: String, fullName: String, phoneNumber: String, email: String, completion: @escaping () -> Void) {
        db.collection("users").document(userId).setData([
            "fullName": fullName,
            "phoneNumber": phoneNumber,
            "email": email
        ]) { [weak self] error in
            if let error = error {
                self?.errorMessage = "Error saving user information: \(error.localizedDescription)"
            } else {
                print("User information saved successfully!")
                completion()
            }
        }
    }
}
