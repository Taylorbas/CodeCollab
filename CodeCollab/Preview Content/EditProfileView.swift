//
//  EditProfileView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth


struct EditProfileView: View {
    @State private var showPicturePicker = false
    @State private var selectedPicture = "defaultProfilePicture"
    @State private var isSaving = false
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    var body: some View {
        VStack {
            // Profile Picture Preview
            Image(selectedPicture)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding()
            
            // Change Profile Picture Button
            Button(action: {
                showPicturePicker = true
            }) {
                HStack {
                    Image(systemName: "photo")
                    Text("Change Profile Picture")
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: 250)
                .padding()
                .background(Color.green)
                .cornerRadius(10)
            }
            
            if isSaving {
                ProgressView("Saving...")
            }
            
            Spacer()
        }
        .navigationTitle("Edit Profile")
        .sheet(isPresented: $showPicturePicker) {
            PicturePickerView(selectedPicture: $selectedPicture, onSave: saveProfilePicture)
        }
    }
    
    //saves the selected picture to the users information in firebase
    func saveProfilePicture(){
        guard let userId = auth.currentUser?.uid else {return}
        
        isSaving = true
        
        db.collection("users").document(userId).updateData([
            "profilePicture" : selectedPicture
        ]) { error in
            isSaving = false
            if let error = error {
                print("Error saving profile picture: \(error.localizedDescription)")
            } else {
                print("Profile picture updated successfully")
            }
            
        }
    }
}
    
    
    struct EditProfileView_Previews: PreviewProvider {
        static var previews: some View {
            EditProfileView()
        }
    }

