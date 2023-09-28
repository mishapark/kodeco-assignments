//
//  AddEditTaskView.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import SwiftUI

struct AddEditTaskView: View {
  var isEditMode: Bool

  var task: Task?
  @ObservedObject var taskStore: Store
  @Binding var showModal: Bool

  @State var showWarning: Bool = false
  @State private var title: String = ""
  @State private var note: String = ""
  @State private var isCompleted: Bool = false

  var body: some View {
    List {
      Section(header: Text("Task Title")) {
        TextField("Task Title", text: $title)
      }
      Section(header: Text("Notes")) {
        TextField("Notes", text: $note)
      }
      if isEditMode {
        Section(header: Text("Task Title")) {
          Toggle(isOn: $isCompleted, label: {
            Text("Completed:")
          })
        }
      }
    }
    .navigationTitle(isEditMode ? "" : "Adding New Task")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(leading: isEditMode ? nil : Button(action: closeModal) {
      Text("Cancel")
    }, trailing: isEditMode ? nil : Button(action: addTask) {
      Text("Add")
    })
    .alert(isPresented: $showWarning, content: {
      Alert(title: Text("Invalid Task"), dismissButton: .default(Text("Got it!")))
    })
  }

  private func addTask() {
    if title.isEmpty {
      showWarning = true
      return
    }
    taskStore.addTask(Task(title: title, isCompleted: isCompleted, notes: note))
    closeModal()
  }

  private func closeModal() {
    showModal.toggle()
  }
}

#Preview {
  AddEditTaskView(isEditMode: false, taskStore: Store(), showModal: .constant(false))
}
