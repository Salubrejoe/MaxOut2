import SwiftUI

final class BobTextFieldController: ObservableObject {
  @Published var isShowingInputView = false
  
  func add(_ number: Double, to total: Double) -> Double {
    total*10 + number
  }
  
  func add(_ number: String, to total: String) -> String {
    guard let number = Double(number),
          let total = Double(total) else { return "0.0"}
    
    let result = add(number, to: total)
    return String(format: "%.2f", result)
  }
  
  func subtract(_ number: String, to total: String) -> String {
    guard let number = Double(number),
          let total = Double(total) else { return "0.0"}
    
    let result = add(-number, to: total)
    return String(format: "%.2f", result)
  }
}

struct BobKgRepsTextField: View {
  @StateObject private var controller = BobTextFieldController()
  
  @Binding var value: Double
  
  @Binding var isCompleted: Bool
  @State private var isAnimating = false
  
  let unit: String
  
  var body: some View {
    VStack {
      labelButton
        .minimumScaleFactor(0.5)
        .frame(height: 32)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(controller.isShowingInputView ? Color.accentColor.gradient : Color.clear.gradient, lineWidth: 2)
            .scaleEffect(0.8)
        }
        .scaleEffect(controller.isShowingInputView ? 1.2 : 1)
        .sheet(isPresented: $controller.isShowingInputView) {
          InputView(value: $value, isAnimating: $isAnimating, controller: controller, unit: unit)
            .presentationDetents([.fraction(0.38)])
        }
    }
    .fontWeight(.semibold)
  }
  
  @ViewBuilder
  private var labelButton: some View {
    Button {
      controller.isShowingInputView.toggle()
    } label: {
      Text(String(format: "%.0f", value))
        .foregroundColor(isCompleted ? .green : .primary)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}


struct BobTextField_Previews: PreviewProvider {
  static var previews: some View {
    BobKgRepsTextField(value: .constant(12), isCompleted: .constant(true), unit: "")
  }
}


extension View {
  var frameForInputKeys: some View {
    frame(maxWidth: .infinity, maxHeight: 35)
  }
}
