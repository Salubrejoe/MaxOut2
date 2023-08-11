import SwiftUI

struct StringInputView: View {
  @Binding var value: String
  @Binding var isAnimating: Bool
  @Binding var isCompleted: Bool
  @ObservedObject var controller: BobTextFieldController

  @State private var hasDecimalPoint = false
  
  var body: some View {
    ZStack {
      Color(uiColor: UIColor.secondarySystemBackground).ignoresSafeArea()
      
      VStack {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          Button {
            value = "0"
          } label: {
            Image(systemName: "xmark.circle.fill")
              .imageScale(.large)
              .symbolRenderingMode(.hierarchical)
              .foregroundColor(.secondary)
          }
          Spacer()
          
          Text(value)
            .font(.largeTitle)
            .foregroundColor(value == "0" ? .secondary : .primary)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.leading, 20)
            .padding(.top, 20)
          
          RoundedRectangle(cornerRadius: 5)
            .frame(width: 2, height: 25)
            .scaleEffect(isAnimating ? 1.2 : 0.9)
            .opacity(isAnimating ? 0.4 : 0)
            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)
          
        }
        .padding()
        
        HStack {
          numericPad
          VStack {
            steppo("1")
            steppo("5")
            steppo("10")
            doneButton
          }
        }
      }
      .padding()
    }
  }
  
  @ViewBuilder
  private var numericPad: some View {
    HStack {
      VStack {
        numberKey("1")
        numberKey("4")
        numberKey("7")
        dot
      }
      VStack {
        numberKey("2")
        numberKey("5")
        numberKey("8")
        numberKey("0")
      }
      VStack {
        numberKey("3")
        numberKey("6")
        numberKey("9")
        deleteBackwardKey
      }
    }
    .frame(width: 200, height: 200)
  }
  
  @ViewBuilder
  private var doneButton: some View {
    Button {
      controller.isShowingInputView = false
    } label: {
      Text("Done")
        .frameForInputKeys
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(10)
    }
  }
  
  @ViewBuilder
  private func numberKey(_ number: String) -> some View {
    Button {
      handleDigitInput(number)
    } label: {
      Text("\(number)")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }
  
  @ViewBuilder
  private var deleteBackwardKey: some View {
    Button {
      value = String(value.dropLast())
    } label: {
      Image(systemName: "delete.backward")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }
  
  @ViewBuilder
  private var dot: some View {
    Button {
      handleDecimalPoint()
    } label: {
      Text(".")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }
  
  @ViewBuilder // MARK: - STEPPO
  private func steppo(_ number: String) -> some View {
    HStack {
      Button {
        handleStepperInput("-\(number)")
      } label: {
        Text("-\(number)")
          .frame(maxWidth: .infinity, alignment: .center)
      }
      
      Divider()
        .padding(.vertical, 5)
      
      Button {
        handleStepperInput(number)
      } label: {
        Text("+\(number)")
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .frameForInputKeys
    .foregroundColor(.primary)
    .background(.ultraThinMaterial)
    .cornerRadius(10)
  }
  
  private func handleStepperInput(_ number: String) {
    let components = value.components(separatedBy: ".")
    guard let firstChar = number.first else { return }
    let valueInt = Int(components[0]) ?? 0
    let numberInt = Int(number) ?? 0
    let result = valueInt + numberInt
    if components.count > 1 {
      value = "\(result).\(components[1])"
    }
    else {
      value = "\(result)"
    }
  }
  
  private func handleDigitInput(_ digit: String) {
    if value == "0" {
      value = digit
    } else {
      value += digit
    }
  }
  
  private func handleDecimalPoint() {
    if !hasDecimalPoint {
      value += "."
      hasDecimalPoint = true
    }
  }
  
  private func hasDecimal() -> Bool {
    let components = value.components(separatedBy: ".")
    if components.count == 1 { return false }
    else { return true}
  }
}

struct StringInputView_Previews: PreviewProvider {
  static var previews: some View {
    StringInputView(value: .constant("12"), isAnimating: .constant(true), isCompleted: .constant(false), controller: BobTextFieldController())
  }
}
