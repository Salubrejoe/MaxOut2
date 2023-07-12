import SwiftUI

extension View {
  @ViewBuilder
  func buttonLabel(background: Color, foreground: Color) -> some View {
    self
      .font(.system(size: 18))
      .fontWeight(.semibold)
      .foregroundColor(foreground)
      .frame(maxWidth: 432)
      .frame(height: 46)
      .background(background)
      .cornerRadius(10)
  }
}
