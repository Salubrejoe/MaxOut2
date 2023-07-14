import SwiftUI
import Combine
import SwipeActions



struct BobView: View {
  @ObservedObject var model: SessionViewModel
  @Binding var session: Session
  let index: Int
  
  var body: some View {
    SwipeView {
      
      bobo
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
    
//    .fontDesign(.rounded)
    .background(session.bobs[index].isCompleted ? Color(.systemGreen).opacity(0.3) : .clear)
    .animation(.default, value: session.bobs)
  }
  
  @ViewBuilder // MARK: - BOB
  private var bobo: some View {
    HStack {
      if session.category == "cardio" { cardioBob }
      else if session.category == "stretching" { stretchingBob }
      else { strenghtBob }
    }
    .frame(height: 27)
  }
} 

// MARK: - CARDIO
extension BobView {
  
  @ViewBuilder
  private var cardioBob: some View {
    Text("\(index + 1)")
      .bold()
      .foregroundColor(.secondary)
      .padding(.leading)
    Spacer()
    Text("km")
    TextField("", value: $session.bobs[index].distance, formatter: NumberFormatter.decimalWithoutDecimals)
      .customTextFieldStyle()
    Text(" × ")
    TextField("", value: $session.bobs[index].duration, formatter: DurationFormatter())
      .customTextFieldStyle()
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
}


// MARK: - STRETCHING
extension BobView {
  @ViewBuilder
  private var stretchingBob: some View {
    TextField("", value: $session.bobs[index].duration, formatter: DurationFormatter())
      .customTextFieldStyle()
    Text("min")
  }
}


// MARK: - STRENGHT
extension BobView {
  
  @ViewBuilder
  private var strenghtBob: some View {
    Group {
      GeometryReader { proxy in
        let width = proxy.size.width
        HStack {
          Text("\(index + 1)")
            .bold()
            .foregroundColor(.secondary)
            .padding(.leading)
            .frame(width: width * 0.1)
          
          if let equipment = model.equipment {
            Text(equipment).padding(.bottom, 3).foregroundColor(.secondary)
              .frame(width: width * 0.35)
          }
          
          HStack {
            TextField("0", value: $session.bobs[index].kg, formatter: NumberFormatter.decimalWithoutDecimals)
              .customTextFieldStyle()
            
            TextField("0", value: $session.bobs[index].reps, formatter: NumberFormatter.decimalWithoutDecimals)
              .customTextFieldStyle()
          }
          .frame(width: width * 0.4)
          Button {
            self.session.bobs[index].isCompleted.toggle()
          } label: {
            Image(systemName: "checkmark")
              .padding(.trailing)
              .foregroundColor(session.bobs[index].isCompleted ? .green : .secondary)
          }
          .frame(width: width * 0.10)
        }

      }
    }
    .font(.subheadline)
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
