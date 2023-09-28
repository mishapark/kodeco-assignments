//
//  Store.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import Foundation

class Store: ObservableObject {
  @Published var tasks: [Task] = [
    Task(title: "Buy groceries", isCompleted: false, notes: "Bread, milk, eggs"),
    Task(title: "Walk the dog", isCompleted: false, notes: "After work"),
    Task(title: "Study Swift", isCompleted: true, notes: "Combine and RxSwift"),
  ]

  func addTask(_ task: Task) {
    tasks.append(task)
  }

  func updateTask(_ task: Task, title: String? = nil, note: String? = nil, isCompleted: Bool? = nil) {
    guard let indexToUpdate = tasks.firstIndex(where: { currentTask in
      currentTask.id == task.id
    }) else { return }

    if let newTitle = title {
      tasks[indexToUpdate].title = newTitle
    }

    if let newNote = note {
      tasks[indexToUpdate].notes = newNote
    }

    if let newIsCompleted = isCompleted {
      tasks[indexToUpdate].isCompleted = newIsCompleted
    }
  }
}
