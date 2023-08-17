
import SwiftUI

struct MOButton<Background: ShapeStyle>: View {
  let text: String
  let background: Background
  let textColor: Color
  let image: String
  let action: ()->()
  
  
  init(text: String, background: Background, textColor: Color, image: String = "", action: @escaping () -> Void) {
    self.text = text
    self.background = background
    self.textColor = textColor
    self.image = image
    self.action = action
  }
  
  var body: some View {
    Button{ action() } label: {
      HStack {
        
        Text(text)
      }
    }
      .buttonLabel(background:  background, foreground: textColor)
      .overlay {
        Rectangle()
          .frame(maxWidth: .infinity)
          .frame(maxHeight: .infinity)
          .opacity(0.001)
          .onTapGesture {
            action()
          }
      }
  }
}

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
      .cornerRadius(10)
  }
}
