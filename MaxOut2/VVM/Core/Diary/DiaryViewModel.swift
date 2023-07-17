import UIKit


final class DiaryViewModel: ObservableObject {
  @Published var user: FitUser = FitUser.mockup
  @Published var authProviders: [AuthProviderOption] = []
  
  @MainActor
  func loadCurrentUser() async throws { /// 🧵⚾️
    let authDataResult = try FireAuthManager.shared.currentAuthenticatedUser() /// 🥎
    self.user = try await FitUserManager.shared.user(id: authDataResult.uid) /// 🧵🥎
  }
}

// MARK: - FirebaseAuth Methods
extension DiaryViewModel {
  func loadAuthProviders() {
    if let providers = try? FireAuthManager.shared.authProviderOptions() {
      self.authProviders = providers
    }
  }
  
  func update(user: FitUser) {
    do {
      try FitUserManager.shared.update(user: user)
    } catch {
      print("Could not update user: \(error)")
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
