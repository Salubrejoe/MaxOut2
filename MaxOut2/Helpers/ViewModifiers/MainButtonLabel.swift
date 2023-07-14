import SwiftUI

extension View {
  @ViewBuilder
  func buttonLabel<Background: ShapeStyle>(background: Background, foreground: Color) -> some View {
    self
      .font(.system(size: 18))
      .fontWeight(.semibold)
      .foregroundColor(foreground)
      .frame(maxWidth: 428)
      .frame(height: 46)
      .background(background)
      .cornerRadius(14)
  }
}
