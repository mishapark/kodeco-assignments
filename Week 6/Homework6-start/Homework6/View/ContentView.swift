//
//  ContentView.swift
//

import SwiftUI

enum ContentViewTab {
  case completed, incompleted, all
}

struct ContentView: View {
  @StateObject var taskStore = TaskStore()

  @State var selectedTab: ContentViewTab = .all

  var body: some View {
    TabView(selection: $selectedTab) {
      CategoriesView(taskStore: taskStore)
        .tag(ContentViewTab.all)
        .tabItem {
          Label("Categories", systemImage: "circle.grid.3x3.circle")
            .environment(\.symbolVariants, .none)
        }
      IncompletedTasksView(taskStore: taskStore, title: "My Tasks")
        .tag(ContentViewTab.incompleted)
        .tabItem {
          Label("Tasks", systemImage: "list.bullet.circle")
            .environment(\.symbolVariants, .none)
        }
      CompletedTasksView(taskStore: taskStore, title: "Completed Tasks")
        .tag(ContentViewTab.completed)
        .tabItem {
          Label("Completed", systemImage: "checkmark.circle")
            .environment(\.symbolVariants, .none)
        }
    }
  }
  
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
