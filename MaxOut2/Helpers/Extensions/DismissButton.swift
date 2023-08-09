import SwiftUI

struct DismissButton: ViewModifier {
  @Environment(\.dismiss) var dismiss
  func body(content: Content) -> some View {
    content
      .toolbar {
        xMark
      }
  }
  
  @ToolbarContentBuilder
  private var xMark: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .imageScale(.large)
          .symbolRenderingMode(.hierarchical)
          .foregroundColor(.secondary)
      }
    }
  }
}

struct XMark: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .imageScale(.large)
        .symbolRenderingMode(.hierarchical)
        .foregroundColor(.secondary)
    }
  }
}


extension View {
  func dismissButton() -> some View {
    self.modifier(DismissButton())
  }
}
