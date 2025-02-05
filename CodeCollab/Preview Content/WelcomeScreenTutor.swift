//
//  WelcomeScreenTutor.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 11/20/24.
//

import Foundation
import SwiftUI

struct WelcomeScreenTutor: View {
    var body: some View {
        VStack {
            // Top bar with back button on the left
            HStack {
                Button(action: {
                    // Action to go back
                }) {
                    
                }
                Spacer()
            }
            .padding()
            
            Spacer()
            
            // Title text at the top
            Text("Welcome Tutors!!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            // Flame icon
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            // Subtitle text below the flame
            Text("Welcome aboard, please Log In or Sign Up below!!")
                .foregroundColor(.white)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            
            Spacer()
            
            // Buttons for Log In and Sign Up with navigation links
            VStack(spacing: 20) {
                // Log In Button
                NavigationLink(destination: LoginView()) {
                    Text("Log In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
                
                // Sign Up Button
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.white, lineWidth: 2)
                        )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .background(Color.green) // Changed background color for tutors
        .edgesIgnoringSafeArea(.all)
    }
}

// Preview for WelcomeScreenTutor
struct WelcomeScreenTutor_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreenTutor()
    }
}
