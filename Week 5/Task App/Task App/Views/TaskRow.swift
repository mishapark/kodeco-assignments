//
//  TaskRow.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import SwiftUI

struct TaskRow: View {
  @EnvironmentObject var taskStore: Store
  var task: Task

  var body: some View {
    VStack {
      HStack {
        Text(task.title)
          .font(.title3)
          .foregroundStyle(.blue)
          .fontWeight(.semibold)
        Spacer()
        Image(systemName: task.isCompleted ? "checkmark.square" : "square")
          .foregroundStyle(task.isCompleted ? .green : .red)
          .fontWeight(.bold)
          .font(.title3)
          .onTapGesture {
            withAnimation(.linear(duration: 0.2)) {
              taskStore.updateTask(task, isCompleted: !task.isCompleted)
            }
          }
      }
      .padding()
      Divider()
    }
  }
}

#Preview {
  TaskRow(task: Task(title: "asdasd", isCompleted: true, notes: "zxczxc"))
    .environmentObject(Store())
}
