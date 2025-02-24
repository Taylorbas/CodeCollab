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
    @State private var isMusicEnabled: Bool = true
    @State private var isNotificationsEnabled: Bool = true
    @State private var isLocationEnabled: Bool = false
    @State private var cryptoWalletAddress: String = ""
    @State private var showLogoutConfirmation = false
    @State private var showSwitchToTutorConfirmation = false
    @State private var navigateToTutorLogin = false

    var body: some View {
        NavigationView {
            Form {
                // 🔹 Theme Settings
                Section(header: Text("Appearance")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                        .onChange(of: isDarkMode) { _ in
                            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
                        }
                }
                
                // 🔹 Audio Settings
                Section(header: Text("Sound")) {
                    Toggle("Background Music", isOn: $isMusicEnabled)
                }
                
                // 🔹 Notifications & Location
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                    Toggle("Use Location", isOn: $isLocationEnabled)
                }
                
                // 🔹 Crypto Wallet Management
                Section(header: Text("Crypto Wallet")) {
                    TextField("Enter Wallet Address", text: $cryptoWalletAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        // Save wallet address logic
                        print("Wallet Set: \(cryptoWalletAddress)")
                    }) {
                        Text("Save Wallet")
                            .foregroundColor(.blue)
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

                // 🔹 Switch to Tutor Option
                Section {
                    Button(action: {
                        showSwitchToTutorConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Switch to Tutor")
                                .foregroundColor(.blue)
                        }
                    }
                    .confirmationDialog(
                        "Are you sure you want to switch to Tutor? You will be logged out and brought to the Tutor sign-in.",
                        isPresented: $showSwitchToTutorConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Switch", role: .destructive) {
                            authViewModel.logOut()
                            navigateToTutorLogin = true
                        }
                        Button("Cancel", role: .cancel) {}
                    }
                }

                // 🔹 Logout
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
            .background(
                NavigationLink(destination: TutLoginView(), isActive: $navigateToTutorLogin) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

// Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
