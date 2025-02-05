//
//  StartScreen.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/17/24.
//

import Foundation
import SwiftUI

struct SView: View {
    @State private var backgroundColor = Color.blue
    @State private var shouldNavigate = false
    @State private var welcomeOpacity = 1.0

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [backgroundColor, randomColor()]),
                           startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                Text("Welcome to")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)

                Image("face")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 20)) // Rounded corners
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 4)) // White border
                    .padding(.vertical, 20)

                Text("Code Collab")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 2, x: 0, y: 2)

                Spacer()
            }
            .padding()
            .opacity(welcomeOpacity)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                withAnimation {
                    backgroundColor = randomColor()
                }
            }

            Timer.scheduledTimer(withTimeInterval: 8, repeats: false) { _ in
                withAnimation(.easeInOut(duration: 1)) {
                    welcomeOpacity = 0.0
                    // Set shouldNavigate to true after the desired delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        shouldNavigate = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $shouldNavigate) {
            WelcomeView()
        }
        .transition(.opacity)
    }

    private func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}


struct SView_Previews: PreviewProvider {
    static var previews: some View {
        SView()
    }
}



