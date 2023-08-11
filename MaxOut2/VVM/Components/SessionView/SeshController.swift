import SwiftUI
import Combine

final class SeshController: ObservableObject {
  let gaugeController = GaugeViewController()
  
  @Published var open = PassthroughSubject<Void, Never>()
  
  let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
  
  // MARK: - MARK COMPLETED
  func markAsCompleted(_ session: inout Session) {
    for index in session.bobs.indices {
      session.bobs[index].isCompleted = true
    }
  }
  
  func isCompleted(_ session: Session) -> Bool {
    for bob in session.bobs {
      if !bob.isCompleted { return false }
    }
    return true
  }
  
  func newBobTapped(for session: inout Session) {
    if let lastBob = session.bobs.last {
      let bob = Bob(bob: lastBob)
      withAnimation(.easeIn) {
        session.bobs.append(bob)
      }
    } else {
      withAnimation(.easeIn) {
        session.bobs.append(Bob())
      }
    }
  }
}
