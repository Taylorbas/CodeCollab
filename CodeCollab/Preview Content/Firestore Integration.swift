//
//  Firestore Integration.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/20/24.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseCore

// Data Models
struct Category: Identifiable, Codable {
    var id: String
    var label: String
    var description: String
}
struct Resource: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var url: String
    var imageName: String?
}
struct Tutor: Identifiable, Codable {
    var id: String
    var name: String
    var language: String
}
class CodingStore: ObservableObject {
    @Published var categories: [Category] = []
    @Published var resources: [Resource] = [] // Unified list for current category resources
    private let db = Firestore.firestore()
    // Initializer to fetch categories on initialization
    init() {
        fetchCategories()
    }
    /// Fetches categories from the Firestore database
    func fetchCategories() {
        db.collection("Categories").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No categories found")
                return
            }
            self.categories = documents.compactMap { doc in
                let data = doc.data()
                guard let label = data["label"] as? String,
                      let description = data["description"] as? String else {
                    return nil
                }
                return Category(id: doc.documentID, label: label, description: description)
            }
            print("Fetched categories: \(self.categories)")
        }
    }
    func fetchResources(for category: String) {
        db.collection("Categories").document(category).collection("Resources").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching resources for \(category): \(error.localizedDescription)")
                return
            }
            guard let documents = snapshot?.documents else {
                print("No resources found for category \(category)")
                return
            }
            self.resources = documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String,
                      let description = data["description"] as? String,
                      let url = data["url"] as? String else {
                    return nil
                }
                return Resource(id: doc.documentID, name: name, description: description, url: url)
            }
            print("Fetched resources for category \(category): \(self.resources)")
        }
    }
}
