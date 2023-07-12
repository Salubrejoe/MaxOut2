
import SwiftUI

struct StartPageView: View {
  @ObservedObject var model: StartViewModel
  
  @Binding var showingLoginView: Bool
  
  var body: some View {
    NavigationStack {
      VStack {
        header(user: model.fitUser)
          .padding(.vertical, 40)
        startButton
      }
      .navigationTitle("🏚️ Hi, \(model.fitUser.username ?? "Pizza Guy!")")
      .toolbar { settings }
    }
  }
}

extension StartPageView {
  
  // MARK: - HEADER
  private func header(user: FitUser) -> some View {
    HStack {
      if let photoUrl = user.photoUrl {
        AsyncImage(url: URL(string: photoUrl))
          .frame(width: 50, height: 50)
          .cornerRadius(12)
      }
    }
  }
  
  @ViewBuilder // MARK: - START BUTTON
  private var startButton: some View {
    LargeTsButton(text: "Start a new workout", buttonColor: .accentColor, textColor: .systemBackground) {
      model.startRoutine()
      model.viewState = .inProgress
    }
  }
  
  @ToolbarContentBuilder // MARK: - SETTINGS
  private var settings: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      NavigationLink {
        SettingsView(showingLoginView: $showingLoginView, fitUser: $model.fitUser)
      } label: {
        Image(systemName: "gearshape")
      }
    }
  }
}
