import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {
  @Published var fitUser: FitUser = FitUser.mockup
  @Published var authProviders: [AuthProviderOption] = []
  
  
  func loadCurrentUser() async throws { /// 🧵⚾️
    let authDataResult = try FireAuthManager.shared.currentAuthenticatedUser() /// 🥎
    self.fitUser = try await FitUserManager.shared.user(id: authDataResult.uid) /// 🧵🥎
  }
}


// MARK: - FirebaseAuth Methods
extension SettingsViewModel {
  func loadAuthProviders() {
    if let providers = try? FireAuthManager.shared.authProviderOptions() {
      self.authProviders = providers
    }
  }
  
  
  func resetPassword() async throws { /// 🧵⚾️
    let authUser = try FireAuthManager.shared.currentAuthenticatedUser() /// 🥎
    guard
      let email = authUser.email else {
      throw FireAuthManError.noEmailAddress /// 🥎
    }
    try await FireAuthManager.shared.sendPasswordReset(to: email) /// 🧵🥎
  }
  
  
  func deleteAccount() async throws{ /// 🧵⚾️
    try await FireAuthManager.shared.deleteUser() /// 🧵🥎
  }
  
  
  func signOut() throws { /// ⚾️
    try FireAuthManager.shared.signOut() /// 🥎
  }
}
