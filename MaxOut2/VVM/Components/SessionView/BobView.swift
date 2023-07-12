import SwiftUI
import Combine
import SwipeActions



struct BobView: View {
  @ObservedObject var model: SessionViewModel
  @Binding var session: Session
//  @Binding var isShowingKeyboard: Bool

  
  let index: Int
  
  
  var body: some View {
    
    SwipeView {
      
      bobo
        .resignKeyboardOnDragGesture()
        .frame(maxWidth: .infinity)
        .padding(.vertical, 6)
        .foregroundColor(.primary)
      
    } leadingActions: { context in
      removeBobSwipeAction(context, index: index)
    } trailingActions: { context in
      allCompletedSwipeAction(context, index: index)
    }
    
    .swipeActionsStyle(.mask)
    .swipeMinimumPointToTrigger(100)
    .swipeActionCornerRadius(10)
    .swipeActionsMaskCornerRadius(10)
    
    .fontDesign(.rounded)
    .background(session.bobs[index].isCompleted ? Color(.systemGreen).opacity(0.3) : .clear)
    .animation(.default, value: session.bobs)
  }
  
  @ViewBuilder // MARK: - BOB
  private var bobo: some View {
    HStack {
      if session.category == "cardio" {
        Text("\(index + 1)")
          .bold()
          .foregroundColor(.secondary)
          .padding(.leading)
        Spacer()
        Text("km")
        TextField("", value: $session.bobs[index].distance, formatter: NumberFormatter.decimalWithoutDecimals)
          .customTextFieldStyle(text: "km", parameter: $session.bobs[index].distance)
        Text(" × ")
        TextField("", value: $session.bobs[index].duration, formatter: DurationFormatter())
          .customTextFieldStyle(text: "min", parameter: $session.bobs[index].duration)
        Text("min")
        Spacer()
        Button {
          self.session.bobs[index].isCompleted.toggle()
          
        } label: {
          Image(systemName: "checkmark")
            .padding(.trailing)
            .foregroundColor(session.bobs[index].isCompleted ? .green : .secondary)
        }
      }
      
      else if session.category == "stretching" {
        
        TextField("", value: $session.bobs[index].duration, formatter: DurationFormatter())
          .customTextFieldStyle(text: "min", parameter: $session.bobs[index].duration)
        Text("min")
          
      }
      else {
        Group {
          Text("\(index + 1)")
            .bold()
            .foregroundColor(.secondary)
            .padding(.leading)
          Spacer()
          Text("kg")
          TextField("", value: $session.bobs[index].kg, formatter: NumberFormatter.decimalWithoutDecimals)
            .customTextFieldStyle(text: "kg", parameter: $session.bobs[index].kg)
          Text(" × ")
          TextField("", value: $session.bobs[index].reps, formatter: NumberFormatter.decimalWithoutDecimals)
            .customTextFieldStyle(text: "reps", parameter: $session.bobs[index].reps)
          Text("reps")
          Spacer()
          Button {
            self.session.bobs[index].isCompleted.toggle()
          } label: {
            Image(systemName: "checkmark")
              .padding(.trailing)
              .foregroundColor(session.bobs[index].isCompleted ? .green : .secondary)
          }

        }
        .font(.subheadline)
      }
    }
  }
}


// MARK: - Swipe Actions
extension BobView {
  
  
  // MARK: - LEADING SWIPE
  private func removeBobSwipeAction(_ context: SwipeContext, index: Int) -> some View {
    SwipeAction(systemImage: "trash") {
      withAnimation {
        self.session.bobs.remove(at: index)
      }
      context.state.wrappedValue = .closed
    }
    .allowSwipeToTrigger()
    .bold()
    .background(.red)
    .foregroundColor(.white)
  }
  
  // MARK: - TRAILING SWIPE
  private func allCompletedSwipeAction(_ context: SwipeContext, index: Int) -> some View {
    SwipeAction(systemImage: "checkmark") {
      self.session.bobs[index].isCompleted.toggle()
      context.state.wrappedValue = .closed
    }
    .allowSwipeToTrigger()
    
    .background(Color.accentColor)
    .foregroundColor(.white)
    .onReceive(model.open) {
      context.state.wrappedValue = .expanded
      model.toggleIsComplete(&session, index: index)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(index)) {
        context.state.wrappedValue = .closed
      }
    }
  }
}



extension NumberFormatter {
  static let decimalWithoutDecimals: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 0
    return formatter
  }()
}
