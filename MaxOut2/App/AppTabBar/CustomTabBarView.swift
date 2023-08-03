
import SwiftUI

enum ContainerSize {
  case regular, small
  
  mutating func toggle() {
    switch self {
      case .regular:
        self = .small
      case .small:
        self = .regular
    }
  }
}

struct CustomTabBarView: View {
  @Environment(\.dismiss) var dismiss
  let tabs: [TabBarItem]
  @Binding var selection: TabBarItem
  @State  var localSelection: TabBarItem
  @Namespace private var namespace
  
  @Binding var containerSize: ContainerSize
  
  @State private var offset: CGSize = .zero
  
  var body: some View {
    v2
      .offset(offset)
      .gesture(
        DragGesture()
          .onChanged({ newValue in
            offset = newValue
          })
          .onEnded({ newValue in
            if newValue. > 0 {
              
            }
          })
      )
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
      if containerSize == .regular {
        Text(tab.title.capitalized)
          .font(.footnote)
          .fontWeight(.semibold)
          .fontDesign(.rounded)
      }
    }
        .foregroundColor(localSelection == tab ? Color.accentColor : .secondary)
        .padding(.vertical, 8)
        .frame(maxWidth: containerSize == .small ? 50 : .infinity)
        .frame(maxHeight: containerSize == .small ? 30 : 60)
        .animation(.spring(), value: containerSize)
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
