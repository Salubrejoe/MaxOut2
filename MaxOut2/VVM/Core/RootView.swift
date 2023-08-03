

import SwiftUI



struct RootView: View {
//  @StateObject var motion = MotionManager()
  @StateObject var manager = HealthKitManager()
  @StateObject private var model = StartViewModel()
  let gaugeController = GaugeViewController()
  
  @State private var selection: TabBarItem = .diary
  @State private var isHidden: Bool = false
  @State private var tabBarSize: ContainerSize = .regular
  
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
  
  @ViewBuilder // MARK: - SOMETHING
  private var something: some View {
    TabView {
      DiaryView(showingLoginView: $model.showingLoginView, tabBarIsHidden: $isHidden, tabBarSize: $tabBarSize)
        .tabItem({
          Label("Diary", systemImage: "book.closed")
        })
        .environmentObject(manager)
      StartContainer(tabBarIsHidden: $isHidden, tabBarSize: $tabBarSize)
        .tabItem({
          Label("Start", systemImage: "bolt.ring.closed")
        })
        .environmentObject(model)
      ExercisesListView(tabBarSize: $tabBarSize)
        .tabItem({
          Label("Exercises", systemImage: "figure.hiking")
        })
    }
  }
  
  
  @ViewBuilder
  private var mainTabBar: some View {
    ContainerView(selection: $selection, isHidden: $isHidden, containerSize: $tabBarSize) {
      Group {
        DiaryView(showingLoginView: $model.showingLoginView, tabBarIsHidden: $isHidden, tabBarSize: $tabBarSize)
          .tabBarItem(.diary, selection: $selection)
          .environmentObject(manager)
        StartContainer(tabBarIsHidden: $isHidden, tabBarSize: $tabBarSize)
          .tabBarItem(.start, selection: $selection)
          .environmentObject(model)
        ExercisesListView(tabBarSize: $tabBarSize)
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
//          .shadow(radius: 2)
      }
      .onChange(of: model.position) { newValue in
        if newValue == .relative(0.93) { isHidden = true }
        else { isHidden = false}
      }
      .onChange(of: selection) { newValue in
        if newValue == .exercises {
          tabBarSize = .small
        }
        else {
          tabBarSize = .regular
        }
      }
    }
    
  }
}

