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
                
                VStack(alignment: .leading, spacing: 20) {
                    // Title and Subtitle
                    Text("The Coders Space")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    Text("Select a category to view resources.")
                        .font(.headline)
                        .padding(.horizontal)
                    // Category Selection
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
                                        showAppIcon = false // Hide app icon when a category is selected
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

                    // Resource List
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

                // App Icon
                if showAppIcon {
                    Image("face")
                        .resizable()
                        .frame(width: 250, height: 250)
                        .scaledToFit()
                        .border(Color.black, width: 5)
                        .rotationEffect(Angle(degrees: 0))
                        
                }
            }
            .onAppear {
                codingStore.fetchCategories() // Fetch categories when the view appears
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
                player?.numberOfLoops = -1 // Loop indefinitely
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
            // Display the image
            if let imageName = resource.imageName, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                Image(systemName: "photo") // Placeholder image if no imageName or image not found
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
