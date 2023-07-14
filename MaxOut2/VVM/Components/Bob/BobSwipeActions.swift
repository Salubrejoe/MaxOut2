import SwiftUI
import SwipeActions

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
    
    .background(Color.accentColor)
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
