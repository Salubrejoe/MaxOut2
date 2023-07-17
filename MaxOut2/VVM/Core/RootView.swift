

import SwiftUI

final class RootViewModel: ObservableObject {
  @Published var showingLoginView = false
  
  func checkCurrentUser() {
    let user = try? FireAuthManager.shared.currentAuthenticatedUser()
    self.showingLoginView = user == nil
  }
}

struct RootView: View {
  @StateObject private var model = RootViewModel()
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
      StartContainer(showingLoginView: $model.showingLoginView)
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

