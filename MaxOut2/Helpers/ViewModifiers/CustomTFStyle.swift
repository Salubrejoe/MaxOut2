

import SwiftUI

extension View {
  func customTextFieldStyle(text: String, parameter: Binding<Double>) -> some View {
    self
      .bold()
      .foregroundColor(.primary)
      .keyboardType(.decimalPad)
      .textFieldStyle( GradientTextFieldBackground(text: text, parameter: parameter) )
      .multilineTextAlignment(.center)
      .frame(width: 60)
      .frame(height: 27)
  }
}

struct GradientTextFieldBackground: TextFieldStyle {
  let text: String
  @Binding var parameter: Double
  
  func _body(configuration: TextField<Self._Label>) -> some View {
      textField(configuration)
    }
  
  @ViewBuilder
  private func textField(_ configuration: TextField<Self._Label>) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8.0)
        .foregroundStyle(.ultraThickMaterial.shadow(.inner(color: .primary.opacity(0.3), radius: 1.5)))
      
      configuration
    }
    .frame(width: 60)
  }
}

