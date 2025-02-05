//
//  MaterialScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import SwiftUI
//import Firebase
//
//struct MaterialScreen: View {
//    @State private var materials: [Material] = []
//    @State private var isLoading = true
//    @State private var title = ""
//    @State private var category = ""
//    @State private var blockchainReference = ""
//    @State private var contentHash = ""
//    @State private var license = ""
//    @State private var ownerID = ""
//    @State private var tags = ""
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Form to add material
//                Form {
//                    Section(header: Text("Add New Material")) {
//                        TextField("Title", text: $title)
//                        TextField("Category", text: $category)
//                        TextField("Blockchain Reference", text: $blockchainReference)
//                        TextField("Content Hash", text: $contentHash)
//                        TextField("License", text: $license)
//                        TextField("Owner ID", text: $ownerID)
//                        TextField("Tags (comma-separated)", text: $tags)
//                        
//                        Button("Add Material") {
//                            addMaterial()
//                        }
//                        .disabled(title.isEmpty || category.isEmpty || blockchainReference.isEmpty || contentHash.isEmpty || license.isEmpty || ownerID.isEmpty)
//                    }
//                }
//                
//                if let errorMessage = errorMessage {
//                    Text(errorMessage)
//                        .foregroundColor(.red)
//                        .padding()
//                }
//                
//                if isLoading {
//                    ProgressView("Loading materials...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if materials.isEmpty {
//                        Text("No materials available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(materials) { material in
//                            VStack(alignment: .leading) {
//                                Text("Title: \(material.title)")
//                                    .fontWeight(.bold)
//                                Text("Category: \(material.category)")
//                                Text("Owner ID: \(material.ownerID)")
//                                Text("Blockchain Reference: \(material.blockchainReference)")
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Materials")
//            .onAppear {
//                loadMaterials()
//            }
//        }
//    }
//    
//    private func loadMaterials() {
//        let db = Firestore.firestore()
//        db.collection("materials")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error loading materials: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.materials = documents.compactMap { doc in
//                    try? doc.data(as: Material.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func addMaterial() {
//        guard !title.isEmpty && !category.isEmpty && !blockchainReference.isEmpty && !contentHash.isEmpty && !license.isEmpty && !ownerID.isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let materialData: [String: Any] = [
//            "title": title,
//            "category": category,
//            "blockchainReference": blockchainReference,
//            "contentHash": contentHash,
//            "license": license,
//            "ownerID": ownerID,
//            "tags": tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//        ]
//        
//        db.collection("materials")
//            .addDocument(data: materialData) { error in
//                if let error = error {
//                    self.errorMessage = "Error adding material: \(error)"
//                } else {
//                    self.title = ""
//                    self.category = ""
//                    self.blockchainReference = ""
//                    self.contentHash = ""
//                    self.license = ""
//                    self.ownerID = ""
//                    self.tags = ""
//                    self.errorMessage = nil
//                    loadMaterials() // Reload materials
//                }
//            }
//    }
//}
//
//struct Material: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var title: String
//    var category: String
//    var blockchainReference: String
//    var contentHash: String
//    var license: String
//    var ownerID: String
//    var tags: [String]
//}
