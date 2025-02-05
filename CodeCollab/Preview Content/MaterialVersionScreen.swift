//
//  MaterialVersionScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import SwiftUI
//import Firebase
//
//struct MaterialVersionScreen: View {
//    @State private var materialVersions: [MaterialVersion] = []
//    @State private var isLoading = true
//    @State private var materialID = ""
//    @State private var contentHash = ""
//    @State private var versionNumber = ""
//    @State private var errorMessage: String?
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Form to add material version
//                Form {
//                    Section(header: Text("Add Material Version")) {
//                        TextField("Material ID", text: $materialID)
//                            .keyboardType(.default)
//                        TextField("Content Hash", text: $contentHash)
//                            .keyboardType(.default)
//                        TextField("Version Number", text: $versionNumber)
//                            .keyboardType(.default)
//                        
//                        Button("Add Material Version") {
//                            addMaterialVersion()
//                        }
//                        .disabled(materialID.isEmpty || contentHash.isEmpty || versionNumber.isEmpty)
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
//                    ProgressView("Loading material versions...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if materialVersions.isEmpty {
//                        Text("No material versions available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(materialVersions) { version in
//                            VStack(alignment: .leading) {
//                                Text("Version Number: \(version.versionNumber)")
//                                    .fontWeight(.bold)
//                                Text("Material ID: \(version.materialID)")
//                                Text("Content Hash: \(version.contentHash)")
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Material Versions")
//            .onAppear {
//                loadMaterialVersions()
//            }
//        }
//    }
//    
//    private func loadMaterialVersions() {
//        let db = Firestore.firestore()
//        db.collection("material_versions")
//            .whereField("materialID", isEqualTo: materialID)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error loading material versions: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.materialVersions = documents.compactMap { doc in
//                    try? doc.data(as: MaterialVersion.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func addMaterialVersion() {
//        guard !materialID.isEmpty && !contentHash.isEmpty && !versionNumber.isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let materialVersionData: [String: Any] = [
//            "materialID": materialID,
//            "contentHash": contentHash,
//            "versionNumber": versionNumber
//        ]
//        
//        db.collection("material_versions")
//            .addDocument(data: materialVersionData) { error in
//                if let error = error {
//                    self.errorMessage = "Error adding material version: \(error)"
//                } else {
//                    self.materialID = ""
//                    self.contentHash = ""
//                    self.versionNumber = ""
//                    self.errorMessage = nil
//                    loadMaterialVersions() // Reload material versions
//                }
//            }
//    }
//}
//
//struct MaterialVersion: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var materialID: String
//    var contentHash: String
//    var versionNumber: String
//}
