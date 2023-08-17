import SwiftUI
import FirebaseCore

@main
struct MaxOut2App: App {
  @StateObject private var userManager = FitUserManager()
  
  init() { FirebaseApp.configure() }
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(userManager)
    }
  }
}
