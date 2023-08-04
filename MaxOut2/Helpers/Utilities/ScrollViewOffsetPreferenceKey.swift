import SwiftUI

struct ScrollViewOffsetPK: PreferenceKey {
  static var defaultValue: CGFloat = 0
  
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

extension View {
  func onScrollViewOffsetChanged<Space: Hashable>(coordinateSpace: Space, action: @escaping (_ offset: CGFloat) -> Void) -> some View {
    self
      .background(
        GeometryReader { geo in
          Text("")
            .preference(key: ScrollViewOffsetPK.self, value: geo.frame(in: .named(coordinateSpace)).minY)
        }
      )
      .onPreferenceChange(ScrollViewOffsetPK.self) { value in
        action(value)
      }
  }
}

struct Test: View {
  enum CoordinateSpaces {
    case scrollView
  }
  @State private var scrollOffset: CGFloat = 0.0
  
  var body: some View {
    NavigationStack {
      ScrollView {
        VStack {
//          
//          titleLayer
//          
          contentLayer
            .onScrollViewOffsetChanged(coordinateSpace: CoordinateSpaces.scrollView) { offset in
              scrollOffset = offset
            }
        }
      }
      .navigationTitle("Pizza")
      .padding(.horizontal)
      .coordinateSpace(name: CoordinateSpaces.scrollView)
      .overlay(Text("\(scrollOffset)"))
    }
  }
  
  @ViewBuilder
  private var titleLayer: some View {
    Text("TITLE")
      .font(.largeTitle.bold())
      .frame(maxWidth: .infinity, alignment: .leading)
  }
  
  @ViewBuilder
  private var contentLayer: some View {
    ForEach(0..<10, id: \.self) { _ in
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.pink.opacity(0.2))
        .frame(height: 100)
    }
  }
}

struct Test_Previews: PreviewProvider {
  static var previews: some View {
    Test()
  }
}
