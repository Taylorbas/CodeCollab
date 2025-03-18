//
//  CodeHub.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 2/25/25.
//

import SwiftUI
import Firebase

struct BlogDiscussionBoard: View {
    @State private var messageText = ""
    @ObservedObject var chatStore = ChatStore()
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(chatStore.messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .background(Color.black.opacity(0.9))
                .onAppear {
                    chatStore.fetchMessages()
                }
                .onChange(of: chatStore.messages.count) { _ in
                    if let lastMessage = chatStore.messages.last {
                        withAnimation {
                            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            HStack {
                TextField("Enter your message", text: $messageText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                    .textFieldStyle(PlainTextFieldStyle())
                
                Button(action: {
                    chatStore.sendMessage(text: messageText)
                    messageText = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding()
                }
            }
            .padding(.vertical, 10)
            .background(Color.black)
        }
        .navigationTitle("Discussion Board")
        .background(Color.black.opacity(0.9))
    }
}

struct MessageRow: View {
    var message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            } else {
                VStack(alignment: .leading) {
                    Text(message.username)
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(message.text)
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

class ChatStore: ObservableObject {
    @Published var messages: [Message] = []
    private var db = Firestore.firestore()
    
    func fetchMessages() {
        db.collection("messages").order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error)")
                    return
                }
                
                DispatchQueue.main.async {
                    self.messages = snapshot?.documents.compactMap { doc in
                        try? doc.data(as: Message.self)
                    } ?? []
                }
            }
    }
    
    func sendMessage(text: String) {
        guard let user = Auth.auth().currentUser else { return }
        let newMessage = Message(id: UUID().uuidString, username: user.displayName ?? "Anonymous", text: text, timestamp: Timestamp())
        
        do {
            _ = try db.collection("messages").document(newMessage.id).setData(from: newMessage)
        } catch {
            print("Error sending message: \(error)")
        }
    }
}

struct BlogDiscussionBoard_Previews: PreviewProvider {
    static var previews: some View {
        BlogDiscussionBoard()
    }
}
