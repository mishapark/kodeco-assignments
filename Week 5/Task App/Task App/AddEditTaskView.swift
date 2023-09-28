//
//  AddEditTaskView.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import SwiftUI

enum FocusedField {
  case title, note
}

struct AddEditTaskView: View {
  var isEditMode: Bool
  var task: Task?

  @EnvironmentObject var taskStore: Store

  // Modals & Alerts
  var showModal: Binding<Bool>? = nil
//  @State var showWarning: Bool = false

  // Inputs
  @State private var title: String = ""
  @State private var note: String = ""
  @State private var isCompleted: Bool = false

  @FocusState private var focusedField: FocusedField?

  var body: some View {
    List {
      Section(header: Text("Task Title")) {
        TextField("Task Title", text: $title)
          .focused($focusedField, equals: .title)
          .onChange(of: title) { _, newValue in
            if isEditMode {
              taskStore.updateTask(task!, title: newValue)
            }
          }
      }
      Section(header: Text("Notes")) {
        TextField("Notes", text: $note, axis: .vertical)
          .lineLimit(5...)
          .focused($focusedField, equals: .note)
          .onChange(of: note) { _, newValue in
            if isEditMode {
              taskStore.updateTask(task!, note: newValue)
            }
          }
      }
      if isEditMode {
        Section(header: Text("Task Title")) {
          Toggle(isOn: $isCompleted, label: {
            Text("Completed:")
          })
          .onChange(of: isCompleted) { _, newValue in
            taskStore.updateTask(task!, isCompleted: newValue)
          }
        }
      }
    }
    .onAppear(perform: {
      populateInputs()
      focusedField = .title
    })
    .navigationTitle(isEditMode ? "" : "Adding New Task")
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarItems(
      leading: isEditMode ? nil : Button(action: closeModal) { Text("Cancel") },
      trailing: isEditMode ? nil : Button(action: addTask) { Text("Add") }.disabled(title.isEmpty)
    )
    // Had an alert to validate a note, before I read the A/B part
//    .alert(
//      isPresented: $showWarning,
//      content: {
//        Alert(
//          title: Text("Invalid Task"),
//          dismissButton: .default(Text("Got it!"))
//        )
//      }
//    )
  }

  private func populateInputs() {
    if task != nil {
      title = task!.title
      note = task!.notes
      isCompleted = task!.isCompleted
    }
  }

  private func addTask() {
//    if title.isEmpty {
//      showWarning = true
//      return
//    }
    taskStore.addTask(Task(title: title, isCompleted: isCompleted, notes: note))
    closeModal()
  }

  private func closeModal() {
    showModal!.wrappedValue = false
  }
}

#Preview {
  AddEditTaskView(isEditMode: false, showModal: .constant(false))
    .environmentObject(Store())
}
