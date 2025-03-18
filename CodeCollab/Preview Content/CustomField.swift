//
//  CustomField.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 3/10/25.
//

import SwiftUI

struct CustomTextField: View {
    var placeHolder: String
    var imageName: String
    var bColor: Color
    var tOpacity: Double
    @Binding var value: String
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .padding(.leading, 20)
                .foregroundColor(bColor.opacity(tOpacity))
            
            if placeHolder == "Password" || placeHolder == "Confirm Password" {
                ZStack(alignment: .leading) {
                    if value.isEmpty {
                        Text(placeHolder) // Fixed incorrect variable name
                            .foregroundColor(bColor.opacity(tOpacity))
                            .padding(.leading, 12)
                            .font(.system(size: 20))
                    }
                    SecureField("", text: $value)
                        .padding(.leading, 12)
                        .font(.system(size: 20))
                        .frame(height: 45)
                }
            } else {
                ZStack(alignment: .leading) {
                    if value.isEmpty {
                        Text(placeHolder)
                            .foregroundColor(bColor.opacity(tOpacity))
                            .padding(.leading, 12)
                            .font(.system(size: 20))
                    }
                    TextField("", text: $value)
                        .padding(.leading, 12)
                        .font(.system(size: 20))
                        .frame(height: 45)
                        .foregroundColor(bColor)
                }
            }
        }
        .overlay(
            Divider()
                .overlay(bColor.opacity(tOpacity))
                .padding(.horizontal, 20),
            alignment: .bottom
        )
    }
}

struct CustomButton: View {
    var title: String
    var bgColor: Color // Fixed incorrect type
    
    var body: some View {
        Text(title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(height: 58)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(bgColor) // Fixed issue with String instead of Color
            .cornerRadius(15)
    }
}

struct TopBarView: View {
    var body: some View {
        Button(action: {}, label: {
            Image("back")
                .resizable()
                .frame(width: 17.5, height: 28.5)
                .padding(.horizontal, 20)
        })
    }
}
