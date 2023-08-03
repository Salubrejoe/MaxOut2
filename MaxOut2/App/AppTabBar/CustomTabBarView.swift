
import SwiftUI


struct CustomTabBarView: View {
  @Environment(\.dismiss) var dismiss
  let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  @State  var localSelection: TabBarItem
  @Namespace private var namespace
  
  var body: some View {
    v2
      .frame(height: 46)
      .onChange(of: selection) { newValue in
        withAnimation(.easeInOut) {
          localSelection = newValue
        }
      }
  }
}

// MARK: - tabView(tab:)
extension CustomTabBarView {
  private func tabView2(tab: TabBarItem) -> some View {
    VStack {
      Image(systemName: tab.iconName)
      Text(tab.title.capitalized)
        .font(.footnote)
        .fontWeight(.semibold)
        .fontDesign(.rounded)
    }
    .foregroundColor(localSelection == tab ? Color.accentColor : .secondary)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .background(
      ZStack {
        if localSelection == tab {
          RoundedRectangle(cornerRadius: 16)
            .fill(.primary.opacity(0.2))
            .matchedGeometryEffect(id: "background_rect", in: namespace)
        }
      }
    )
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
    .background(.regularMaterial)
    .cornerRadius(20)
    .padding(.horizontal)
    .shadow(radius: 3)
  }
}
