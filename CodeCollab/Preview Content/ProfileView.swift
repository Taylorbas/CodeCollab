//
//  ProfileView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//
//import SwiftUI
//import Firebase
//
//struct ProfileView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var authViewModel: AuthViewModel
//    
//    var body: some View {
//        NavigationView { // Wrap in NavigationView for navigation functionality
//            VStack(spacing: 20) {
//                // Profile Image
//                Image(authViewModel.userProfilePicture)
//                    .resizable()
//                    .frame(width: 120, height: 120)
//                    .foregroundColor(.gray)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
//                
//                // User Info
//                Text(authViewModel.userFullName)
//                    .font(.title)
//                    .fontWeight(.bold)
//                
//                Text(authViewModel.userEmail)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                
//                Divider()
//                    .padding(.horizontal)
//                
//                // Navigation Links
//                Group {
//                    NavigationLink(destination: AccountView()) {
//                        ProfileRow(icon: "star.fill", title: "Account")
//                    }
//                    NavigationLink(destination: SocialView()) {
//                        ProfileRow(icon: "figure.wave", title: "Social")
//                    }
//                    NavigationLink(destination: SettingsView()) {
//                        ProfileRow(icon: "personalhotspot", title: "Settings")
//                    }
//                    NavigationLink(destination: EditProfileView()) {
//                        ProfileRow(icon: "pencil.circle", title: "Edit Profile")
//                    }
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//                
//                
//            }
//            .padding()
//            .navigationTitle("Profile")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    // Back Button
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        HStack {
//                            Image(systemName: "chevron.left")
//                            Text("Back")
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                authViewModel.fetchUserData()
//            }
//        }
//    }
//}
//
//// A reusable row view for profile options
//struct ProfileRow: View {
//    let icon: String
//    let title: String
//    
//    var body: some View {
//        HStack {
//            Image(systemName: icon)
//            Text(title)
//                .font(.headline)
//            Spacer()
//            Image(systemName: "chevron.right")
//        }
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.blue)
//        .cornerRadius(10)
//    }
//}
//
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            ProfileView().environmentObject(AuthViewModel())
//        }
//    }
//}
//
