

import SwiftUI



struct RootView: View {
  
  @StateObject var manager = HealthKitManager()
  @StateObject private var model = StartViewModel()
  let gaugeController = GaugeViewController()
  
  @State private var selection: TabBarItem = .start
  @State private var tabBarState: BarState = .large
  
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
    TabBarView(selection: $selection, tabBarState: $tabBarState) {
      Group {
        DiaryView(showingLoginView: $model.showingLoginView, tabBarState: $tabBarState)
          .tabBarItem(.diary, selection: $selection)
        StartContainer(tabBarState: $tabBarState)
          .tabBarItem(.start, selection: $selection)
        ExercisesListView(tabBarState: $tabBarState)
          .tabBarItem(.exercises, selection: $selection)
      }
      .environmentObject(manager)
      .environmentObject(model)
      
      
      
      // MARK: - IN PROGRESS
      .if(model.inProgress) { content in
        content
          .bottomSheet(bottomSheetPosition: $model.position, switchablePositions: model.switchablePositions) {
            InProgressHeader(tabBarState: $tabBarState)
              .environmentObject(model)
              .environmentObject(manager)
              
          } mainContent: {
            SessionsGrid(tabBarState: $tabBarState)
              .environmentObject(model)
          }
          .enableBackgroundBlur(true)
          
          
      }
      .onChange(of: model.position) { _ in
        if model.position == .relative(0.93) { tabBarState = .hidden }
        else { tabBarState = .large }
      }
    }
  }
}

