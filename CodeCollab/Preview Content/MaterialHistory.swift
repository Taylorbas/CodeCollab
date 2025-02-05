//
//  MaterialHistory.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import SwiftUI
//import Firebase
//
//struct MaterialHistoryScreen: View {
//    @State private var materialHistory: [MaterialHistory] = []
//    @State private var isLoading = true
//    @State private var materialID = ""
//    @State private var action = ""
//    @State private var userID = ""
//    @State private var errorMessage: String?
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Form to add material history action
//                Form {
//                    Section(header: Text("Add Material History")) {
//                        TextField("Material ID", text: $materialID)
//                        TextField("Action", text: $action)
//                        TextField("User ID", text: $userID)
//                        
//                        Button("Add Material History") {
//                            addMaterialHistory()
//                        }
//                        .disabled(materialID.isEmpty || action.isEmpty || userID.isEmpty)
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
//                    ProgressView("Loading history...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if materialHistory.isEmpty {
//                        Text("No material history available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(materialHistory) { history in
//                            VStack(alignment: .leading) {
//                                Text("Action: \(history.action)")
//                                    .fontWeight(.bold)
//                                Text("Material ID: \(history.materialID)")
//                                Text("User ID: \(history.userID)")
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Material History")
//            .onAppear {
//                loadMaterialHistory()
//            }
//        }
//    }
//    
//    private func loadMaterialHistory() {
//        let db = Firestore.firestore()
//        db.collection("materialHistory")
//            .whereField("materialID", isEqualTo: materialID)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error loading material history: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.materialHistory = documents.compactMap { doc in
//                    try? doc.data(as: MaterialHistory.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func addMaterialHistory() {
//        guard !materialID.isEmpty && !action.isEmpty && !userID.isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let historyData: [String: Any] = [
//            "materialID": materialID,
//            "action": action,
//            "userID": userID
//        ]
//        
//        db.collection("materialHistory")
//            .addDocument(data: historyData) { error in
//                if let error = error {
//                    self.errorMessage = "Error adding history: \(error)"
//                } else {
//                    self.materialID = ""
//                    self.action = ""
//                    self.userID = ""
//                    self.errorMessage = nil
//                    loadMaterialHistory() // Reload history
//                }
//            }
//    }
//}

//struct MaterialHistory: Identifiable, Decodable {
//    //@DocumentID var id: String?
//    var materialID: String
//    var action: String
//    var userID: String
//}
