
import SwiftUI

struct LargeTsButton<Background: ShapeStyle>: View {
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
