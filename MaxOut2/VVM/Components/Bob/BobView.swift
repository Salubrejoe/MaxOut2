import SwiftUI
import Combine
import SwipeActions



struct BobView: View {
  @ObservedObject var controller: SeshController
  @Binding var bob: Bob
  @Binding var session: Session
  
  var body: some View {
    SwipeView {
      
      HStack {
        if session.category == "cardio" { cardioBob() }
        else if session.category == "stretching" { stretchingBob() }
        else { strengthBob() } /// else
      }
      .frame(maxWidth: .infinity)
      .foregroundColor(.primary)
      
    } leadingActions: { context in
      removeBobSwipeAction(context)
    } trailingActions: { context in
      allCompletedSwipeAction(context)
    }
    
    .swipeActionsStyle(.mask)
    .swipeMinimumPointToTrigger(100)
    .swipeActionCornerRadius(10)
    .swipeActionsMaskCornerRadius(10)
    
    .background(bob.isCompleted ? Color(.systemGreen).opacity(0.3) : .clear)
  }
}
