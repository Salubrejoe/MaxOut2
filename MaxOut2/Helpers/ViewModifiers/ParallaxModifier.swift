import SwiftUI
import CoreMotion


struct ParallaxModifier: ViewModifier {
  @ObservedObject var manager: MotionManager
  var magnitude: Double
  
  func body(content: Content) -> some View {
    content
      .offset(x: CGFloat(manager.roll * magnitude), y: CGFloat(manager.pitch * magnitude))
      .shadow(radius: 5, x: -manager.roll, y: -manager.pitch)
  }
}

//extension View {
//  func parallax(manager: MotionManager, magnitude: Double) -> some View {
//    self.modifier(ParallaxModifier(manager: manager, magnitude: magnitude))
//  }
//}


class MotionManager: ObservableObject {
  @Published var pitch: Double = 0.0
  @Published var roll: Double = 0.0
  
  
  var manager: CMMotionManager
  
  init() {
    self.manager = CMMotionManager()
    self.manager.deviceMotionUpdateInterval = 1/20
    self.manager.startDeviceMotionUpdates(to: .main) { motion, error in
      guard error == nil else {
        print("Error starting MotionUpdates: \(String(describing: error))")
        return
      }
      
      if let motionData = motion {
        self.roll = motionData.attitude.roll
        self.pitch = motionData.attitude.pitch
        
      }
    }
  }
}
