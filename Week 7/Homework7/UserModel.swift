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

struct ResultData: Codable {
  var results: [User]
  var info: Info
}

struct User: Codable, Identifiable {
  var id = UUID()
  var gender: String
  var name: UserName
  var location: UserLocation
  var email: String
  var login: UserLogin
  var dob: UserDOB
  var registered: UserRegistered
  var phone: String
  var cell: String
  var idDetails: UserID
  var picture: UserPicture
  var nat: String

  enum CodingKeys: String, CodingKey {
    case gender
    case name
    case location
    case email
    case login
    case dob
    case registered
    case phone
    case cell
    case idDetails = "id"
    case picture
    case nat
  }
}

struct UserName: Codable {
  var title: String
  var first: String
  var last: String
}

struct UserLocation: Codable {
  var street: UserStreet
  var city: String
  var state: String
  var country: String
  var postcode: Int
  var coordinates: UserCoordinates
  var timezone: UserTimezone
}

struct UserStreet: Codable {
  var number: Int
  var name: String
}

struct UserCoordinates: Codable {
  var latitude: String
  var longitude: String
}

struct UserTimezone: Codable {
  var offset: String
  var description: String
}

struct UserLogin: Codable {
  var uuid: String
  var username: String
  var password: String
  var salt: String
  var md5: String
  var sha1: String
  var sha256: String
}

struct UserDOB: Codable {
  var date: String
  var age: Int
}

struct UserRegistered: Codable {
  var date: String
  var age: Int
}

struct UserID: Codable {
  var name: String?
  var value: String?
}

struct UserPicture: Codable {
  var large: String
  var medium: String
  var thumbnail: String
}

struct Info: Codable {
  var seed: String
  var results: Int
  var page: Int
  var version: String
}
