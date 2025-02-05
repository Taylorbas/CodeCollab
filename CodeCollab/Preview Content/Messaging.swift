//
//  Messaging.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/26/24.
//

//import SwiftUI
//import Firebase
//
//struct MessageScreen: View {
//    @State private var messages: [Message] = []
//    @State private var isLoading = true
//    @State private var newMessage = ""
//    
//    var senderID: String
//    var receiverID: String
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoading {
//                    ProgressView("Loading messages...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if messages.isEmpty {
//                        Text("No messages available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(messages) { message in
//                            MessageRow(message: message, isSender: message.senderID == senderID)
//                        }
//                    }
//                }
//                
//                HStack {
//                    TextField("Enter your message", text: $newMessage)
//                        .padding()
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    
//                    Button(action: sendMessage) {
//                        Image(systemName: "paperplane.fill")
//                            .font(.title2)
//                            .foregroundColor(.blue)
//                    }
//                }
//                .padding()
//            }
//            .navigationBarTitle("Messages")
//            .onAppear {
//                loadMessages()
//            }
//        }
//    }
//    
//    private func loadMessages() {
//        let db = Firestore.firestore()
//        db.collection("messages")
//            .whereField("senderID", in: [senderID, receiverID])
//            .whereField("receiverID", in: [senderID, receiverID])
//            .order(by: "timestamp", descending: true)
//            .addSnapshotListener { snapshot, error in
//                if let error = error {
//                    print("Error loading messages: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.messages = documents.compactMap { doc in
//                    try? doc.data(as: Message.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func sendMessage() {
//        guard !newMessage.isEmpty else { return }
//        
//        let db = Firestore.firestore()
//        let messageData: [String: Any] = [
//            "senderID": senderID,
//            "receiverID": receiverID,
//            "message": newMessage,
//            "timestamp": FieldValue.serverTimestamp()
//        ]
//        
//        db.collection("messages")
//            .addDocument(data: messageData) { error in
//                if let error = error {
//                    print("Error sending message: \(error)")
//                } else {
//                    newMessage = "" // Clear message input
//                }
//            }
//    }
//}
//
//struct MessageRow: View {
//    var message: Message
//    var isSender: Bool
//    
//    var body: some View {
//        HStack {
//            if isSender {
//                Spacer()
//            }
//            Text(message.message)
//                .padding()
//                .background(isSender ? Color.blue : Color.gray.opacity(0.2))
//                .foregroundColor(isSender ? .white : .black)
//                .cornerRadius(10)
//                .frame(maxWidth: 300, alignment: isSender ? .trailing : .leading)
//            if !isSender {
//                Spacer()
//            }
//        }
//        .padding(.vertical, 5)
//    }
//}
//
//struct Message: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var senderID: String
//    var receiverID: String
//    var message: String
//    var timestamp: Date?
//}
