import SwiftUI
import Combine

final class SessionViewModel: ObservableObject {
  /// Swipe action
  @Published var open = PassthroughSubject<Void, Never>()
  
  var equipment: String? = nil
  
  var isAllCompletedChekmarkFilled = true
  
  let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
  
  func toggleIsComplete(_ session: inout Session, index: Int) {
    if !isAllCompletedChekmarkFilled {
      session.bobs[index].isCompleted = true
      impactFeedback.impactOccurred()
    }
    else {
      session.bobs[index].isCompleted = false
    }
  }
  
  func equipment(for session: Session) async throws {
    let uId = try FireAuthManager.shared.currentAuthenticatedUser().uid
    let exercise = try await ExercisesManager.shared.exerciseDocument(exerciseId: session.exerciseId, userId: uId).getDocument(as: Exercise.self)
    self.equipment = exercise.equipment
  }
}
