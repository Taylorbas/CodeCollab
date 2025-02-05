//
//  WelcomeView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/20/24.
//

import Foundation
import SwiftUI

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView { // Embed in a NavigationView to enable navigation
            VStack {
                // Top bar with "Tutor Sign Up" and a right directional button
                HStack {
                    Spacer()
                    Text("Tutor")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    NavigationLink(destination: WelcomeScreenTutor()) { // Link to WelcomeScreenTutor
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.white)
                            .font(.title)
                    }
                }
                .padding()
                
                Spacer()
                
                // Title text at the top
                Text("Welcome Students!!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Flame icon
                Image(systemName: "flame.fill")
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
            .background(Color.blue)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

// Preview for WelcomeView
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}

