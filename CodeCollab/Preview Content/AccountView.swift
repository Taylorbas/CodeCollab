//
//  AccountView.swift
//  CodeCollab
//
//  Created by Matthew Secketa on 11/6/24.
//

import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    @State private var notificationToggle: Bool = false
    @State private var locationUsage: Bool = false
    @State private var selectedCurrency: Int = 0
    @State private var currencyArray: [String] = ["$ US Dollar", "£ GBP", "€ Euro"]
    @State private var selectedPaymentMethod: Int = 1
    @State private var paymentMethodArray: [String] = ["Paypal", "Credit/Debit Card", "Bitcoin"]
    @State private var isShowingLogOutConfirmation = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var showingPersonalInfo = false
    @State private var showingEditInfo = false
    @State private var passwordForEmailChange = ""
    @State private var newEmail = ""
    @State private var reenterNewEmail = ""
    @State private var emailChangeError: String?
    @State private var showPicturePicker = false
    @State private var selectedPicture = "defaultProfilePicture"
    @State private var isSaving = false
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // Profile Picture & User Info
                    Image(authViewModel.userProfilePicture)
                         .resizable()
                         .frame(width: 120, height: 120)
                         .foregroundColor(.gray)
                         .clipShape(Circle())
                         .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    Text(authViewModel.userFullName)
                        .font(.system(size: 20))
                        .bold()
                    Text(authViewModel.userEmail)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text(authViewModel.userPhone)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                Form {
                    // Payment Settings
                    Section(header: Text("Payment Settings")) {
                        Picker(selection: self.$selectedCurrency, label: Text("Currency")) {
                            ForEach(0 ..< self.currencyArray.count) {
                                Text(self.currencyArray[$0]).tag($0)
                            }
                        }
                        Picker(selection: self.$selectedPaymentMethod, label: Text("Payment Method")) {
                            ForEach(0 ..< self.paymentMethodArray.count) {
                                Text(self.paymentMethodArray[$0]).tag($0)
                            }
                        }
                        Button(action: {
                            print("Payment method selected")
                        }) {
                            if self.paymentMethodArray[self.selectedPaymentMethod] == "Credit/Debit Card" {
                                Text("Add a Credit/Debit Card to your account")
                            } else {
                                Text("Connect \(self.paymentMethodArray[self.selectedPaymentMethod]) to your account")
                            }
                        }
                    }
                    // Personal Information
                    Section(header: Text("Personal Information")) {
                        Button("Profile Information") {
                            showingPersonalInfo = true
                        }
                    }
                    Button(action: {
                        showPicturePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Change Profile Picture")
                        }
                    }
                    if isSaving {
                        ProgressView("Saving...")
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .onAppear {
                authViewModel.fetchUserData()
            }
            .sheet(isPresented: $showingPersonalInfo) {
                PersonalInfoView(authViewModel: authViewModel, showingEditInfo: $showingEditInfo)
            }
            .sheet(isPresented: $showingEditInfo) {
                EditInfoView(authViewModel: authViewModel, passwordForEmailChange: $passwordForEmailChange, newEmail: $newEmail, reenterNewEmail: $reenterNewEmail, emailChangeError: $emailChangeError)
            }
            .sheet(isPresented: $showPicturePicker) {
                PicturePickerView(selectedPicture: $selectedPicture, onSave: saveProfilePicture)
            }
            .onChange(of: selectedImage) { newImage in
                if let image = newImage, let userId = Auth.auth().currentUser?.uid {
                    uploadImage(image: image, userId: userId)
                }
            }
        }
    }
    private func uploadImage(image: UIImage, userId: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error fetching download URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    DispatchQueue.main.async {
                        authViewModel.updateProfilePicture(userId: userId, profilePictureURL: url.absoluteString)
                    }
                }
            }
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
struct PersonalInfoView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var showingEditInfo: Bool
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Full Name: \(authViewModel.userFullName)")
                Text("Phone Number: \(authViewModel.userPhone)")
                Text("Email: \(authViewModel.userEmail)")
                Button("Edit Information") {
                    showingEditInfo = true
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Personal Info")
        }
    }
}
struct EditInfoView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @Binding var passwordForEmailChange: String
    @Binding var newEmail: String
    @Binding var reenterNewEmail: String
    @Binding var emailChangeError: String?
    var body: some View {
        NavigationView {
            Form {
                SecureField("Enter Password", text: $passwordForEmailChange)
                TextField("New Email", text: $newEmail)
                TextField("Re-enter New Email", text: $reenterNewEmail)
                if let error = emailChangeError {
                    Text(error).foregroundColor(.red)
                }
                Button("Confirm") {
                    if newEmail == reenterNewEmail {
                        authViewModel.changeEmail(password: passwordForEmailChange, newEmail: newEmail) { result in
                            switch result {
                            case .success:
                                print("Email changed successfully")
                            case .failure(let error):
                                emailChangeError = error.localizedDescription
                            }
                        }
                    } else {
                        emailChangeError = "Emails do not match"
                    }
                }
            }
            .navigationTitle("Edit Info")
        }
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                                    if let uiImage = image as? UIImage {
                                        DispatchQueue.main.async {
                                            self.parent.image = uiImage
                                        }
                                    }
                                }
                            }
                            parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
extension AuthViewModel {
    func updateProfilePicture(userId: String, profilePictureURL: String) {
        // Access db through the instance property, not directly
        self.db.collection("users").document(userId).updateData(["profilePicture": profilePictureURL]) { error in
            if let error = error {
                print("Error updating profile picture URL: \(error.localizedDescription)")
            } else {
                self.fetchUserData() // Refresh user data
            }
        }
    }
                    func changeEmail(password: String, newEmail: String, completion: @escaping (Result<Void, Error>) -> Void) {
                        guard let user = Auth.auth().currentUser else {
                            completion(.failure(NSError(domain: "Auth", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
                            return
                        }
                        let credential = EmailAuthProvider.credential(withEmail: user.email!, password: password)
                        user.reauthenticate(with: credential) { result, error in
                            if let error = error {
                                completion(.failure(error))
                                return
                            }
                            user.updateEmail(to: newEmail) { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(()))
                                    self.fetchUserData()
                                }
                            }
                        }
                    }
                }
                // Preview
                struct AccountView_Previews: PreviewProvider {
                    static var previews: some View {
                        AccountView()
                            .environmentObject(AuthViewModel())
                    }
                }
