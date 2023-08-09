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
  
  var body: some View {
    
    //    TimeTextField(text: $bob.duration)
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
      .foregroundColor(.primary)
      .background(bob.isCompleted ? Color(.systemGreen).opacity(0.3) : .clear)
      
    } leadingActions: { context in
      removeBobSwipeAction(context)
    } trailingActions: { context in
      allCompletedSwipeAction(context)
    }
    .swipeActionsStyle(.mask)
    .swipeMinimumPointToTrigger(100)
    .swipeActionCornerRadius(10)
    .swipeActionsMaskCornerRadius(10)
    .swipeActionContentTriggerAnimation(.easeInOut)
    
  }
}
