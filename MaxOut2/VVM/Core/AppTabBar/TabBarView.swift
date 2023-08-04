

import SwiftUI


struct TabBarView<Content: View>: View {
  @Binding var selection: TabBarItem
  @Binding var isHidden: Bool
  let content: Content
  
  @State var tabs: [TabBarItem] = []
  
  init(selection: Binding<TabBarItem>, isHidden: Binding<Bool>, @ViewBuilder content: () -> Content) {
    self.content = content()
    self._selection = selection
    self._isHidden = isHidden
  }
  
  var body: some View {
    
    ZStack(alignment: .bottom) {
        content
        .ignoresSafeArea()
      CustomBar(tabs: tabs, selection: $selection, localSelection: selection)
        .offset(y: isHidden ? 300 : 0)
        .animation(.spring(blendDuration: 0.5), value: isHidden)
      }
    
    .onPreferenceChange(TabBarItemsPreferenceKey.self) { value in
      self.tabs = value
    }
  }
}

struct TabBarView_Previews: PreviewProvider {
  static var previews: some View {
    TabBarView(selection: .constant(TabBarItem.diary), isHidden: .constant(false), content: {
      Color.purple
    })
  }
}
