//
//  EtheriumEmailService.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import SwiftUI
struct EthereumEmailServiceView: View {
    // Instance of BlockchainServices
    private let blockchainServices = BlockchainServices()
    // State variables for user input and UI feedback
    @State private var parksideID: String = ""
    @State private var email: String = ""
    @State private var isProcessing: Bool = false
    @State private var statusMessage: String = ""
    @State private var showAlert: Bool = false
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Student Ethereum Signup")
                .font(.title)
                .fontWeight(.bold)
            // Parkside ID input
            TextField("Enter Parkside ID", text: $parksideID)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            // Generic email input (no Ranger-specific requirement)
            TextField("Enter Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            // Signup button
            Button(action: {
                Task {
                    await registerStudent()
                }
            }) {
                Text(isProcessing ? "Processing..." : "Sign Up with Ethereum")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isProcessing ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(isProcessing || parksideID.isEmpty || email.isEmpty)
            .padding(.horizontal)
            // Status message
            Text(statusMessage)
                .foregroundColor(statusMessage.contains("Error") ? .red : .green)
                .font(.subheadline)
                .padding(.top, 10)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Signup Status"),
                message: Text(statusMessage),
                dismissButton: .default(Text("OK")) {
                    statusMessage = "" // Clear message after alert
                }
            )
        }
    }
    // Function to handle registration
    private func registerStudent() async {
        guard !parksideID.isEmpty, !email.isEmpty else {
            statusMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        // Basic email format check (no domain restriction)
        guard email.contains("@") && email.contains(".") else {
            statusMessage = "Please enter a valid email address."
            showAlert = true
            return
        }
        isProcessing = true
        statusMessage = ""
        // Call BlockchainServices to register and send Ethereum address
        await blockchainServices.registerAndSendEthereumAddress(
            parksideID: parksideID,
            rangerEmail: email // Using generic email now
        )
        // Simulate checking the result
        let result = await blockchainServices.sendEthereumAddress(
            rangerEmail: email,
            ethereumAddress: blockchainServices.getEthereumAddress(
                privateKey: blockchainServices.generateEthereumKey()
            )
        )
        isProcessing = false
        if result == "Success" {
            statusMessage = "Signup successful! Ethereum address registered."
        } else {
            statusMessage = "Error during signup. Please try again."
        }
        showAlert = true
    }
}
// Preview for SwiftUI
struct EthereumEmailServiceView_Previews: PreviewProvider {
    static var previews: some View {
        EthereumEmailServiceView()
    }
}
