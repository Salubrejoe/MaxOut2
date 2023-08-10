import SwiftUI
import FirebaseCore

@main
struct MaxOut2App: App {
  init() { FirebaseApp.configure() }
  
  @State private var number = 0.0
  
  var body: some Scene {
    WindowGroup {
      RootView()
//      BobTextField(value: $number, significantDigits: 2)
    }
  }
}
