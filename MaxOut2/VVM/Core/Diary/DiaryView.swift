
import SwiftUI

struct DiaryView: View {
  enum CoordinateSpaces {
    case scrollView
  }
  @EnvironmentObject var manager: HealthKitManager
  @StateObject private var model = DiaryViewModel()
  
  @Binding var showingLoginView: Bool
  @Binding var tabBarIsHidden: Bool
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.systemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 50) {
        WidgetGrid()
          .environmentObject(manager)
        
          .navigationTitle("Diary").navigationBarTitleDisplayMode(.inline)
          .toolbar { toolbar }
        
          .task { try? await model.loadCurrentUser() }
          .onAppear { manager.start() }
      } header: {
        header
      }
    }
  }
}

extension DiaryView {
  
  @ViewBuilder // MARK: - Header
  private var header: some View {
    List {
      NavigationLink {
        ProfileView(model: model, showingLoginView: $showingLoginView, tabBarIsHidden: $tabBarIsHidden)
      } label: {
        ProfileLabel(user: model.user)
      }
    }.listStyle(.plain)
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
    DiaryView(showingLoginView: .constant(false), tabBarIsHidden: .constant(true))
  }
}
