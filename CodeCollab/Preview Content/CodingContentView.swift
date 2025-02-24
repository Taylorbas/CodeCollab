//
//  ContentView.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 10/16/24.
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseCore
import AVFoundation

class SelectedCoding: ObservableObject {
    @Published var index: Int = 0
    @Published var showResources: Bool = false
}

struct CodingContentView: View {
    @ObservedObject var codingStore: CodingStore
    @ObservedObject var selectedCoding = SelectedCoding()
    @State private var selectedResourceItem: Resource?
    @State private var player: AVAudioPlayer?
    @State private var showAppIcon = true

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {


                    VStack(alignment: .leading, spacing: 25) {
                        Text("Coders Handbook")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                      

                        if codingStore.categories.isEmpty {
                            Text("Loading categories...")
                                .font(.headline)
                                .padding()
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(codingStore.categories) { category in
                                        Button(action: {
                                            selectedCoding.index = codingStore.categories.firstIndex(where: { $0.id == category.id }) ?? 0
                                            selectedCoding.showResources = true
                                            codingStore.fetchResources(for: category.id)
                                            showAppIcon = false
                                        }) {
                                            Text(category.label)
                                                .padding()
                                                .background(Color.black)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding()
                            }
                        }

                        if selectedCoding.showResources {
                            if codingStore.resources.isEmpty {
                                Text("Loading resources...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding()
                            } else {
                                List(codingStore.resources) { resource in
                                    NavigationLink(
                                        destination: DescriptionView(resource: resource)
                                    ) {
                                        ResourceRow(resource: resource)
                                    }
                                }
                                .listStyle(InsetGroupedListStyle())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                    Spacer()
                    
                    // Bottom toolbar
                    HStack {
                        Spacer()
                        Button(action: {
                            // CodeHub action
                        }) {
                            VStack {
                                Image(systemName: "book.closed")
                                Text("Tutors")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        Button(action: {
                            // Settings action
                        }) { VStack {
                            NavigationLink(destination: MessagingHomeView()) {
                                VStack {
                                    Image(systemName: "bubble.left.and.bubble.right")
                                    Text("Messaging")
                                        .font(.caption)
                                }
                            }
                        }
                        }
                        Spacer()
                        Button(action: {
                            // Settings action
                        }) {
                            VStack {
                                Image(systemName: "desktopcomputer")
                                Text("CodeHub")
                                    .font(.caption)
                            }
                        }
                        Spacer()
                        Button(action: {
                            // Settings action
                        }) {
                            VStack {
                                NavigationLink(destination: SettingsView()) {
                                    VStack {
                                        Image(systemName: "gear")
                                            .font(.system(size: 24))
                                        Text("Settings")
                                            .font(.caption)
                                    }
                                }

                            }
                        }
                        Spacer()
                        Button(action: {
                            // Account action
                        }) {
                            VStack {
                                NavigationLink(destination: AccountView()) {
                                    VStack {
                                        Image(systemName: "person.circle")
                                            .font(.system(size: 24))
                                        Text("Account")
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding()
                    .background(Color.white.shadow(radius: 5))
                }
            }
            .onAppear {
                codingStore.fetchCategories()
                playBackgroundMusic()
            }
        }
    }

    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "Aylex - Meditation (freetouse.com)", withExtension: "mp3") else {
            print("Error: MP3 file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
}

struct ResourceRow: View {
    var resource: Resource

    var body: some View {
        VStack(alignment: .leading) {
            Text(resource.name)
                .font(.headline)
            Text(resource.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                
            if let url = URL(string: resource.url) {
                Link("Learn More", destination: url)
                    .font(.body)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}

struct DescriptionView: View {
    var resource: Resource

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let imageName = resource.imageName, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .cornerRadius(10)
            }

            Text(resource.name)
                .font(.title)
                .fontWeight(.bold)

            Text(resource.description)
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()
            if let url = URL(string: resource.url) {
                Button(action: {
                    UIApplication.shared.open(url)
                }) {
                    Text("Visit site?")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .navigationBarTitle(Text(resource.name), displayMode: .inline)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.6)]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

struct CodingContentView_Previews: PreviewProvider {
    static var previews: some View {
        let codingStore = CodingStore()
        return CodingContentView(codingStore: codingStore)
            .environmentObject(AuthViewModel())
    }
}
