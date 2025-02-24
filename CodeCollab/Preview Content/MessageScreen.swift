//
//  MessageScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 2/23/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MessageScreen: View {
    @ObservedObject var authViewModel: AuthViewModel // Add authViewModel
    @State private var newMessageText = ""
    var receiverID: String

    init(receiverID: String, authViewModel: AuthViewModel) { // Update initializer
        self.receiverID = receiverID
        self.authViewModel = authViewModel
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(authViewModel.messages) { message in // Use authViewModel.messages
                        HStack {
                            if message.senderID == authViewModel.senderID { // Use authViewModel.senderID
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            HStack {
                TextField("Type a message...", text: $newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear {
            authViewModel.receiverID = receiverID // Set receiverID
            authViewModel.loadMessages() // Load messages from authViewModel
        }
    }

    private func sendMessage() {
        guard !newMessageText.isEmpty, let senderID = authViewModel.senderID else { return } // Use authViewModel.senderID

        let db = Firestore.firestore()
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "text": newMessageText,
            "timestamp": Timestamp(date: Date())
        ]

        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                newMessageText = ""
            }
        }
    }
}
