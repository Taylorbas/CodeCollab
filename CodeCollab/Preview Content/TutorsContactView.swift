//
//  TutorsContactView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 3/10/25.
//

import SwiftUI

struct Tutor: Identifiable {
    let id: String
    let name: String
    let specialization: String
}

struct TutorContactsView: View {
    @State private var searchText: String = ""
    
    private let tutors: [Tutor] = [
        Tutor(id: "101", name: "Alice Johnson", specialization: "Mathematics"),
        Tutor(id: "102", name: "Bob Smith", specialization: "Computer Science"),
        Tutor(id: "103", name: "Charlie Brown", specialization: "Physics"),
        Tutor(id: "104", name: "David Lee", specialization: "Chemistry"),
        Tutor(id: "105", name: "Emma Watson", specialization: "Biology")
    ]
    
    var filteredTutors: [Tutor] {
        if searchText.isEmpty {
            return tutors
        } else {
            return tutors.filter { tutor in
                tutor.name.localizedCaseInsensitiveContains(searchText) ||
                tutor.id.localizedCaseInsensitiveContains(searchText) ||
                tutor.specialization.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Tutors")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    
                if filteredTutors.isEmpty {
                    Text("No Search Matches Found")
                        .foregroundColor(.red)
                        .font(.headline)
                        .padding()
                } else {
                    List(filteredTutors) { tutor in
                        TutorRow(tutor: tutor)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search Tutors...", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.trailing, 10)
                    }
                )
        }
    }
}

struct TutorRow: View {
    let tutor: Tutor
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(tutor.name)
                    .font(.headline)
                    .foregroundColor(.black)
                Text(tutor.specialization)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("ID: \(tutor.id)")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct TutorContactsView_Previews: PreviewProvider {
    static var previews: some View {
        TutorContactsView()
    }
}
