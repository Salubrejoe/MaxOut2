
import SwiftUI

struct NavView<Content: View>: View {
  
  let content: Content
  
  init(@ViewBuilder content: @escaping () -> Content) {
    self.content = content()
  }
  
  @State private var showingBackButton = true
  @State private var title = ""
  @State private var subtitle: String? = nil
  
  var body: some View {
    NavigationStack {
      container
    }
  }
  
  @ViewBuilder // MARK: - CONTAINER
  private var container: some View {
    VStack(spacing: 0) {
      NavBar(showingBackButton: showingBackButton, title: title, subtitle: subtitle)
      
      content
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
    
    .toolbar(.hidden, for: .automatic)
    
    .onPreferenceChange(NavBarTitlePK.self) { title in
      self.title = title
    }
    .onPreferenceChange(NavBarSubtitlePK.self) { subtitle in
      self.subtitle = subtitle
    }
    .onPreferenceChange(NavBarBackButtonHiddenPK.self) { hidden in
      self.showingBackButton = !hidden
    }
  }
}

struct NavContainer_Previews: PreviewProvider {
  static var previews: some View {
    NavView {
      Text("Pizza Margherita")
        .navTitle("Burrata")
        .navBarBackButtonHidden(true)
    }
  }
}
