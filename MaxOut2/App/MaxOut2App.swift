import SwiftUI
import FirebaseCore

@main
struct MaxOut2App: App {
  init() { FirebaseApp.configure() }
  
  @State private var isOpen = true
  
  var body: some Scene {
    WindowGroup {
//      RootView()
      Test()
    }
  }
}
