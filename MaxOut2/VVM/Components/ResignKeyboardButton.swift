import SwiftUI

struct ResignKeyboardButton: View {
  var body: some View {
    HStack {
      Button {
        Field.hideKeyboard()
      } label: {
        Image(systemName: "keyboard.chevron.compact")
      }
      Spacer()
    }
  }
}
