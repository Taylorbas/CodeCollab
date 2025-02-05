//
//  AppDelegate.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/5/24.
//

import Foundation
import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications
// AppDelegate class to handle application lifecycle events and Firebase configuration

class AppDelegate: UIResponder, UIApplicationDelegate {
    // This function is called when the app finishes launching
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        print("Firebase configured successfully")  // Log Firebase configuration status
        // Set up notifications
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        // Request notification authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Notification authorization error: \(error)")
            }
        }
        return true
    }
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Configure the new scene session
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // This method is called when the user discards a scene session.
        // Clean up resources related to discarded scenes if needed.
    }
}
// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle incoming notification when the app is in the foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])  // Show the notification as an alert even when the app is in the foreground
    }
}
// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        // Here you could send the token to your server if needed
    }
}
