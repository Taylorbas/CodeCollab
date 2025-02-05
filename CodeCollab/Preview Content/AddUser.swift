//
//  addUser.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import UIKit
//import Firebase
//import web3swift
//
//class AddUserViewController: UIViewController {
//    
//    // Firestore and Blockchain Services
//    private let firestoreService = Firestore.firestore()
//    
//    // UI Elements
//    private let parksideIDTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter Parkside ID"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//    
//    private let rangerEmailTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter Ranger Email"
//        textField.borderStyle = .roundedRect
//        return textField
//    }()
//    
//    private let addUserButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Add Admin User", for: .normal)
//        button.addTarget(self, action: #selector(addUser), for: .touchUpInside)
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        navigationItem.title = "Add Admin User"
//        
//        // Stack View for Layout
//        let stackView = UIStackView(arrangedSubviews: [parksideIDTextField, rangerEmailTextField, addUserButton])
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(stackView)
//        
//        // Layout Constraints
//        NSLayoutConstraint.activate([
//            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
//        ])
//    }
//    
//    @objc private func addUser() {
//        guard let parksideID = parksideIDTextField.text, !parksideID.isEmpty,
//              let rangerEmail = rangerEmailTextField.text, !rangerEmail.isEmpty else {
//            showAlert(message: "Please fill in all fields.")
//            return
//        }
//        
//        do {
//            // Step 1: Generate Ethereum Private Key and Address
//            let privateKey = try EthereumPrivateKey()
//            let ethereumAddress = privateKey.address.hex(eip55: true)
//
//            // Step 2: Save user details to Firestore
//            saveUserDetailsToFirestore(username: "JohnDoe",
//                                        email: rangerEmail,
//                                        ethereumAddress: ethereumAddress,
//                                        role: "admin",
//                                        bio: "Blockchain enthusiast",
//                                        profilePicture: "https://example.com/profile.jpg")
//        } catch {
//            showAlert(message: "Failed to generate Ethereum key: \(error.localizedDescription)")
//        }
//    }
//    
//    private func saveUserDetailsToFirestore(username: String, email: String, ethereumAddress: String, role: String, bio: String, profilePicture: String) {
//        let userData: [String: Any] = [
//            "username": username,
//            "email": email,
//            "ethereumAddress": ethereumAddress,
//            "role": role,
//            "bio": bio,
//            "profilePicture": profilePicture
//        ]
//        
//        firestoreService.collection("users").addDocument(data: userData) { error in
//            if let error = error {
//                self.showAlert(message: "Failed to add user to Firestore: \(error.localizedDescription)")
//            } else {
//                self.showAlert(message: "Admin user added successfully!")
//            }
//        }
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//}
//
