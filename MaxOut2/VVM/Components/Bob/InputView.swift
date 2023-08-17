import SwiftUI

struct InputView: View {
  @Binding var value: Double
  @Binding var isAnimating: Bool
  @ObservedObject var controller: BobTextFieldController
  let unit : String
  
  var body: some View {
    ZStack {
      Color(uiColor: UIColor.secondarySystemBackground).ignoresSafeArea()
      
      VStack {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          Button {
            value = 0
          } label: {
            Image(systemName: "delete.forward")
              .foregroundColor(.secondary)
          }
          Spacer()
          
          HStack(alignment: .firstTextBaseline, spacing: 0) {
            Text(String(format: "%.0f", value))
              .font(.largeTitle)
              .frame(maxWidth: .infinity, alignment: .trailing)
              .padding(.leading, 20)
              .padding(.top, 20)
            cursor
              .padding(.trailing, 3)
            Text(unit)
              .font(.title3)
              .foregroundColor(.secondary)
              .frame(alignment: .leading)
          }
        }
        .padding()
        
        HStack {
          numericPad
          VStack {
            steppo(1)
            steppo(5)
            steppo(10)
            doneButton
          }
        }
      }
      .padding()
    }
    .onAppear {
      isAnimating = false
      isAnimating = true
    }
  }
  
  @ViewBuilder
  private var cursor: some View {
    RoundedRectangle(cornerRadius: 5)
      .frame(width: 2, height: 25)
      .scaleEffect(isAnimating ? 1.1 : 0.9)
      .opacity(isAnimating ? 0.4 : 0)
      .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isAnimating)

  }
  
  @ViewBuilder
  private var numericPad: some View {
    HStack {
      VStack {
        numberKey(1)
        numberKey(4)
        numberKey(7)
        Text("")
          .frameForInputKeys
      }
      VStack {
        numberKey(2)
        numberKey(5)
        numberKey(8)
        numberKey(0)
      }
      VStack {
        numberKey(3)
        numberKey(6)
        numberKey(9)
        deleteBackwardKey
      }
    }
    .frame(width: 200, height: 220)
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
  private func numberKey(_ number: Int) -> some View {
    Button {
      value = controller.add(Double(number), to: value)
    } label: {
      Text("\(number)")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }
  
  @ViewBuilder
  private var deleteBackwardKey: some View {
    Button {
      let lastDigit = Int(value) % 10
      value -= Double(lastDigit)
      value = value/10
    } label: {
      Image(systemName: "delete.backward")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }

  
  @ViewBuilder // MARK: - STEPPO
  private func steppo(_ number: Int) -> some View {
    HStack {
      Button {
        value -= Double(number)
      } label: {
        Text("-\(number)")
          .frame(maxWidth: .infinity, alignment: .center)
      }
      
      Divider()
        .padding(.vertical, 5)
      
      Button {
        value += Double(number)
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
}

struct InputView_Previews: PreviewProvider {
  static var previews: some View {
    InputView(value: .constant(12), isAnimating: .constant(false), controller: BobTextFieldController(), unit: "kg")
  }
}
