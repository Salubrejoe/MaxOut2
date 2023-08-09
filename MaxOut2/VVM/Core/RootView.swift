

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
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisesPicker()
        .environmentObject(model)
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
//            ScrollView {
//              if !model.sessions.isEmpty {
//                TimeTextField(text: $model.sessions[0].bobs[0].duration)
//              }
//              LargeTsButton(text: "Add Exercises", background: .ultraThinMaterial, textColor: .accentColor, image: "exercisesList") {
//                model.isShowingPicker = true
//              }
//              .padding(.top, 20)
//              .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
//            }
//            .scrollDismissesKeyboard(.immediately)
          }
      }
      .onChange(of: model.position) { _ in
        if model.position == .relative(0.93) { tabBarState = .hidden }
        else { tabBarState = .large }
      }
    }
  }
}

