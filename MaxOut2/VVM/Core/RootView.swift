

import SwiftUI



struct RootView: View {
  @StateObject var manager = HealthKitManager()
  @StateObject private var model = StartViewModel()
  let gaugeController = GaugeViewController()
  
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
    TabView {
      DiaryView(showingLoginView: $model.showingLoginView)
        .tabItem {
          Label("Diary", systemImage: "book.closed")
        }
        .environmentObject(manager)
        
      StartContainer()
        .environmentObject(model)
        .tabItem {
          Label("Start", systemImage: "bolt.ring.closed")
        }
      ExercisesListView()
        .tabItem {
          Label("Exercises", systemImage: "figure.hiking")
        }
      
    }
  }
}

