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

struct AccountView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthViewModel

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

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    // Profile Picture & User Info
                    Button(action: { isShowingImagePicker = true }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding(.bottom, 10)
                        } else if let profileURL = authViewModel.currentUser?.profilePicture, let url = URL(string: profileURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.bottom, 10)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                                .padding(.bottom, 10)
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }

                    Text(authViewModel.userFullName.isEmpty ? "User" : authViewModel.userFullName)
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

                    // Notification & Location Toggles
                    Section(footer: Text("Allow push notifications to get latest updates and offers")) {
                        Toggle(isOn: self.$locationUsage) {
                            Text("Location Usage")
                        }
                        Toggle(isOn: self.$notificationToggle) {
                            Text("Notifications")
                        }
                    }
                }
                Spacer()
            }
            .navigationBarTitle("Account", displayMode: .inline)
            .onAppear {
                if let userId = Auth.auth().currentUser?.uid {
                    authViewModel.fetchUserData(userId: userId)
                }
            }
            .sheet(isPresented: $showingPersonalInfo) {
                PersonalInfoView(authViewModel: authViewModel, showingEditInfo: $showingEditInfo)
            }
            .sheet(isPresented: $showingEditInfo) {
                EditInfoView(authViewModel: authViewModel, passwordForEmailChange: $passwordForEmailChange, newEmail: $newEmail, reenterNewEmail: $reenterNewEmail, emailChangeError: $emailChangeError)
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
                if let url = url {
                    authViewModel.updateProfilePicture(userId: userId, profilePictureURL: url.absoluteString)
                }
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
                self.fetchUserData(userId: userId) // Refresh user data
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
                                    self.fetchUserData(userId: user.uid)
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
