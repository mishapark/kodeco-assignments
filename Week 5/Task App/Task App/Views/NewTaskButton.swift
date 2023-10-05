//
//  NewTaskButton.swift
//  Task App
//
//  Created by Mikhail Pak on 2023-09-27.
//

import SwiftUI

struct NewTaskButton: View {
  var onTap: () -> Void

  var body: some View {
    HStack {
      Button(action: { onTap() }, label: {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(.accentColor)

        Text("New Task")
          .font(.headline)
      })
      .padding(.top)
      Spacer()
    }
    .background(.white)
  }
}

#Preview {
  NewTaskButton {}
}
