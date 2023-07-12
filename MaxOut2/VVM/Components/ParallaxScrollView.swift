import SwiftUI

struct ParallaxScrollView<Background: View, Header: View, Content: View, Space: Hashable> : View {
  
  let background: Background
  let coordinateSpace: Space
  let defaultHeight: CGFloat
  let content: () -> Content
  let header: () -> Header
  
  init(background: Background, coordinateSpace: Space, defaultHeight: CGFloat, @ViewBuilder content: @escaping () -> Content, @ViewBuilder header: @escaping () -> Header) {
    self.background = background
    self.coordinateSpace = coordinateSpace
    self.defaultHeight = defaultHeight
    self.content = content
    self.header = header
  }
  
  var body: some View {
    ZStack {
      background.ignoresSafeArea()
      
      ScrollView(showsIndicators: false) {
        ParallaxHeader(coordinateSpace: coordinateSpace, defaultHeight: defaultHeight) {
          header()
        }
        content()
          .padding(.horizontal)
          .padding(.vertical, 5)
          .background(.ultraThinMaterial)
          .cornerRadius(20)
          .shadow(radius: 5)
      }
      .coordinateSpace(name: coordinateSpace)
      .scrollDismissesKeyboard(.interactively)
    }
  }
}

struct ParallaxHeader<Content: View, Space: Hashable>: View {
  let content: () -> Content
  let coordinateSpace: Space
  let defaultHeight: CGFloat
  
  init(coordinateSpace: Space, defaultHeight: CGFloat, @ViewBuilder content: @escaping () -> Content) {
    self.content = content
    self.coordinateSpace = coordinateSpace
    self.defaultHeight = defaultHeight
  }
  
  var body: some View {
    GeometryReader { proxy in
      let offset = offset(for: proxy)
      let heightModifier = heightModifier(for: proxy)
      let blurRadius = min(heightModifier/20, max(10, heightModifier/20))

      content()
        .frame(width: proxy.size.width,
               height: proxy.size.height + heightModifier)
        .offset(y: offset)
        .blur(radius: blurRadius)
    }.frame(height: defaultHeight)
  }
  
  private func offset(for proxy: GeometryProxy) -> CGFloat {
    let frame = proxy.frame(in: .named(coordinateSpace))
    if frame.minY < 0 {
      return -frame.minY * 0.8
    }
    return -frame.minY
  }
  
  private func heightModifier(for proxy: GeometryProxy) -> CGFloat {
    let frame = proxy.frame(in: .named(coordinateSpace))
    return max(0, frame.minY)
  }
}

//struct ParallaxHeader_Previews: PreviewProvider {
//  static var previews: some View {
//    ParallaxHeader() {}
//  }
//}
