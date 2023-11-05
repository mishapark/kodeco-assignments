//
//  Store.swift
//  Week 9
//
//  Created by Mikhail Pak on 2023-10-27.
//

import Foundation
import SwiftUI

class SearchStore: ObservableObject {
  // MARK: Search Errors

  enum SearchError: Error {
    case URLNotFound
    case failedToDownloadImage
    case invalidResponse
    case documentDirectoryError
    case failedToStoreImage
  }

  // MARK: Properties

  @Published var searchResults: [PhotoModel] = []
  @Published var downloadLocation: URL?
  private var downloadTask: URLSessionDownloadTask?

  private var resumeData: Data?
  private var downloadURL: URL?
  private let apiKey = "C11PziT5CU4E2TuLlRfe8KhiZ0bKsVHH24kWnrk8AvS7Zz1KKXppBO4l"
  private var session: URLSession!
//  static let BackgroundDownloadDidFinish =
//    NSNotification.Name(rawValue: "BackgroundDownloadDidFinish")

  //  // MARK:  Initialization
  init() {
    let configuration = URLSessionConfiguration.background(withIdentifier: "MySession")
    session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
  }

//  override init() {
//    super.init()
//
//    let identifier = "MySession"
//    let configuration = URLSessionConfiguration.background(withIdentifier: identifier)
//
//    session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
//  }

  // MARK: Functions

  func search(photo: String) async {
    do {
      guard let url = URL(string: "https://api.pexels.com/v1/search?query=\(photo)") else {
        throw SearchError.URLNotFound
      }

      var request = URLRequest(url: url)
      request.addValue("\(apiKey)", forHTTPHeaderField: "Authorization")

      let (data, response) = try await URLSession.shared.data(for: request)

      guard let response = response as? HTTPURLResponse, (200 ..< 300).contains(response.statusCode) else {
        return
      }

      let decodedData = try JSONDecoder().decode(PexelsResponse.self, from: data)

      Task { @MainActor in
        searchResults = decodedData.photos
      }
    } catch {
      print(error)
    }
  }

  func downloadImageBytes(at url: URL, progress: Binding<Float>) async throws {
    let (asyncBytes, response) = try await session.bytes(from: url)

    let contentLength = Float(response.expectedContentLength)
    var data = Data(capacity: Int(contentLength))

    for try await byte in asyncBytes {
      data.append(byte)

      let currentProgress = Float(data.count) / contentLength

      if Int(progress.wrappedValue * 100) != Int(currentProgress * 100) {
        progress.wrappedValue = currentProgress
      }
    }

    let fileManager = FileManager.default

    guard let documentsPath = fileManager.urls(
      for: .documentDirectory,
      in: .userDomainMask).first
    else {
      throw SearchError.documentDirectoryError
    }

    let lastPathComponent = url.lastPathComponent
    let destinationURL = documentsPath.appendingPathComponent(lastPathComponent)

    do {
      if fileManager.fileExists(atPath: destinationURL.path) {
        try fileManager.removeItem(at: destinationURL)
      }

      try data.write(to: destinationURL)
    } catch {
      throw SearchError.failedToStoreImage
    }

    await MainActor.run {
      downloadLocation = destinationURL
    }
  }

//  func downloadArtwork(at url: URL) {
//    downloadURL = url
//    downloadTask = session.downloadTask(with: url)
//    downloadTask?.resume()
//  }
}

// extension SearchStore: URLSessionDownloadDelegate {
//  func urlSession(_ session: URLSession,
//                  downloadTask: URLSessionDownloadTask,
//                  didFinishDownloadingTo location: URL)
//  {
//    let fileManager = FileManager.default
//
//    guard let documentsPath = fileManager.urls(
//      for: .documentDirectory,
//      in: .userDomainMask).first
//    else {
//      return
//    }
//
//    let lastPathComponent = downloadURL?.lastPathComponent ?? "image.img"
//    let destinationURL = documentsPath.appendingPathComponent(lastPathComponent)
//
//    do {
//      if fileManager.fileExists(atPath: destinationURL.path) {
//        try fileManager.removeItem(at: destinationURL)
//      }
//
//      try fileManager.copyItem(at: location, to: destinationURL)
//
//      Task {
//        await MainActor.run {
//          downloadLocation = destinationURL
//        }
//      }
//    } catch {}
//  }
//
//  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
//    Task { @MainActor in
//      print("urlSessionDidFinishEvents called.")
//
//      NotificationCenter.default.post(name: Self.BackgroundDownloadDidFinish, object: nil)
//    }
//  }
// }
