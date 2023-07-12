
import SwiftUI

struct StartPageView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @ObservedObject var model: StartViewModel
  @Binding var showingLoginView: Bool
  
  var body: some View {
    ZStack(alignment: .topTrailing) {
      ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 500) {
        startButton
          .padding(.vertical)
      } header: {
        header(user: model.fitUser)
      }
      settings
    }
  }
}

extension StartPageView {
  
  // MARK: - HEADER
  private func header(user: FitUser) -> some View {
    VStack {
      if let photoUrl = user.photoUrl {
        AsyncImage(url: URL(string: photoUrl))
          .frame(width: 50, height: 50)
          .cornerRadius(12)
      }
      Text("🏚️ Hi, \(model.fitUser.username ?? "Pizza Guy!")")
        .font(.largeTitle.bold())
    }
  }
  
  @ViewBuilder // MARK: - START BUTTON
  private var startButton: some View {
    LargeTsButton(text: "Start a new workout", buttonColor: .accentColor, textColor: .systemBackground) {
      model.startRoutine()
      model.viewState = .inProgress
    }
  }
  
  @ViewBuilder // MARK: - SETTINGS
  private var settings: some View {
    NavigationLink {
      SettingsView(showingLoginView: $showingLoginView, fitUser: $model.fitUser)
    } label: {
      Image(systemName: "gearshape")
    }
  }
}
