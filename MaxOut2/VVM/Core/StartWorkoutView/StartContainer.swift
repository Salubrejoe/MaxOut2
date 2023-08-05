import SwiftUI
import BottomSheet

struct StartContainer: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarState: BarState
  
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 500) {
        LargeTsButton(text: "Start a new workout", background: Color.accentColor, textColor: .systemBackground) {
          model.startRoutine()
          model.inProgress = true
          tabBarState = .hidden
        }
        .disabled(model.inProgress)
        .padding(.vertical)
      } header: {
        Text("Buenos dias, \(model.fitUser.username ?? "Pizza Guy!")")
          .font(.largeTitle.bold())
      }
    }
    .task { try? await model.loadCurrentUser() }
  }
}
