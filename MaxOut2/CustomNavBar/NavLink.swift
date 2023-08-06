import SwiftUI

struct NavLink<Label: View, Destination: View>: View {
  
  let label: Label
  let destination: Destination
  
  init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
    self.label = label()
    self.destination = destination()
  }
  
  var body: some View {
    NavigationLink {
      NavView {
        destination
          .toolbar(.hidden, for: .automatic)
      }
    } label: {
      label
    }

  }
}

struct NavLink_Previews: PreviewProvider {
  static var previews: some View {
    NavView {
      NavLink {
        Text("destination")
      } label: {
        Text("label")
      }
    }
  }
}
