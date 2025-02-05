//
//  Notifications.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/5/24.
//
//import SwiftUI
//import Firebase
//
//struct NotificationScreen: View {
//    @State private var notifications: [Notification] = []
//    @State private var isLoading = true
//    
//    var userID: String
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoading {
//                    ProgressView("Loading...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if notifications.isEmpty {
//                        Text("No notifications available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(notifications) { notification in
//                            NotificationRow(notification: notification) {
//                                markNotificationAsRead(notification.id)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Notifications")
//            .onAppear {
//                loadNotifications()
//            }
//        }
//    }
//    
//    private func loadNotifications() {
//        let db = Firestore.firestore()
//        db.collection("notifications")
//            .whereField("userID", isEqualTo: userID)
//            .order(by: "createdAt", descending: true)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Error loading notifications: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.notifications = documents.compactMap { doc in
//                    try? doc.data(as: Notification.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func markNotificationAsRead(_ notificationID: String) {
//        let db = Firestore.firestore()
//        db.collection("notifications")
//            .document(notificationID)
//            .updateData([
//                "isRead": true
//            ]) { error in
//                if let error = error {
//                    print("Error updating notification: \(error)")
//                } else {
//                    if let index = notifications.firstIndex(where: { $0.id == notificationID }) {
//                        notifications[index].isRead = true
//                    }
//                }
//            }
//    }
//}
//
//struct NotificationRow: View {
//    var notification: Notification
//    var onMarkAsRead: () -> Void
//
//    var body: some View {
//        HStack {
//            VStack(alignment: .leading) {
//                Text(notification.message)
//                    .font(.body)
//                if let createdAt = notification.createdAt {
//                    Text(createdAt, style: .date)
//                        .font(.footnote)
//                        .foregroundColor(.gray)
//                }
//            }
//            Spacer()
//            if notification.isRead {
//                Image(systemName: "checkmark.circle.fill")
//                    .foregroundColor(.green)
//            } else {
//                Button(action: onMarkAsRead) {
//                    Image(systemName: "envelope.open")
//                        .foregroundColor(.blue)
//                }
//            }
//        }
//        .padding()
//    }
//}
//
//struct Notification: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var userID: String
//    var message: String
//    var createdAt: Date?
//    var isRead: Bool
//}
//
//
