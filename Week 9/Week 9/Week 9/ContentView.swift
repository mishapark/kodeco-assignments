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
    NavigationStack {
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
  @MainActor @State private var isDownloading = false
  @MainActor @State private var finishedDownloading = false
  @MainActor @State private var downloadProgress: Float = 0.0

  var body: some View {
    VStack {
      Text(photo.alt)

      if finishedDownloading {
        AsyncImage(url: store.downloadLocation) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          ProgressView()
        }
      }

      if isDownloading {
        ProgressView(value: downloadProgress)
      }
    }
    .navigationBarTitle("Image Detail")
    .onAppear {
      startDownload()
    }
  }

  private func startDownload() {
    Task {
      do {
        isDownloading = true
        try await store.downloadImageBytes(at: URL(string: photo.src.large)!, progress: $downloadProgress)
        isDownloading = false
        finishedDownloading = true
      } catch {
        print(error)
      }
    }
  }
}

#Preview {
  ContentView()
}

