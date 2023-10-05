//
//  TaskListView.swift
//

import SwiftUI

enum TaskSelection {
  case all, completed, incompleted, categorized
}

struct TaskListView: View {
  var category: Category?
  var taskSelection: TaskSelection

  @ObservedObject var taskStore: TaskStore
  @State private var taskSearch = ""

  var completedTasks: [Task] {
    taskStore.tasks.filter { $0.isCompleted == true }
  }

  var incompletedTasks: [Task] {
    taskStore.tasks.filter { $0.isCompleted == false }
  }

  func categorizeTasks(category: Category) -> [Task] {
    taskStore.tasks.filter { $0.category == category }
  }

  var matchingTasks: [Task] {
    var matchingTasks: [Task]

    switch taskSelection {
    case .all:
      matchingTasks = taskStore.tasks
    case .completed:
      matchingTasks = completedTasks
    case .incompleted:
      matchingTasks = incompletedTasks
    case .categorized:
      if category == nil {
        matchingTasks = taskStore.tasks
      } else {
        matchingTasks = categorizeTasks(category: category!)
      }
    }

    if !taskSearch.isEmpty {
      matchingTasks = matchingTasks.filter {
        $0.title.lowercased().contains(taskSearch.lowercased())
      }
    }

    return matchingTasks
  }

  var body: some View {
    VStack {
      if matchingTasks.isEmpty {
        Spacer()
        Text("No tasks")
        Spacer()
      } else {
        List(matchingTasks) { task in
          // Hiding trailing arrow from NavigationLink
          ZStack {
            NavigationLink {
              TaskDetailView(task: $taskStore.tasks
                .first(where: { $0.id == task.id })!)
            } label: {
              EmptyView()
            }
            .opacity(0)
            TaskRowView(taskStore: taskStore, task: task)
          }
        }
        .listStyle(PlainListStyle())
      }
    }
    .searchable(text: $taskSearch)
  }
}

struct TaskListView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView(taskSelection: .all, taskStore: TaskStore())
  }
}
