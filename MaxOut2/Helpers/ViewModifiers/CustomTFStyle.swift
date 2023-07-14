import Combine
import SwiftUI

struct NumberOnlyViewModifier: ViewModifier {
  @Binding var text: String
  var includeDecimal: Bool
  
  func body(content: Content) -> some View {
    content
      .keyboardType(includeDecimal ? .decimalPad : .numberPad)
      .onReceive(Just(text)) { newValue in
        var numbers = "0123456789"
        let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
        if includeDecimal { numbers += decimalSeparator }
        if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
          let filteredString = newValue
          self.text = String(filteredString.dropLast())
        }
        else {
          let filtered = newValue.filter { numbers.contains($0) }
          if filtered != newValue { self.text = filtered }
        }
      }
  }
}

extension View {
  func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = true) -> some View {
    self.modifier(NumberOnlyViewModifier(text: text, includeDecimal: includeDecimal))
  }
  
  func customTextFieldStyle() -> some View {
    self
      .bold()
      .foregroundColor(.primary)
      .keyboardType(.decimalPad)
      .textFieldStyle( GradientTextFieldBackground() )
      .multilineTextAlignment(.center)
  }
}

struct GradientTextFieldBackground: TextFieldStyle {
  
  func _body(configuration: TextField<Self._Label>) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8.0)
        .foregroundStyle(.ultraThinMaterial
          .shadow(.inner(color: .primary.opacity(0.5),
                         radius: 2))
        )
      configuration
    }
    .frame(width: 60)
    .frame(height: 27)
  }
}

