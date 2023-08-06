
import SwiftUI

struct AppNavBar: View {
  var body: some View {
    NavView {
      VStack {
        Text("Pizza")

        NavLink {
          Text("destination")
            .navBarItems("Porca", subtitle: "Vacchissima", backButtonHidden: false)
        } label: {
          Text("label")
        }

      }
      .navBarItems("Porca", subtitle: "Vacchissima", backButtonHidden: true)
    }
  }
}

struct AppNavBar_Previews: PreviewProvider {
  static var previews: some View {
    AppNavBar()
  }
}
