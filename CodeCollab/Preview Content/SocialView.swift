//
//  SocialView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//

import SwiftUI

struct SocialView: View {
    @State private var postText: String = ""

    var body: some View {
        TabView {
            ConnectionsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Connections")
                }

            ActivityFeedView()
                .tabItem {
                    Image(systemName: "text.bubble.fill")
                    Text("Activity")
                }

            GroupsView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Groups")
                }

            MessagesView()
                .tabItem {
                    Image(systemName: "envelope.fill")
                    Text("Messages")
                }

            CreatePostView(postText: $postText)
                .tabItem {
                    Image(systemName: "plus.square.fill")
                    Text("Post")
                }
            
            FriendRequestsView()
                .tabItem {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Friend Requests")
                }
        }
        .navigationTitle("Social")
    }
}

struct ConnectionsView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in // Replace with actual data
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text("John Doe")
                        Text("Online")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                    Spacer()
                    Button("Message") {
                        // Message action
                    }
                    .foregroundColor(.blue)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct ActivityFeedView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(0..<5) { _ in // Replace with actual data
                VStack(alignment: .leading) {
                    Text("John Doe shared a new coding tutorial")
                    Text("2 hours ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack {
                        Button("Like") { /* Like action */ }
                        Button("Comment") { /* Comment action */ }
                    }
                    Divider()
                }
            }
            .padding()
        }
    }
}

struct GroupsView: View {
    var body: some View {
        List {
            HStack {
                Text("Beginner Coders")
                Spacer()
                Button("Join") {
                    // Join action
                }
                .foregroundColor(.blue)
            }
            HStack {
                Text("JavaScript Enthusiasts")
                Spacer()
                Button("Leave") {
                    // Leave action
                }
                .foregroundColor(.red)
            }
        }
    }
}

struct MessagesView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in // Replace with actual data
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                        Text("Hey! How's the project going?")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("5 min ago")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct CreatePostView: View {
    @Binding var postText: String

    var body: some View {
        VStack {
            TextField("What's on your mind?", text: $postText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom, 5)
            Button("Post") {
                // Post action
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .padding()
    }
}

struct FriendRequestsView: View {
    var body: some View {
        List {
            ForEach(0..<5) { _ in // Replace with actual data
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Chris Adams")
                    Spacer()
                    Button("Accept") { /* Accept action */ }
                        .foregroundColor(.green)
                    Button("Decline") { /* Decline action */ }
                        .foregroundColor(.red)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct SocialView_Previews: PreviewProvider {
    static var previews: some View {
        SocialView()
    }
}
