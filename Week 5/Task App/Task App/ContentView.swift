//
//  ContentView.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import SwiftUI

struct ContentView: View {
  @State var isAddTaskSheetOpen = false
  @State var selectedTask: Task?
  @EnvironmentObject var taskStore: Store

  var body: some View {
    NavigationStack {
      ZStack {
        ScrollView(.vertical) {
          ForEach(taskStore.tasks) { task in
            NavigationLink(value: task) {
              TaskRow(task: task)
            }
          }
        }
        VStack(alignment: .leading) {
          Spacer()
          NewTaskButton(onTap: {
            isAddTaskSheetOpen = true
          })
        }
      }
      .padding(.horizontal)
      .sheet(isPresented: $isAddTaskSheetOpen, content: {
        NavigationStack {
          AddEditTaskView(
            isEditMode: false,
            showModal: $isAddTaskSheetOpen)
        }
      })
      .navigationTitle("My Tasks")
      .navigationDestination(for: Task.self) { task in
        AddEditTaskView(
          isEditMode: true,
          task: task
        )
      }
    }
  }
}

#Preview {
  ContentView()
    .environmentObject(Store())
}
