import SwiftUI

struct TSTextField: View {
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
          .padding()
          .background(.ultraThinMaterial)
          .cornerRadius(10)
          .onSubmit {
            action()
          }
      }
      else {
        TextField(field.stringValue.capitalized, text: $text)
          .autocorrectionDisabled(true)
          .padding()
          .background(.ultraThinMaterial)
          .cornerRadius(10)
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
    .frame(maxWidth: 432)
  }
}


