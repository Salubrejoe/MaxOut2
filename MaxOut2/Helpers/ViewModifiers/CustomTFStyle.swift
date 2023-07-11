

import SwiftUI

extension View {
  func customTextFieldStyle(text: String, parameter: Binding<Double>) -> some View {
    self
      .bold()
      .foregroundColor(.primary)
      .keyboardType(.decimalPad)
//      .textFieldStyle(.roundedBorder)
      .textFieldStyle( GradientTextFieldBackground(text: text, parameter: parameter) )
      .multilineTextAlignment(.center)
      .frame(width: 70)
      .frame(height: 33)
  }
}

struct GradientTextFieldBackground: TextFieldStyle {
  let text: String
  @Binding var parameter: Double
  
  func _body(configuration: TextField<Self._Label>) -> some View {
//    HStack(spacing: 4) {
//      Button { parameter -= 1 } label: {
//        Image(systemName: "minus")
//          .imageScale(.small)
//          .foregroundColor(.accentColor)
//          .contentShape(Rectangle())
//      }
      textField(configuration)
      

//      Button { parameter += 1 } label: {
//        Image(systemName: "plus")
//          .imageScale(.small)
//          .foregroundColor(.accentColor)
//
//      }
    }
  
  @ViewBuilder
  private func textField(_ configuration: TextField<Self._Label>) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 7.0)
        .fill(Color.secondarySytemBackground)
      
      configuration
    }
    .frame(width: 60)
  }
}

