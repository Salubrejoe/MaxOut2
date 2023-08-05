
import SwiftUI

struct DiaryView: View {
  enum CoordinateSpaces {
    case scrollView
  }
  @EnvironmentObject var manager: HealthKitManager
  @EnvironmentObject var startModel: StartViewModel
  @StateObject private var model = DiaryViewModel()
  
  @Binding var showingLoginView: Bool
  @Binding var tabBarState: BarState
  
  @State private var scrollOffset: CGFloat = 0.0
  
  var body: some View {
    NavigationStack {
      ScrollView(showsIndicators: false) {
        header
          .onScrollViewOffsetChanged(coordinateSpace: CoordinateSpaces.scrollView) { offset in
            scrollOffset = offset
            calculateBarState(with: offset)
          }
        WidgetGrid()
          .environmentObject(manager)
      }
      .coordinateSpace(name: CoordinateSpaces.scrollView)
      .padding(.horizontal)
      .navigationTitle("Diary").navigationBarTitleDisplayMode(.inline)
//      .toolbar { toolbar }
      
      .task { try? await model.loadCurrentUser() }
      .onAppear { manager.start() }
    }
  }
  
  private func calculateBarState(with offset: CGFloat) {
    guard tabBarState != .hidden else { return }
    guard !startModel.inProgress else { return }
    if offset < 0 { tabBarState = .small }
    else { tabBarState = .large }
  }
}

extension DiaryView {
  
  @ViewBuilder // MARK: - Header
  private var header: some View {
    GroupBox {
      NavigationLink {
        ProfileView(model: model, showingLoginView: $showingLoginView, tabBarState: $tabBarState)
      } label: {
        ProfileLabel(user: model.user)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .groupBoxStyle(RegularMaterialStyle())
  }
  
    
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var toolbar: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      NavigationLink {
        // SettingsView
      } label: {
        Image(systemName: "gearshape")
      }
    }
  }
}
  

// MARK: - PROFILE LABEL
struct ProfileLabel: View {
  @EnvironmentObject var manager: HealthKitManager
  let user: FitUser
  
  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading) {
        Text(user.displayName)
          .font(.title3.bold())
        HStack {
          Text(user.ageString)
          Text(manager.heightProfileString)
        }
        .font(.caption)
        .foregroundColor(.gray)
      }
    }
    .padding(.horizontal)
  }
}


struct DiaryView_Previews: PreviewProvider {
  static var previews: some View {
    DiaryView(showingLoginView: .constant(false), tabBarState: .constant(.large))
  }
}
