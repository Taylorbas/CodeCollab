//
//  Messaging.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/26/24.
//
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

struct MessagingHomeView: View {
    @State private var contacts: [Contact] = []
    @State private var searchText = ""
    @State private var showingNewContactSheet = false
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by name or number", text: $searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: searchText) { _ in
                        searchContacts()
                    }

                List(contacts) { contact in
                    NavigationLink(destination: MessageScreen(receiverID: contact.id ?? "", authViewModel: authViewModel)) { // Removed senderID, passed authViewModel
                        HStack {
                            if let profileURL = contact.profilePicture, let url = URL(string: profileURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .foregroundColor(.gray)
                                }
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.gray)
                            }
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text(contact.role)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }

                Button(action: { showingNewContactSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                        Text("Add New Contact")
                            .font(.headline)
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .navigationTitle("Messages")
            .onAppear { loadContacts() }
            .sheet(isPresented: $showingNewContactSheet) {
                NewContactView { newContact in
                    contacts.append(newContact)
                    saveContact(newContact)
                }
            }
        }
    }

    private func searchContacts() {
        if searchText.isEmpty {
            loadContacts()
        } else {
            contacts = contacts.filter { $0.name.contains(searchText) || $0.phoneNumber.contains(searchText) }
        }
    }

    private func loadContacts() {
        let db = Firestore.firestore()
        db.collection("contacts").getDocuments { snapshot, error in
            if let error = error {
                print("Error loading contacts: \(error)")
                return
            }
            contacts = snapshot?.documents.compactMap { try? $0.data(as: Contact.self) } ?? []
        }
    }

    private func saveContact(_ contact: Contact) {
        let db = Firestore.firestore()
        do {
            try db.collection("contacts").document(contact.id ?? UUID().uuidString).setData(from: contact)
        } catch {
            print("Error saving contact: \(error)")
        }
    }
}

struct Contact: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var phoneNumber: String
    var profilePicture: String?
    var role: String // "Student" or "Tutor"
}

struct Message: Identifiable {
    var id: String
    var senderID: String
    var receiverID: String
    var text: String
    var timestamp: Date
}

struct NewContactView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var role = "Student"
    @State private var profilePictureURL: String?
    var onSave: (Contact) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Name", text: $name)
                    TextField("Phone Number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                    Picker("Role", selection: $role) {
                        Text("Student").tag("Student")
                        Text("Tutor").tag("Tutor")
                    }
                }

                Button("Save") {
                    let newContact = Contact(name: name, phoneNumber: phoneNumber, profilePicture: profilePictureURL, role: role)
                    onSave(newContact)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || phoneNumber.isEmpty)
            }
            .navigationTitle("New Contact")
            .navigationBarItems(leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() })
        }
    }
}
