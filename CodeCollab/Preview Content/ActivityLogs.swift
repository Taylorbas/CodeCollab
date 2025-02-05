//
//  ActivityLogs.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

//import SwiftUI
//import Firebase
//import Combine
//
//struct ActivityLogsScreen: View {
//    @StateObject private var viewModel = ActivityLogsViewModel()
//    @State private var activityType = ""
//    @State private var materialID = ""
//    @State private var userID = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                // Input form for adding activity logs
//                Form {
//                    Section(header: Text("Add Activity Log")) {
//                        TextField("Activity Type", text: $activityType)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        TextField("Material ID", text: $materialID)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        TextField("User ID", text: $userID)
//                            .textFieldStyle(RoundedBorderTextFieldStyle())
//                        Button(action: {
//                            guard !activityType.isEmpty, !materialID.isEmpty, !userID.isEmpty else {
//                                viewModel.showAlert(message: "Please fill in all fields")
//                                return
//                            }
//                            viewModel.addActivityLog(activityType: activityType, materialID: materialID, userID: userID)
//                            activityType = ""
//                            materialID = ""
//                            userID = ""
//                        }) {
//                            Text("Add Activity Log")
//                                .frame(maxWidth: .infinity)
//                                .padding()
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(8)
//                        }
//                    }
//                }
//                .padding()
//
//                // Display logs
//                if viewModel.logs.isEmpty {
//                    Text("No activity logs available")
//                        .padding()
//                } else {
//                    List(viewModel.logs) { log in
//                        VStack(alignment: .leading) {
//                            Text("Activity Type: \(log.activityType)")
//                                .font(.headline)
//                            Text("Material ID: \(log.materialID)")
//                            Text("User ID: \(log.userID)")
//                            Text("Timestamp: \(log.timestamp)")
//                        }
//                        .padding()
//                    }
//                }
//            }
//            .navigationTitle("Activity Logs")
//            .alert(item: $viewModel.alert) { alert in
//                Alert(title: Text("Error"), message: Text(alert.message), dismissButton: .default(Text("OK")))
//            }
//        }
//    }
//}
//
