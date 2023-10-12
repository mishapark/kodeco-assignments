//
//  IncompletedTasksView.swift
//  Homework6
//
//  Created by Mikhail Pak on 2023-10-05.
//

import SwiftUI

struct IncompletedTasksView: View {
  @ObservedObject var taskStore: TaskStore

  let title: String

  var body: some View {
    NavigationStack {
      TaskListView(taskSelection: .incompleted, taskStore: taskStore)
        .navigationTitle(title)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            NewTaskButtonView(taskStore: taskStore)
          }
        }
    }
  }
}

#Preview {
  IncompletedTasksView(taskStore: TaskStore(), title: "My Tasks")
}
