//
//import SwiftUI
//import Combine
//
//@MainActor
//final class SessionViewModel: ObservableObject {
//  @Published var controller = GaugeViewController()
//  
//  /// Swipe action
//  @Published var open = PassthroughSubject<Void, Never>()
//  
//  /// Header buttons actions
//  @Published var showingInstructions = false
//  @Published var isAllCompletedChekmarkFilled = true
//  
//  @Published var automaticRestTimerIsOn = true
//  
//  var color: Color = .black
//  
//  func toggleIsComplete(_ session: inout Session, index: Int) {
//    if !isAllCompletedChekmarkFilled {
//      session.bobs[index].isCompleted = true
//    }
//    else {
//      session.bobs[index].isCompleted = false
//    }
//  }
//  
//  func getColor(_ session: Session)  {
//    Task {
//      do {
//        self.color = try await SessionsManager.shared.getColor(with: session)
//      }
//      catch {
//        print("Could not get color - SESSION VIEW MODEL")
//      }
//    }
//  }
//  
//}
