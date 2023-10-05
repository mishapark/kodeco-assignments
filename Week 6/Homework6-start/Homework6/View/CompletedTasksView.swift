//
//  TasksView.swift
//  Homework6
//
//  Created by Mikhail Pak on 2023-10-05.
//

import SwiftUI

struct CompletedTasksView: View {
  @ObservedObject var taskStore: TaskStore

  let title: String

  var body: some View {
    NavigationStack {
      TaskListView(taskSelection: .completed, taskStore: taskStore)
        .navigationTitle(title)
    }
  }
}

#Preview {
  CompletedTasksView(taskStore: TaskStore(), title: "My Tasks")
}
