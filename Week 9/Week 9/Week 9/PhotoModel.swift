//
//  PhotoModel.swift
//  Week 9
//
//  Created by Mikhail Pak on 2023-10-27.
//

import Foundation

struct PexelsResponse: Codable {
  let total_results: Int
  let photos: [PhotoModel]
}

struct PhotoModel: Codable, Identifiable {
  let id: Int
  let url: String
  let src: ImageSource
  let alt: String
}

struct ImageSource: Codable {
  let large: String
}
