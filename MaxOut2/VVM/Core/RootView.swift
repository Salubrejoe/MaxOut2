

import SwiftUI

struct RootView: View {
  @StateObject private var model = RootViewModel()
  
  var body: some View {
    mainTabBar
      .fontDesign(.rounded)
      .onAppear(perform: model.checkCurrentUser)
      .fullScreenCover(isPresented: $model.showingLoginView) {
        LoginView(showingLoginView: $model.showingLoginView)
      }
  }


  @ViewBuilder
  private var mainTabBar: some View {
    TabView {
      StartContainer(showingLoginView: $model.showingLoginView)
        .tabItem {
          Label("Start", systemImage: "bolt.ring.closed")
        }
      ExercisesListView()
        .tabItem {
          Label("Exercises", systemImage: "figure.hiking")
        }
      HistoryView()
        .tabItem {
          Label("History", systemImage: "mountain.2")
        }
      
    }
  }
}

