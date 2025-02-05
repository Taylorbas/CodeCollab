//
//  PicturePickerView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 12/5/24.
//

import SwiftUI

struct PicturePickerView: View {
    @Binding var selectedPicture: String
    var onSave: () -> Void
    
    @Environment(\.presentationMode) private var presentationMode
    
    //List of Profile Pictures
    private let pictureOptions = [
        "Giraffe",
        "Racoon",
        "Skull",
        "LadyArt",
        "Penguin",
        "BaldEagle"
    ]
    
    // Define the grid layout with two columns
    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack {
            Text("Choose a Profile Picture")
                .font(.headline)
                .padding()
            
            // Use LazyVGrid for vertical grid layout
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(pictureOptions, id: \.self) { picture in
                        Image(picture)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedPicture = picture
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedPicture == picture ? Color.blue : Color.clear, lineWidth: 3)
                            )
                    }
                }
                .padding()
            }
            
            Button(action: {
                onSave()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
