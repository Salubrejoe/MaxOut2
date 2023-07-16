import SwiftUI


struct BottomSheetView<Content: View>: View {
  @Binding var isOpen: Bool
  
  @GestureState private var translation: CGFloat = 0
  
  let maxHeight: CGFloat
  let minHeight: CGFloat
  let content: Content
  
  init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
    self.minHeight = maxHeight * Constants.minHeightRatio
    self.maxHeight = maxHeight
    self.content = content()
    self._isOpen = isOpen
  }
  
  @State private var offset = 0.0
  
  private func getOffset() -> CGFloat {
    isOpen ? 0 : maxHeight - minHeight
  }
  
  private var indicator: some View {
    RoundedRectangle(cornerRadius: Constants.radius)
      .fill(Color.secondary)
      .frame(
        width: Constants.indicatorWidth,
        height: Constants.indicatorHeight
      )
  }
  
  var body: some View {
    GeometryReader { geometry in
      VStack(spacing: 0) {
        self.indicator.padding()
        self.content
      }
      .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
      .background(Color(.secondarySystemBackground))
      .cornerRadius(Constants.radius)
      .frame(height: geometry.size.height, alignment: .bottom)
      .offset(y: self.offset)
      .animation(.spring(), value: isOpen)
      .animation(.spring(), value: translation)
      .gesture(
        DragGesture().updating(self.$translation) { value, state, _ in
          state = value.translation.height
        }
          .onChanged({ value in
            offset = value.translation.height
          })
          .onEnded { value in
          let snapDistance = self.maxHeight * Constants.snapRatio
          guard abs(value.translation.height) > snapDistance else {
            return
          }
          self.isOpen = value.translation.height < 0
          self.offset = self.getOffset()
        }
      )
    }
  }
}


struct BottomSheetView_Previews: PreviewProvider {
  static var previews: some View {
    BottomSheetView(isOpen: .constant(true),
                    maxHeight: 300) { Color.blue }
  }
}


class Constants {
  static let minHeightRatio  : CGFloat = 1/5
  static let snapRatio       : CGFloat = 1/9
  static let radius          : CGFloat = 20
  static let indicatorWidth  : CGFloat = 60
  static let indicatorHeight : CGFloat = 7
}
