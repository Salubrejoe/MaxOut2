
import SwiftUI

// MARK: - .onFirstAppear Modifier
struct OnFirstAppear: ViewModifier {
  @State private var firstAppear = true
  let perform: (() -> Void)?
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        if firstAppear {
          perform?()
          firstAppear = false
        }
      }
  }
}

extension View {
  func onFirstAppear(perform: (() -> Void)?) -> some View {
    modifier(OnFirstAppear(perform: perform))
  }
}
