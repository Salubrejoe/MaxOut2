
import SwiftUI

struct SignInWithAppleButton: View {
  @Environment(\.colorScheme) var colorScheme
  let action: () -> ()
  var body: some View {
    Button {
      action()
    } label: { appleLabel.allowsHitTesting(false) }
      .frame(maxWidth: 432)
      .frame(height: 46)
      .cornerRadius(10)
  }
  /// Apple Label
  @ViewBuilder
  private var appleLabel: some View {
    if colorScheme == .light {
      SignInWithAppleButtonViewRepresentable(type: .default, style: .black)
    } else if colorScheme == .dark {
      SignInWithAppleButtonViewRepresentable(type: .default, style: .white)
    }
  }
}
