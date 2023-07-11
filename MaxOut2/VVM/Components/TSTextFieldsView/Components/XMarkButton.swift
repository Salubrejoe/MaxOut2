import SwiftUI

struct XMarkButton: View {
  let action: () -> Void
  
  var body: some View {
    Button {  
      action()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .font(.headline)
        .foregroundColor(.secondary)
    }
  }
}
