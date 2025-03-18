//
//  SettingsView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isMusicEnabled") private var isMusicEnabled: Bool = true
    @AppStorage("isNotificationsEnabled") private var isNotificationsEnabled: Bool = true
    @AppStorage("isLocationEnabled") private var isLocationEnabled: Bool = false
    @AppStorage("cryptoWalletAddress") private var cryptoWalletAddress: String = "" // 🔹 Persisted Wallet Address
    @State private var showLogoutConfirmation = false
    @State private var showSwitchToTutorConfirmation = false
    @State private var navigateToTutorLogin = false
    @State private var showInvalidAddressAlert = false
    
    var body: some View {
        NavigationView {
            Form {
            
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                }
                
               
                Section(header: Text("Crypto Wallet")) {
                    TextField("Enter Wallet Address", text: $cryptoWalletAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if isValidCryptoAddress(cryptoWalletAddress) {
                            print("Wallet Set: \(cryptoWalletAddress)")
                        } else {
                            showInvalidAddressAlert = true
                        }
                    }) {
                        Text("Save Wallet")
                            .foregroundColor(.blue)
                    }
                    .alert(isPresented: $showInvalidAddressAlert) {
                        Alert(title: Text("Invalid Address"), message: Text("Please enter a valid crypto wallet address."), dismissButton: .default(Text("OK")))
                    }
                    
                    if !cryptoWalletAddress.isEmpty {
                        Button(action: {
                            cryptoWalletAddress = ""
                        }) {
                            Text("Remove Wallet")
                                .foregroundColor(.red)
                        }
                    }
                }
                
                
                if !cryptoWalletAddress.isEmpty {
                    Section(header: Text("Crypto Payments")) {
                        Button(action: {
                            initiateCryptoPayment()
                        }) {
                            HStack {
                                Image(systemName: "bitcoinsign.circle.fill")
                                Text("Pay with Crypto")
                            }
                        }
                        .foregroundColor(.green)
                    }
                }
                
               
                Section {
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "power")
                            Text("Log Out")
                                .foregroundColor(.red)
                        }
                    }
                    .confirmationDialog("Are you sure you want to log out?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                        Button("Log Out", role: .destructive) {
                            authViewModel.logOut()
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
   
    private func isValidCryptoAddress(_ address: String) -> Bool {
        return address.hasPrefix("0x") && address.count == 42
    }
    
   
    private func initiateCryptoPayment() {
        guard !cryptoWalletAddress.isEmpty else { return }
        print("Initiating crypto payment to \(cryptoWalletAddress)...")
        //  WalletConnect or MetaMask SDK here
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
