//
//  ContentView.swift
//  Week 9
//
//  Created by Mikhail Pak on 2023-10-27.
//

import SwiftUI

struct ContentView: View {
  @State private var query = ""
  @StateObject private var store = SearchStore()

  var body: some View {
    NavigationView {
      VStack {
        TextField("Search for images", text: $query, onCommit: {
          Task {
            await store.search(photo: query)
          }
        })
        .textFieldStyle(.roundedBorder)
        Spacer()
        ScrollView {
          ForEach(store.searchResults) { photo in
            NavigationLink(destination: DetailView(photo: photo, store: store)) {
              AsyncImage(url: URL(string: photo.src.large)) { image in
                image
                  .resizable()
                  .aspectRatio(contentMode: .fit)
              } placeholder: {
                ProgressView()
              }
            }
          }
        }
      }
      .padding()
      .navigationBarTitle("Image Search")
    }
  }
}

struct DetailView: View {
  let photo: PhotoModel
  @ObservedObject var store: SearchStore

  var body: some View {
    VStack {
      Text(photo.alt)
      if let downloadLocation = store.downloadLocation {
        AsyncImage(url: downloadLocation) { phase in
          switch phase {
          case .empty:
            ProgressView()
          case .success(let image):
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          case .failure:
            Text("Failed to load image")
          @unknown default:
            ProgressView()
          }
        }
      } else {
        ProgressView()
      }
    }
    .navigationBarTitle("Image Detail")
    .onAppear {
      store.downloadArtwork(at: URL(string: photo.src.large)!)
    }
  }
}

#Preview {
  ContentView()
}
