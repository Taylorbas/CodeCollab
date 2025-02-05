//
//  CodeCollabApp.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/16/24.
//

import SwiftUI
import Firebase

@main
struct CodeCollabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var codingStore = CodingStore() // Initialize CodingStore here

    var body: some Scene {
        WindowGroup {
            if authViewModel.isAuthenticated {
                CodingContentView(codingStore: codingStore) // Pass the initialized codingStore
                    .environmentObject(authViewModel)
            } else {
                SView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
