//
//  MessagingService.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import Foundation
import Firebase
import UserNotifications

class FirebaseMessagingService: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override init() {
        super.init()
        configureFirebaseMessaging()
    }
    
    // Initialize Firebase Messaging and set up notifications
    private func configureFirebaseMessaging() {
        // Request notification permissions
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Permission error: \(error.localizedDescription)")
            } else if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission denied.")
            }
        }
        
        // Set delegates
        notificationCenter.delegate = self
        Messaging.messaging().delegate = self
    }
    
    // Handle foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print("Foreground notification received: \(userInfo)")
        
        // Show notification while app is in the foreground
        completionHandler([.alert, .sound, .badge])
    }
    
    // Handle background/terminated state notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("Notification clicked: \(userInfo)")
        
        // Handle navigation or actions based on notification
        completionHandler()
    }
    
    // MessagingDelegate method for token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        print("FCM Token received: \(fcmToken)")
        // Send token to server if needed
    }
    
    // Helper to show local notifications
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Immediate trigger
        )
        
        notificationCenter.add(request) { error in
            if let error = error {
                print("Error showing local notification: \(error.localizedDescription)")
            }
        }
    }
    
    // Process FCM messages
    func handleIncomingMessage(_ message: [String: Any]) {
        if let aps = message["aps"] as? [String: Any],
           let alert = aps["alert"] as? [String: String],
           let title = alert["title"],
           let body = alert["body"] {
            showNotification(title: title, body: body)
        }
    }
}

