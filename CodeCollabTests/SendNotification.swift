//
//  SendNotification.swift
//  CodeCollabTests
//
//  Created by Bassil Taylor on 11/5/24.
//

//import Foundation
//import Firebase
//
//func sendFirebaseNotification(transactionHash: String) {
//    guard let firebaseServerKey = "YOUR_SERVER_KEY_HERE" else { return }
//    
//    let notification = [
//        "to": "/topics/transaction_updates",
//        "notification": [
//            "title": "Transaction Confirmed",
//            "body": "Your transaction \(transactionHash) is confirmed!"
//        ]
//    ]
//    
//    let jsonData = try! JSONSerialization.data(withJSONObject: notification)
//    var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.setValue("key=\(firebaseServerKey)", forHTTPHeaderField: "Authorization")
//    request.httpBody = jsonData
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error sending notification: \(error)")
//        } else {
//            print("Notification sent successfully.")
//        }
//    }.resume()
//}
