//
//  LoginScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/17/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var email = ""
    @State private var password = ""
    @State private var emailError = false
    @State private var passwordError = false
    @State private var isLinkActive = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                VStack {
                    VStack(spacing: 40) {
                        ZStack {
                            Ellipse()
                                .frame(width: 510, height: 478)
                                .padding(.leading, -200)
                                .foregroundColor(Color("color2"))
                                .padding(.top, -200)
                            
                            Ellipse()
                                .frame(width: 458, height: 428)
                                .padding(.trailing, -500)
                                .foregroundColor(Color("color1"))
                                .padding(.top, -200)
                            
                            Text("Welcome \nBack")
                                .foregroundColor(.white)
                                .font(.system(size: 35))
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, 20)
                        }
                        VStack(spacing: 30) {
                            VStack(spacing: 30) {
                                CustomTextField(placeHolder: "Email", imageName: "envelope", bColor: Color("textColor1"), tOpacity: 0.6, value: $email)
                                    .onChange(of: email) { _ in emailError = false }
                                CustomTextField(placeHolder: "Password", imageName: "lock", bColor: Color("textColor1"), tOpacity: 0.6, value: $password)
                                    .onChange(of: password) { _ in passwordError = false }
                            }
                            
                            if let errorMessage = authViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .padding([.horizontal, .bottom], 20)
                            }
                            
                            VStack(alignment: .trailing) {
                                Text("Forgot Password")
                                    .fontWeight(.medium)
                                
                                Button(action: {
                                    validateFields()
                                    if !emailError && !passwordError {
                                        authViewModel.logIn(email: email, password: password)
                                    }
                                }) {
                                    CustomButton(title: "SIGN IN", bgColor: Color("color1"))
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    Spacer()
                    
                    HStack {
                        Text("Don't have an Account?")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                        
                        Button(action: {}, label: {
                            Text("SIGN UP")
                                .font(.system(size: 18))
                                .foregroundColor(Color("color1"))
                                .fontWeight(.bold)
                        })
                    }
                    .frame(height: 63)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color("color2"))
                    .ignoresSafeArea()
                }
                
                TopBarView()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .navigationBarHidden(true)
    }
    
    private func validateFields() {
        emailError = email.isEmpty || !email.contains("@")
        passwordError = password.isEmpty
        
        if emailError {
            authViewModel.errorMessage = "Please enter a valid email"
        } else if passwordError {
            authViewModel.errorMessage = "Please enter a password"
        } else {
            authViewModel.errorMessage = nil // Clear error if all fields are valid
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
