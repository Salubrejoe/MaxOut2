
import SwiftUI

enum BarState: String {
  case hidden, small, large
}


struct CustomBar: View {
  @Environment(\.dismiss) var dismiss
  let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  @State  var localSelection: TabBarItem
  @Namespace private var namespace
  
  @Binding var state: BarState
  
  var body: some View {
    v2
      .frame(height: 60)
      .onChange(of: selection) { newValue in
        withAnimation(.easeInOut) {
          localSelection = newValue
        }
      }
  }
}

// MARK: - tabView(tab:)
extension CustomBar {
  private func tabView2(tab: TabBarItem) -> some View {
    VStack {
      Image(systemName: tab.iconName)
      if state != .small {
        Text(tab.title.capitalized)
          .font(.footnote)
          .fontDesign(.rounded)
      }
    }
    .foregroundColor(localSelection == tab ? .white : .secondary)
    .fontWeight(localSelection == tab ? .semibold : .regular)
    .frame(maxWidth: state != .small ? .infinity : 50)
    .padding(.vertical, 8)
    .background(
      ZStack {
        if localSelection == tab {
          RoundedRectangle(cornerRadius: state != .small ? 14 : 12)
            .fill(Color.systemBackground.opacity(0.2))
            .matchedGeometryEffect(id: "background_rect", in: namespace)
        }
      }
    )
    .animation(.spring(), value: state)
  }
  
  @ViewBuilder // MARK: - v2
  private var v2: some View {
    HStack {
      ForEach(tabs, id: \.self) { tab in
        tabView2(tab: tab)
          .onTapGesture { selection = tab }
      }
    }
    .padding(6)
    .background(Color.black)
    .cornerRadius(20)
    .padding(.horizontal)
    .shadow(radius: 3)
  }
}
