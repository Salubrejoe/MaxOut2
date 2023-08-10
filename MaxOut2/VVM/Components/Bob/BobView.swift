import SwiftUI
import Combine
import SwipeActions



struct BobView: View {
  @ObservedObject var controller: SeshController
  @Binding var bob: Bob
  @Binding var session: Session
  
  @State var hh = 0
  @State var mm = 0
  @State var ss = 0
  @State var kg = 0.0
  @State var reps = 0.0
  
  var body: some View {
    
    SwipeView {
      HStack {
        if session.activityType == .highIntensityIntervalTraining ||
            session.activityType == .traditionalStrengthTraining ||
            session.activityType == .coreTraining {
          
          strengthBob()
        }
        else if session.activityType == .flexibility { stretchingBob() }
        else { cardioBob() }
        
      }
      .frame(maxWidth: .infinity)
      .foregroundStyle(bob.isCompleted ? .secondary : .primary)
      
    } leadingActions: { context in
//      removeBobSwipeAction(context)
      allCompletedSwipeAction(context)
    } trailingActions: { context in
//      allCompletedSwipeAction(context)
      removeBobSwipeAction(context)
    }
    .swipeActionsStyle(.mask)
    .swipeMinimumPointToTrigger(100)
    .swipeActionCornerRadius(10)
    .swipeActionsMaskCornerRadius(10)
    .swipeActionContentTriggerAnimation(.easeInOut)
    
  }
}

extension BobView {
  // MARK: - LEADING SWIPE
  func removeBobSwipeAction(_ context: SwipeContext) -> some View {
    SwipeAction(systemImage: "trash") {
      withAnimation {
        guard let index = session.bobs.firstIndex(of: bob) else { return }
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
  func allCompletedSwipeAction(_ context: SwipeContext) -> some View {
    SwipeAction(systemImage: "checkmark") {
      self.bob.isCompleted.toggle()
      context.state.wrappedValue = .closed
    }
    .allowSwipeToTrigger()
    
    .background(Color.green)
    .foregroundColor(.white)
    .onReceive(controller.open) {
      context.state.wrappedValue = .expanded
      bob.isCompleted.toggle()
      if let index = session.bobs.firstIndex(of: bob) {
        var increment = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(increment)) {
          context.state.wrappedValue = .closed
          increment += 1
        }
      }
    }
  }
}
