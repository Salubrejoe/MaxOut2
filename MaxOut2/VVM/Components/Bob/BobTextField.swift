import SwiftUI

final class BobTextFieldController: ObservableObject {
  @Published var isShowingInputView = false
  
  func add(_ number: Int, to total: Double) -> Double {
    total*10 + Double(number)
  }
}

struct BobKgRepsTextField: View {
  @StateObject private var controller = BobTextFieldController()
  
  @Binding var value: Double
  
  @Binding var isCompleted: Bool
  @State private var isAnimating = false
  
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
          inputView
            .font(.title3)
            .presentationDetents([.fraction(0.38)])
            .onAppear {
              isAnimating = true
            }
        }
    }
    .fontWeight(.semibold)
  }
  
  @ViewBuilder // MARK: - LABEL
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


// MARK: - INPUT VIEW
extension BobKgRepsTextField {
  @ViewBuilder
  private var inputView: some View {
    ZStack {
      Color(uiColor: UIColor.secondarySystemBackground).ignoresSafeArea()
      
      VStack {
        HStack(alignment: .firstTextBaseline, spacing: 0) {
          
          Text(String(format: "%.0f", value))
            .font(.largeTitle)
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
            steppo(1)
            steppo(5)
            steppo(10)
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
        numberKey(1)
        numberKey(4)
        numberKey(7)
        resetKey
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
  private func numberKey(_ number: Int) -> some View {
    Button {
      value = controller.add(number, to: value)
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
  
  @ViewBuilder
  private var resetKey: some View {
    Button {
      value = 0
    } label: {
      Image(systemName: "arrow.counterclockwise")
        .frameForInputKeys
        .foregroundColor(.primary)
    }
  }
}

extension BobKgRepsTextField {
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

struct BobTextField_Previews: PreviewProvider {
  static var previews: some View {
    BobKgRepsTextField(value: .constant(12), isCompleted: .constant(true))
  }
}


extension View {
  var frameForInputKeys: some View {
    frame(maxWidth: .infinity, maxHeight: 35)
  }
}
