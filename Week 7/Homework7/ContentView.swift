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

import SwiftUI

enum ContentViewTab {
  case api, user
}

struct ContentView: View {
  @StateObject var apiVM = APIStore()
  @StateObject var userVM = UserStore()
  @State var selectedTab: ContentViewTab = .user

  var body: some View {
    TabView(selection: $selectedTab) {
      NavigationStack {
        List(apiVM.apiList?.entries ?? []) { api in
          NavigationLink {
            VStack {
              Text(api.category)
              Link(api.name, destination: URL(string: api.link)!)
              Text(api.description)
              Text("Auth: \(api.auth.isEmpty ? "N/A" : api.auth)")
              Text("Cors: \(api.cors)")
              Text("HTTPS: \(api.HTTPS ? "yes" : "no")")
            }
          } label: {
            Text(api.name)
          }
        }
        .navigationTitle("API List")
        .alert(isPresented: $apiVM.fileNotFound) {
          Alert(
            title: Text("File not found"),
            message: Text("JSON file not found"),
            dismissButton: .default(Text("OK"))
          )
        }
      }
      .tag(ContentViewTab.api)
      .tabItem {
        Label("API", systemImage: "menubar.arrow.down.rectangle")
          .environment(\.symbolVariants, .none)
      }
      .onAppear {
        apiVM.readJSONFromBundle()
//        apiVM.saveJSONToDocuments()
      }
      NavigationStack {
        List(userVM.usersData?.results ?? []) { user in
          NavigationLink {
            VStack {
              Text("\(user.name.first) \(user.name.last)")
              Text("\(user.location.country) - \(user.location.city)")
              Text(user.email)
              Text("Age: \(user.dob.age)")
              Text(user.phone)
              AsyncImage(url: URL(string: user.picture.large))
            }
          } label: {
            Text("\(user.name.first) \(user.name.last)")
          }
        }
        .navigationTitle("User List")
        .alert(isPresented: $userVM.fileNotFound) {
          Alert(
            title: Text("File not found"),
            message: Text("JSON file not found"),
            dismissButton: .default(Text("OK"))
          )
        }
      }
      .tag(ContentViewTab.user)
      .tabItem {
        Label("User", systemImage: "person")
          .environment(\.symbolVariants, .none)
      }
      .onAppear {
        userVM.readJSONFromBundle()
//        userVM.saveJSONToDocuments()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
