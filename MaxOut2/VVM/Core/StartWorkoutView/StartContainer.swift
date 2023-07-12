import SwiftUI

struct StartContainer: View {
  @StateObject var model = StartViewModel()
  @Binding var showingLoginView: Bool
  
  var body: some View {
        VStack {
          if model.viewState == .startButton {
            StartPageView(model: model, showingLoginView: $showingLoginView)
          }
          else {
            NewInProgressView(model: model)
          }
        }
        .task { try? await model.loadCurrentUser() }
        .animation(.spring(), value: model.viewState)
  }
}

extension StartContainer {
  @ToolbarContentBuilder // MARK: - RESIGN KEYBOARD
  private var toolbar: some ToolbarContent {
    ToolbarItem(placement: .keyboard) {
      ResignKeyboardButton()
      Spacer()
    }
  }
}
