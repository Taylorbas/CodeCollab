//
//  BeginView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/3/24.
//

import SwiftUI
import Combine

class UserSettings: ObservableObject {
    @Published var loggedIn: Bool = false
    @Published var username: String = ""
    @Published var preferredLanguage: String = "Swift" // Example of a preferred coding language
    
    init() {
        // You can load user settings from UserDefaults or any other source if needed.
        // For demonstration purposes, we set default values.
        self.loadUserSettings()
    }
    
    func loadUserSettings() {
        // Load settings from UserDefaults or any persistent storage
        if let savedUsername = UserDefaults.standard.string(forKey: "username") {
            self.username = savedUsername
        }
        if let savedPreferredLanguage = UserDefaults.standard.string(forKey: "preferredLanguage") {
            self.preferredLanguage = savedPreferredLanguage
        }
    }
    
    func saveUserSettings() {
        // Save settings to UserDefaults or any persistent storage
        UserDefaults.standard.set(self.username, forKey: "username")
        UserDefaults.standard.set(self.preferredLanguage, forKey: "preferredLanguage")
    }
    
    func logout() {
        // Perform logout actions
        self.loggedIn = false
        self.username = ""
        self.preferredLanguage = "Swift" // Resetting to default
        saveUserSettings()
    }
}
