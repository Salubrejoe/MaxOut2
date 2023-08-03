import SwiftUI

extension View {
  func threeWayPickerStyle(isHidden: Binding<Bool>) -> some View {
    modifier(ThreeWayViewModifier(isHidden: isHidden))
  }
}


struct ThreeWayViewModifier : ViewModifier {
  @Binding var isHidden: Bool
  func body(content: Content) -> some View {
    content
      .frame(maxWidth: 428)
      .frame(height: 30)
      .padding(.horizontal, 6)
      .padding(.vertical, 6)
      .background(.regularMaterial)
      .cornerRadius(16)
      .opacity(isHidden ? 0 : 1)
      .animation(.easeIn, value: isHidden)
      .shadow(radius: 3)
      .onAppear {
        isHidden = false
      }
      .onDisappear {
        isHidden = true
      }
  }
}
