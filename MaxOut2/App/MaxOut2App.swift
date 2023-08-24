import SwiftUI
import FirebaseCore

@main
struct MaxOut2App: App {
  
  init() { FirebaseApp.configure() }
  
  var body: some Scene {
    WindowGroup {
      RootView()
//      SwiftUIView()
    }
  }
}
