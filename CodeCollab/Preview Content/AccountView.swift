//
//  AccountView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//

//import SwiftUI
//import Firebase
//
//struct AccountView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var authViewModel: AuthViewModel
//
//    var body: some View {
//        GeometryReader { geometry in
//            VStack {
//                VStack {
//                    Text("Account Page")
//                        .font(.largeTitle)
//                        .padding()
//
//                    Section {
//                        Text(authViewModel.userFullName)
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//                        Text(authViewModel.userEmail)
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//                        Text(authViewModel.userPhone)
//                            .font(.subheadline)
//                            .foregroundColor(.black)
//                            .fontWeight(.bold)
//
//                        Button("Change Password") {
//                            // Change password action
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//                .padding()
//
//                Spacer() // Pushes the log out button to the bottom
//
//                // Log Out Button
//                Button(action: {
//                    authViewModel.logOut()
//                }) {
//                    HStack {
//                        Image(systemName: "power")
//                        Text("Log Out")
//                            .font(.headline)
//                    }
//                    .foregroundColor(.red)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                }
//                .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
//                    if !isAuthenticated {
//                        // Navigate back to login after logout
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                }
//            }
//            .navigationTitle("Account")
//            .onAppear {
//                authViewModel.fetchUserData()
//            }
//            .frame(width: geometry.size.width, height: geometry.size.height) // Ensure full screen layout
//        }
//    }
//}
//
//struct AccountView_Previews: PreviewProvider {
//    static var previews: some View {
//        AccountView()
//            .environmentObject(AuthViewModel())
//    }
//}
