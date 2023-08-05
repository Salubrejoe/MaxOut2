
import SwiftUI

struct AppNavBar: View {
  var body: some View {
    NavContainer {
      ZStack {
//        Color.systemBackground
        
        NavigationLink {
          Text("Destination")
        } label: {
          Text("Navigate")
        }
      }
    }
  }
}

extension AppNavBar {
  
  @ViewBuilder
  private var defaultNavBar: some View {
    NavigationView {
      ZStack {
        Color.purple.ignoresSafeArea()
        
        NavigationLink {
          Text("Destination")
        } label: {
          Text("Navigate")
        }
      }
      .navigationTitle("Title")
    }
  }
}

struct AppNavBar_Previews: PreviewProvider {
  static var previews: some View {
    AppNavBar()
  }
}
