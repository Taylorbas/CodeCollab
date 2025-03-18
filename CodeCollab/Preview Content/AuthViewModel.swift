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
    @Published var errorMessage: String?
    @Published var userFullName: String = ""
    @Published var userEmail: String = ""
    @Published var userPhone: String = ""
    @Published var currentUser: Contact?
    @Published var senderID: String? // Added senderID
    @Published var receiverID: String? // Added receiverID
    @Published var messages: [Message] = [] // Added messages array
    @Published var userProfilePicture: String = ""
    private var auth = Auth.auth()
    internal var db = Firestore.firestore()
    init() {
        checkAuthenticationState()
    }
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
            let newUser = Contact(id: user.uid, name: fullName, phoneNumber: phoneNumber, profilePicture: nil, role: "Student")
            self?.saveUserInfo(user: newUser) {
                self?.isAuthenticated = true
                self?.errorMessage = nil
                self?.currentUser = newUser
                self?.senderID = user.uid // Set senderID after signup
            }
        }
    }
    func logIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.errorMessage = "Error logging in: \(error.localizedDescription)"
                return
            }
            guard let user = authResult?.user else {
                self?.errorMessage = "Invalid login combination: Please check Email and Password"
                return
            }
            print("User logged in!")
            self?.isAuthenticated = true
            self?.errorMessage = nil
            self?.senderID = user.uid // Set senderID after login
            self?.fetchUserData()
        }
    }
    private func saveUserInfo(user: Contact, completion: @escaping () -> Void) {
        guard let userId = user.id else { return }
        do {
            try db.collection("users").document(userId).setData(from: user) { error in
                if let error = error {
                    self.errorMessage = "Error saving user information: \(error.localizedDescription)"
                } else {
                    print("User information saved successfully!")
                    completion()
                }
            }
        } catch {
            self.errorMessage = "Error encoding user data: \(error.localizedDescription)"
        }
    }
    func sendPasswordResetEmail(to email: String, completion: @escaping (Bool, String?) -> Void) {
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(false, "Error sending password reset email: \(error.localizedDescription)")
            } else {
                completion(true, nil)
            }
        }
    }
    func logOut() {
        do {
            try auth.signOut()
            isAuthenticated = false
            currentUser = nil
            senderID = nil // Clear senderID on logout
        } catch {
            errorMessage = "Error logging out: \(error.localizedDescription)"
        }
    }
    func fetchUserData() {
            guard let userId = auth.currentUser?.uid else {
                print("No logged-in user")
                return
            }
            db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                guard let data = snapshot?.data() else {
                    print("No data found for user")
                    return
                }
                self?.userFullName = data["fullName"] as? String ?? "Unknown Name"
                self?.userEmail = data["email"] as? String ?? "Unknown Email"
                self?.userPhone = data["phoneNumber"] as? String ?? "Unknown Phone Number"
                self?.userProfilePicture = data["profilePicture"] as? String ?? "defaultProfilePicture"
            }
        }
    func loadMessages() {
        guard let currentUserID = senderID, let receiverID = receiverID else {
            print("User or receiver ID not set.")
            return
        }
        let db = Firestore.firestore()
        db.collection("messages")
            .whereField("senderID", in: [currentUserID, receiverID])
            .whereField("receiverID", in: [currentUserID, receiverID])
            .order(by: "timestamp")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error loading messages: \(error)")
                    return
                }
                self.messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return Message(
                        id: document.documentID,
                        senderID: data["senderID"] as? String ?? "",
                        receiverID: data["receiverID"] as? String ?? "",
                        text: data["text"] as? String ?? "",
                        timestamp: (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                    )
                } ?? []
            }
    }
    private func checkAuthenticationState() {
        if let user = auth.currentUser {
            isAuthenticated = true
            senderID = user.uid
            fetchUserData() // No argument
        } else {
            isAuthenticated = false
            senderID = nil
        }
    }
}
