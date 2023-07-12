
import SwiftUI

enum TsButtonStyle {
  case accent, secondary
}

struct SmallTsButton: View {
  let text: String
  let style: TsButtonStyle
  let action: () -> ()
  
  var body: some View {
    switch style {
      case .accent:
        Button(text) {
          action()
        }
        .tsButtonLabel(background: .accentColor, foreground: .white)
        
      case .secondary:
        Button(text) {
          action()
        }
        .tsButtonLabel(background: .cell, foreground: .primary)
    }
  }
}

// MARK: - Ts BUTTON Label
extension View {
  func tsButtonLabel(background: Color, foreground:  Color) -> some View {
    self
      .padding(.vertical, 5)
      .frame(maxWidth: 428)
      .frame(height: 34)
      .background(background)
      .cornerRadius(8)
      .font(.subheadline)
      .foregroundColor(foreground)
  }
}
