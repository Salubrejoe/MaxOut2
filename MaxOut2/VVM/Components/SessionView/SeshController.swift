import SwiftUI
import Combine

final class SeshController: ObservableObject {
  let gaugeController = GaugeViewController()
  
  @Published var open = PassthroughSubject<Void, Never>()
  
  var isAllCompletedChekmarkFilled = true
  
  let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
}
