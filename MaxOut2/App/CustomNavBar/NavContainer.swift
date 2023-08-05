
import SwiftUI

struct NavContainer<Content: View>: View {
  
  let content: Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  var body: some View {
    VStack(spacing: 0) {
      NavBar()
      
      content
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
  }
}

struct NavContainer_Previews: PreviewProvider {
  static var previews: some View {
    NavContainer() {}
  }
}
