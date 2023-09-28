//
//  Task.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import Foundation

struct Task: Identifiable, Hashable {
  let id = UUID()
  var title: String
  var isCompleted: Bool
  var notes: String
}
