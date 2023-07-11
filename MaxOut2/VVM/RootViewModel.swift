import Foundation

final class RootViewModel: ObservableObject {
  @Published var showingLoginView = false
  
  func checkCurrentUser() {
    let user = try? FireAuthManager.shared.currentAuthenticatedUser()
    self.showingLoginView = user == nil
  }
}
