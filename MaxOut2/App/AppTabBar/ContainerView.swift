

import SwiftUI


struct ContainerView<Content: View>: View {
  @Binding var selection: TabBarItem
  @Binding var isHidden: Bool
  @Binding var containerSize: ContainerSize
  let content: Content
  
  @State var tabs: [TabBarItem] = []
  
  init(selection: Binding<TabBarItem>, isHidden: Binding<Bool>, containerSize: Binding<ContainerSize>, @ViewBuilder content: () -> Content) {
    self.content = content()
    self._selection = selection
    self._isHidden = isHidden
    self._containerSize = containerSize
  }
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
        content
        .ignoresSafeArea()
      CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection, containerSize: $containerSize)
        .offset(y: isHidden ? 300 : 0)
        .animation(.spring(), value: isHidden)
      }
    
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}

struct ContainerView_Previews: PreviewProvider {
  static var previews: some View {
    ContainerView(selection: .constant(TabBarItem.diary), isHidden: .constant(false), containerSize: .constant(.regular), content: {
      Color.purple
    })
  }
}
