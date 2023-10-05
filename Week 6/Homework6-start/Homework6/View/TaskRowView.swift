//
//  TaskRow.swift
//  

import SwiftUI

struct TaskRowView: View {
  @ObservedObject var taskStore: TaskStore
  let task: Task
  var body: some View {
    HStack {
      Text(task.title)
      Spacer()
      Image(systemName: task.isCompleted ? "checkmark.square" : "square")
        .foregroundColor(task.isCompleted ? Color.green : Color.red)
        .onTapGesture {
          withAnimation(.linear(duration: 0.2)) {
            taskStore.toggleTaskCompletion(task: task)
          }
        }
    }
    .font(.title3)
    .bold()
    .padding([.top, .bottom], 15)
    .padding([.leading, .trailing], 10)
  }
}

struct TaskRow_Previews: PreviewProvider {
  static var previews: some View {
    TaskRowView(taskStore: TaskStore(), task: Task(title: "My Task", category: .noCategory, isCompleted: false))
  }
}
