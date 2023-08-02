
import SwiftUI

struct CustomTabBarView: View {
  @Environment(\.dismiss) var dismiss
  let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  @State  var localSelection: TabBarItem
  @Namespace private var namespace
  
  var body: some View {
    v2
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
    .foregroundColor(localSelection == tab ? tab.color : .secondary)
    .padding(.vertical, 8)
    .frame(maxWidth: .infinity)
    .frame(maxHeight: 60)
    .background(
      ZStack {
        if localSelection == tab {
          RoundedRectangle(cornerRadius: 16)
            .fill(tab.color.opacity(0.2))
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
    .background(.ultraThickMaterial)
    .cornerRadius(20)
    .padding(.horizontal)
  }
}


// MARK: - PREVIEW
//struct CustomTabBarView_Previews: PreviewProvider {
//  static var previews: some View {
//    VStack {
//      Spacer()
//      CustomTabBarView(tabs: [], selection: .constant(TabBarItem.diary), localSelection: TabBarItem.diary)
//    }
//  }
//}
