

import SwiftUI



struct RootView: View {
  @StateObject var manager = HealthKitManager()
  @StateObject private var model = StartViewModel()
  let gaugeController = GaugeViewController()
  
  @State private var selection: TabBarItem = .diary
  @State private var isHidden: Bool = false
  
  var body: some View {
    mainTabBar
      .fontDesign(.rounded)
      .onAppear(perform: model.checkCurrentUser)
      .fullScreenCover(isPresented: $model.showingLoginView) {
        LoginView(showingLoginView: $model.showingLoginView)
      }
      .onFirstAppear {
        gaugeController.requestNotificationPermish()
      }
  }
  
  
  @ViewBuilder
  private var mainTabBar: some View {
    ContainerView(selection: $selection, isHidden: $isHidden) {
      Group {
        DiaryView(showingLoginView: $model.showingLoginView, tabBarIsHidden: $isHidden)
          .tabBarItem(.diary, selection: $selection)
          .environmentObject(manager)
        StartContainer(tabBarIsHidden: $isHidden)
          .tabBarItem(.start, selection: $selection)
          .environmentObject(model)
        ExercisesListView()
          .tabBarItem(.exercises, selection: $selection)
      }
      .if(model.inProgress) { content in
        content
          .bottomSheet(bottomSheetPosition: $model.position, switchablePositions: model.switchablePositions) {
            InProgressHeader(tabBarIsHidden: $isHidden)
              .environmentObject(model)
          } mainContent: {
            SessionsGrid(tabBarIsHidden: $isHidden)
              .environmentObject(model)
          }
          .shadow(radius: 2)
      }
      .onChange(of: model.position) { newValue in
        if newValue == .relative(0.93) { isHidden = true }
        else { isHidden = false}
      }
    }
  }
}

