import SwiftUI
import BottomSheet

struct StartContainer: View {
  @EnvironmentObject var model: StartViewModel
  
  var body: some View {
        VStack {
          StartPageView()
            .if(model.inProgress) { content in
              content
                .bottomSheet(bottomSheetPosition: $model.position, switchablePositions: model.switchablePositions) {
                  InProgressHeader()
                    .environmentObject(model)
                } mainContent: {
                  SessionsGrid()
                    .environmentObject(model)
                }
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

extension View {
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, content: (Self) -> Content) -> some View {
    if condition {
      content(self)
    } else {
      self
    }
  }
}
