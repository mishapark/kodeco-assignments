//
//  ContentView.swift
//  Color Picker
//
//  Created by Mikhail Pak on 2023-08-30.
//

import SwiftUI

struct ContentView: View {
  @State private var redSliderValue: Double
  @State private var greenSliderValue: Double
  @State private var blueSliderValue: Double
  @State private var color: Color

  init(redSliderValue: Double = 0.0, greenSliderValue: Double = 255.0, blueSliderValue: Double = 0.0, color: Color = .white) {
    self.redSliderValue = redSliderValue
    self.greenSliderValue = greenSliderValue
    self.blueSliderValue = blueSliderValue
    self.color = Color(red: redSliderValue, green: greenSliderValue, blue: blueSliderValue)
  }

  var body: some View {
    VStack {
      Text("Color Picker")
        .font(.title)
      RoundedRectangle(cornerRadius: 0)
        .aspectRatio(contentMode: .fit)
        .foregroundColor(color)
      Text("Red")
      HStack {
        Slider(value: $redSliderValue, in: 0.0 ... 255.0)
        Text("\(Int(redSliderValue.rounded()))")
      }
      Text("Green")
      HStack {
        Slider(value: $greenSliderValue, in: 0.0 ... 255.0)
        Text("\(Int(greenSliderValue.rounded()))")
      }
      Text("Blue")
      HStack {
        Slider(value: $blueSliderValue, in: 0.0 ... 255.0)
        Text("\(Int(blueSliderValue.rounded()))")
      }
      Button("Set Color") {
        color = Color(
          red: redSliderValue / 255,
          green: greenSliderValue / 255,
          blue: blueSliderValue / 255
        )
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
