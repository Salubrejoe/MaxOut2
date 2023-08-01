import SwiftUI
import FirebaseCore

@main
struct MaxOut2App: App {
  init() { FirebaseApp.configure() }
  
  @State private var isOpen = true
  
  var body: some Scene {
    WindowGroup {
      RootView()
//      GeometryReader { geo in
//        let height = geo.size.height
//        BottomSheetView(isOpen: $isOpen, maxHeight: height) {
//          Text("Pizza")
//            .frame(maxHeight: .infinity)
//        }
//        .onChange(of: isOpen) { newValue in
//          print(newValue)
//        }
//      }
      //      GridHeader()
    }
  }
}
