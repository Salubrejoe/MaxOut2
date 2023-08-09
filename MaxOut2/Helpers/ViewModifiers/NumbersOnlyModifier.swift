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

struct DurationViewModifier: ViewModifier {
  @Binding var text: String
  @FocusState var isInputActive: Bool
  
  func body(content: Content) -> some View {
    content
      .keyboardType(.numberPad)
      .focused($isInputActive)
      .onReceive(Just(text)) { newValue in
//        var numbers = "0123456789"
//        let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
//        if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
//          let filteredString = newValue
//          self.text = String(filteredString.dropLast())
//        }
//        else {
//          let filtered = newValue.filter { numbers.contains($0) }
//          if filtered != newValue { self.text = filtered }
//        }
//        
        let newValueTrimmed = removeColonsAndLeadingZeros(from: newValue)
        guard let newInt = Int(newValueTrimmed) else { return }

        if newInt < 10 {
          self.text = "00:0\(newInt)"
        }
        else if newInt < 100 {
          self.text = "00:\(newInt)"
        }
        else if newInt < 100000 {
          self.text = formatIntegerToTime(newInt)
        }
        else {
          return
        }
        
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          
          Button("Done") {
            let textTrimmed = removeColonsAndLeadingZeros(from: text)
            guard let integer = Int(textTrimmed) else { return }
            var seconds = integer % 100
            var minutes = Int(integer / 100)
            if seconds > 59 {
              seconds = seconds % 60
              minutes += 1
              self.text = String(format: "%02d:%02d", minutes, seconds)
            }
            isInputActive = false
          }
        }
      }
  }
  
  func formatIntegerToTime(_ integer: Int) -> String {
    let minutes = integer / 100
    let seconds = integer % 100
    return String(format: "%02d:%02d", minutes, seconds)
  }

  
  func removeColonsAndLeadingZeros(from timeString: String) -> String {
    // Remove colons
    let timeWithoutColons = timeString.replacingOccurrences(of: ":", with: "")
    
    // Remove leading zeros
    let trimmedTimeString = timeWithoutColons.trimmingCharacters(in: ["0"])
    
    return trimmedTimeString
  }
}

extension View {
  func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = true) -> some View {
    modifier(NumberOnlyViewModifier(text: text, includeDecimal: includeDecimal))
  }
  
  func durationFormatter(_ text: Binding<String>) -> some View {
    modifier(DurationViewModifier(text: text))
  }
  
  func bobTFStyle() -> some View {
    self
      .bold()
      .foregroundStyle(.primary.shadow(.inner(color: .primary.opacity(0.2), radius: 2, y: -1)))
      .textFieldStyle( GradientTextFieldBackground() )
      .multilineTextAlignment(.center)
  }
}

struct GradientTextFieldBackground: TextFieldStyle {
  
  func _body(configuration: TextField<Self._Label>) -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 8.0)
        .foregroundStyle(.ultraThinMaterial)
      configuration
    }
    .frame(width: 60)
    .frame(height: 37)
  }
}

