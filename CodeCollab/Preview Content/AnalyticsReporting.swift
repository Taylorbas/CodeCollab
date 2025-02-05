//
//  AnalyticsReporting.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import SwiftUI
//import Firebase
//
//struct AnalyticsReportingScreen: View {
//    @State private var analyticsRecords: [AnalyticsRecord] = []
//    @State private var isLoading = true
//    @State private var materialID = ""
//    @State private var userID = ""
//    @State private var type = ""
//    @State private var errorMessage: String?
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Form to add analytics record
//                Form {
//                    Section(header: Text("Add Analytics Record")) {
//                        TextField("Material ID", text: $materialID)
//                        TextField("User ID", text: $userID)
//                        TextField("Type", text: $type)
//                        
//                        Button("Add Analytics Record") {
//                            addAnalyticsRecord()
//                        }
//                        .disabled(materialID.isEmpty || userID.isEmpty || type.isEmpty)
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
//                    ProgressView("Loading records...")
//                        .progressViewStyle(CircularProgressViewStyle())
//                        .padding()
//                } else {
//                    if analyticsRecords.isEmpty {
//                        Text("No analytics records available")
//                            .font(.headline)
//                            .padding()
//                    } else {
//                        List(analyticsRecords) { record in
//                            VStack(alignment: .leading) {
//                                Text("Material ID: \(record.materialID)")
//                                    .fontWeight(.bold)
//                                Text("User ID: \(record.userID)")
//                                Text("Type: \(record.type)")
//                                Text("Timestamp: \(record.timestamp)")
//                            }
//                            .padding()
//                        }
//                    }
//                }
//            }
//            .navigationBarTitle("Analytics and Reporting")
//            .onAppear {
//                loadAnalyticsRecords()
//            }
//        }
//    }
//    
//    private func loadAnalyticsRecords() {
//        let db = Firestore.firestore()
//        db.collection("analyticsRecords")
//            .whereField("materialID", isEqualTo: materialID)
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error loading analytics records: \(error)")
//                    return
//                }
//                guard let documents = snapshot?.documents else { return }
//                self.analyticsRecords = documents.compactMap { doc in
//                    try? doc.data(as: AnalyticsRecord.self)
//                }
//                self.isLoading = false
//            }
//    }
//    
//    private func addAnalyticsRecord() {
//        guard !materialID.isEmpty && !userID.isEmpty && !type.isEmpty else {
//            errorMessage = "Please fill in all fields"
//            return
//        }
//        
//        let db = Firestore.firestore()
//        let recordData: [String: Any] = [
//            "materialID": materialID,
//            "userID": userID,
//            "type": type,
//            "timestamp": Timestamp()
//        ]
//        
//        db.collection("analyticsRecords")
//            .addDocument(data: recordData) { error in
//                if let error = error {
//                    self.errorMessage = "Error adding record: \(error)"
//                } else {
//                    self.materialID = ""
//                    self.userID = ""
//                    self.type = ""
//                    self.errorMessage = nil
//                    loadAnalyticsRecords() // Reload records
//                }
//            }
//    }
//}
//
//struct AnalyticsRecord: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var materialID: String
//    var userID: String
//    var type: String
//    var timestamp: Timestamp
//}
