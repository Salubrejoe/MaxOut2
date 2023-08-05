import SwiftUI

extension View {
  func threeWayPickerStyle() -> some View {
    self
      .frame(maxWidth: 428)
      .frame(height: 30)
      .padding(.horizontal, 6)
      .padding(.vertical, 6)
      .background(.regularMaterial)
      .cornerRadius(16)
      .shadow(radius: 3)
  }
}
