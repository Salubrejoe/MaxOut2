import UIKit


final class DiaryViewModel: ObservableObject {
  
  @Published var user: FitUser = FitUser.mockup
  @Published var authProviders: [AuthProviderOption] = []
  
  @Published var userStats: [UserStat]? = nil

  @Published var username: String = ""
  @Published var firstName: String = ""
  @Published var lastName: String = ""
  
  @MainActor
  func loadCurrentUser() async throws { /// 🧵⚾️
    let authDataResult = try FireAuthManager.shared.currentAuthenticatedUser() /// 🥎
    
    let user = try await FitUserManager.shared.user(id: authDataResult.uid) /// 🧵🥎
    self.user = user
    self.username = user.username ?? ""
    self.firstName = user.firstName ?? ""
    self.lastName = user.lastName ?? ""
  }
}

// MARK: - FirebaseAuth Methods
extension DiaryViewModel {
  
  func loadAuthProviders() {
    if let providers = try? FireAuthManager.shared.authProviderOptions() {
      self.authProviders = providers
    }
  }
  
  func updateUser() {
    self.user.username = self.username
    self.user.firstName = self.firstName
    self.user.lastName = self.lastName
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

