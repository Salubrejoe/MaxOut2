

import SwiftUI

struct RootView: View {
  @StateObject private var model = RootViewModel()
  
  var body: some View {
    //    mainTabBar
    
    
    Button("LogOut") {
      Task {
        do {
          try FireAuthManager.shared.signOut()
          model.checkCurrentUser()
        }
        catch {
          print("Errorororooroorororooroororoorooror")
        }
      }
    }
      .fontDesign(.rounded)
      .onAppear(perform: model.checkCurrentUser)
      .fullScreenCover(isPresented: $model.showingLoginView) {
        NavigationStack {
          LoginView(showingLoginView: $model.showingLoginView)
        }
      }
  }


//  @ViewBuilder
//  private var mainTabBar: some View {
//    TabView {
//      DoView(showingLoginView: $model.showingLoginView)
//        .tabItem {
//          Label("Start", systemImage: "bolt.ring.closed")
//        }
//      ExercisesListView()
//        .tabItem {
//          Label("Exercises", systemImage: "figure.hiking")
//        }
//      HistoryView()
//        .tabItem {
//          Label("History", systemImage: "mountain.2")
//        }
//    }
//  }
}

