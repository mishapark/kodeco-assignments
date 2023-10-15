/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class APIStore: ObservableObject {
  @Published var apiList: APIList?
  @Published var fileNotFound = false

  func readJSONFromBundle() {
    if let url = Bundle.main.url(forResource: "apilist", withExtension: "json") {
      do {
        let data = try Data(contentsOf: url)
        let apiList = try JSONDecoder().decode(APIList.self, from: data)
        self.apiList = apiList
      } catch {
        print(error)
      }
    } else {
      readJSONFromDocuments()
    }
  }

  func readJSONFromDocuments() {
    if let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
      let fileURL = documentDirectoryURL.appendingPathComponent("savedAPIlist.json")

      do {
        let decoder = JSONDecoder()
        let jsonData = try Data(contentsOf: fileURL)
        let apiList = try decoder.decode(APIList.self, from: jsonData)

        self.apiList = apiList
      } catch {
        print(error)
      }
    } else {
      fileNotFound = true
    }
  }

  func saveJSONToDocuments() {
    guard let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      return
    }
    do {
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      let jsonData = try encoder.encode(apiList)
      let fileURL = documentDirectoryURL.appendingPathComponent("savedAPIlist.json")
      try jsonData.write(to: fileURL)
      print("JSON data saved to: \(fileURL.path)")
    } catch {
      print(error)
    }
  }
}
