

import Foundation

@MainActor
final class CreateAccountViewModel: ObservableObject {
  var authResult: AuthenticationResultModel?
  
  /// CREATE USER
  func createUser(email: String, password: String, username: String) async throws { /// 🧵⚾️
    authResult = try await FireAuthManager.shared.createUser(email: email, password: password, username: username) /// 🧵🥎
    try await pushFitUser()/// 🧵🥎
  }
  
  func pushFitUser() async throws { /// 🧵⚾️
    guard let authUser = authResult else { throw FireAuthManError.noCurrentUser } /// 🥎
    let newUser = FitUser(from: authUser)
    try await FitUserManager.shared.pushNew(user: newUser) /// 🥎
  }
}
