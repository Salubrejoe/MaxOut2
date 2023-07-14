import SwiftUI

struct LoginTextField: View {
  @Binding var text: String
  let field: Field
  let isSecure : Bool
  let action: () -> Void
  let xMarkAction: () -> Void
  
  var body: some View {
    ZStack(alignment: .trailing) {
      if isSecure {
        SecureField(field.stringValue.capitalized, text: $text)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.never)
          .padding()
          .buttonLabel(background: Color.secondarySytemBackground, foreground: .primary)
          .onSubmit {
            action()
          }
      }
      else {
        TextField(field.stringValue.capitalized, text: $text)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.never)
          .padding()
          .buttonLabel(background: Color.secondarySytemBackground, foreground: .primary)
          .onSubmit {
            action()
          }
      }
        
      if !text.isEmpty {
        XMarkButton {
          xMarkAction()
        }
        .padding(.trailing)
      }
    }
    .frame(maxWidth: 428)
    .frame(height: 46)
  }
}


