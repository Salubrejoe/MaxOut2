import SwiftUI

// MARK: - .cellStyle()
extension View {
  func cellStyle() -> some View {
    self
      .multilineTextAlignment(.leading)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 10)
      .padding(.horizontal, 10)
      .background(.ultraThinMaterial)
      .cornerRadius(10)
  }
}
