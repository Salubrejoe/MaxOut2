import SwiftUI
import Combine

struct KmTF: View {
  @StateObject private var controller = BobTextFieldController()
  @Binding var distance: String
  @Binding var isCompleted: Bool
  @State private var isAnimating: Bool = false
  
  
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
          StringInputView(value: $distance, isAnimating: $isAnimating, isCompleted: $isCompleted, controller: controller)
            .presentationDetents([.fraction(0.4)])
            .onAppear {
              isAnimating = true
            }
        }
    }
    .fontWeight(.semibold)
  }
  
  @ViewBuilder
  private var labelButton: some View {
    Button {
      controller.isShowingInputView.toggle()
    } label: {
      Text(distance)
        .foregroundColor(isCompleted ? .green : .primary)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  @ViewBuilder
  private var inputView: some View {
    HStack {
      Text(distance)
        .onReceive(Just(distance)) { newValue in
          var numbers = "0123456789"
          let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
          numbers += decimalSeparator
          if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
            let filteredString = newValue
            self.distance = String(filteredString.dropLast())
          }
          else {
            let filtered = newValue.filter { numbers.contains($0) }
            if filtered != newValue { self.distance = filtered }
          }
        }
      Text("km")
    }
  }
}


// MARK: - Preview
struct KmTF_Previews: PreviewProvider {
  static var previews: some View {
    KmTF(distance: .constant("0"), isCompleted: .constant(false))
  }
}
