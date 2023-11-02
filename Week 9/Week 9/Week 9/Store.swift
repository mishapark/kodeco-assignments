//
//  Store.swift
//  Week 9
//
//  Created by Mikhail Pak on 2023-10-27.
//

import Foundation

class SearchStore: NSObject, ObservableObject {
  // MARK: Search Errors

  enum SearchError: Error {
    case URLNotFound
    case failedToDownloadImage
    case invalidResponse
  }

  // MARK: Properties

  @Published var searchResults: [PhotoModel] = []
  @Published var downloadLocation: URL?
  private var downloadTask: URLSessionDownloadTask?

  private var resumeData: Data?
  private var downloadURL: URL?
  private let apiKey = "C11PziT5CU4E2TuLlRfe8KhiZ0bKsVHH24kWnrk8AvS7Zz1KKXppBO4l"
  private var session: URLSession!
  static let BackgroundDownloadDidFinish =
    NSNotification.Name(rawValue: "BackgroundDownloadDidFinish")

  //  // MARK:  Initialization
  override init() {
    super.init()

    let identifier = "MySession"
    let configuration = URLSessionConfiguration.background(withIdentifier: identifier)

    session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }

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

  func downloadArtwork(at url: URL) {
    downloadURL = url
    downloadTask = session.downloadTask(with: url)
    downloadTask?.resume()
  }
}

extension SearchStore: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession,
                  downloadTask: URLSessionDownloadTask,
                  didFinishDownloadingTo location: URL)
  {
    let fileManager = FileManager.default

    guard let documentsPath = fileManager.urls(
      for: .documentDirectory,
      in: .userDomainMask).first
    else {
      return
    }

    let lastPathComponent = downloadURL?.lastPathComponent ?? "image.img"
    let destinationURL = documentsPath.appendingPathComponent(lastPathComponent)

    do {
      if fileManager.fileExists(atPath: destinationURL.path) {
        try fileManager.removeItem(at: destinationURL)
      }

      try fileManager.copyItem(at: location, to: destinationURL)

      Task {
        await MainActor.run {
          downloadLocation = destinationURL
        }
      }
    } catch {}
  }

  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    Task { @MainActor in
      print("urlSessionDidFinishEvents called.")

      NotificationCenter.default.post(name: Self.BackgroundDownloadDidFinish, object: nil)
    }
  }
}
