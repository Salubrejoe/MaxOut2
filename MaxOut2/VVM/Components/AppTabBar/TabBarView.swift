

import SwiftUI


struct TabBarView<Content: View>: View {
  @Binding var selection: TabBarItem
  @Binding var tabBarState: BarState
  let content: Content
  
  @State var tabs: [TabBarItem] = []
  
  init(selection: Binding<TabBarItem>, tabBarState: Binding<BarState>, @ViewBuilder content: () -> Content) {
    self.content = content()
    self._selection = selection
    self._tabBarState = tabBarState
  }
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
      content
        .ignoresSafeArea()
        
      CustomBar(tabs: tabs, selection: $selection, localSelection: selection, state: $tabBarState)
        .offset(y: tabBarState == .hidden ? 300 : 0)
        .animation(.spring(blendDuration: 0.5), value: tabBarState)
      }
    
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(selection: .constant(TabBarItem.diary), tabBarState: .constant(.large), content: {
      Color.purple
    })
  }
}
