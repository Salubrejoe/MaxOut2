import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
  
  static var defaultValue: [TabBarItem] = []
  
  static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
    value += nextValue()
  }
  // everytime we add to the preferenceKey, instead of changing the preference key we are going to append, so that the array keeps growing
}

struct TabBarItemViewModifier: ViewModifier {
  
  let tab: TabBarItem
  @Binding var selection: TabBarItem
  
  func body(content: Content) -> some View {
    content
      .opacity(selection == tab ? 1 : 0)
      .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
  }
}

extension View {
  func tabBarItem(_ tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
    modifier(TabBarItemViewModifier(tab: tab, selection: selection))
  }
}
