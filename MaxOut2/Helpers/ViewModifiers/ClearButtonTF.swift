import SwiftUI

struct ClearButtonViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .onAppear {
        UITextField.appearance().clearButtonMode = .whileEditing
      }
  }
}

extension View {
  @ViewBuilder
  var textFieldClearButton: some View {
    self.modifier(ClearButtonViewModifier())
  }
}
