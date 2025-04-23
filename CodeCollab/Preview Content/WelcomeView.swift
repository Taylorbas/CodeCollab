//
//  WelcomeView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/20/24.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView { // Embed in a NavigationView to enable navigation
            VStack {
                
                Spacer()
                
                // Title text at the top
                Text("Welcome Students!")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                
                // Flame icon
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                
                // Subtitle text below the flame
                Text("Welcome aboard! Please Log In or Sign Up below.")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 25)
                
                Spacer()
                
                // Buttons for Log In and Sign Up with navigation links
                VStack(spacing: 20) {
                    
                    // Tutor Button
                    NavigationLink(destination: WelcomeScreenTutor()) {
                        Text("Tutor Login / Sign Up")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .scaleEffect(1.05)
                            .animation(.easeInOut(duration: 0.2), value: 0)
                    }
                    
                    // Log In Button
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .scaleEffect(1.05)
                            .animation(.easeInOut(duration: 0.2), value: 0)
                    }
                    
                    // Sign Up Button
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                            .shadow(radius: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .scaleEffect(1.05)
                            .animation(.easeInOut(duration: 0.2), value: 0)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
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
