import SwiftUI

extension View {
  func loginAnimation(_ condition: Bool) -> some View {
    self
      .disabled(condition)
//    .scaleEffect(condition ? 0.7 : 1)
    .blur(radius: condition ? 7 : 0)
    .opacity(condition ? 0 : 1)
    .animation(.spring().speed(0.5), value: condition)
  }
}
