//
//  CategoriesView.swift
//  Homework6
//
//  Created by Mikhail Pak on 2023-10-05.
//

import SwiftUI

struct CategoriesView: View {
  @ObservedObject var taskStore: TaskStore
  @State var category: Category?

  let columns = [
    GridItem(.adaptive(minimum: 140, maximum: 170))
  ]

  var body: some View {
    NavigationStack {
      VStack {
        LazyVGrid(columns: columns) {
          ForEach(Category.allCases, id: \.self) { category in
            Button {
              withAnimation {
                if self.category == category {
                  self.category = nil
                } else {
                  self.category = category
                }
              }
            } label: {
              VStack {
                let numberOfTasks = taskStore.tasks.filter { $0.category == category
                }.count

                Text(category.rawValue)
                Spacer()
                Text("\(numberOfTasks)")
              }
              .padding(.vertical, 40)
              .frame(maxWidth: .infinity, minHeight: 150)
              .background(.red)
              .foregroundColor(.white)
              .font(.title2)
              .fontWeight(.bold)
              .clipShape(RoundedRectangle(cornerRadius: 7.0))
            }
          }
        }
        TaskListView(category: category, taskSelection: .categorized, taskStore: taskStore)
      }
      .navigationTitle("Categories")
    }
  }
}

#Preview {
  CategoriesView(taskStore: TaskStore())
}
