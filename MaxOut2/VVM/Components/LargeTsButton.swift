
import SwiftUI

struct LargeTsButton: View {
  let text: String
  let buttonColor: Color
  let textColor: Color
  let action: ()->()
  
  var body: some View {
    Button(text) { action() }
      .buttonLabel(background:  buttonColor, foreground: textColor)
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


struct LargeTsButton_Previews: PreviewProvider {
  static var previews: some View {
    LargeTsButton(text: "Save", buttonColor: .accentColor, textColor: .white) {
      
    }
  }
}
