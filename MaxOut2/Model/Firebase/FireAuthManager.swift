
import Foundation
import FirebaseAuth
import AuthenticationServices

/// ProviderOption
enum AuthProviderOption: String {
  case email = "password"
  case google = "google.com"
  case apple = "apple.com"
}

// MARK: - Get User/Provider
final class FireAuthManager {
  static let shared = FireAuthManager() // SINGLETON
  
  // GET AUTH RESULT (user)
  func currentAuthenticatedUser() throws -> AuthenticationResultModel { /// ⚾️
    guard let user = Auth.auth().currentUser else { throw FireAuthManError.noCurrentUser} /// 🥎
    return AuthenticationResultModel(user: user)
  }
  
  // GET PROVIDER
  func authProviderOptions() throws -> [AuthProviderOption] { /// ⚾️
    guard let providerData = Auth.auth().currentUser?.providerData else { throw FireAuthManError.noCurrentUser } /// 🥎
    
    var providers: [AuthProviderOption] = []
    for provider in providerData {
      if let option = AuthProviderOption(rawValue: provider.providerID) {
        providers.append(option)
      } else {
        assertionFailure("Assertion Failure")
      }
    }
    return providers
  }
  
  // SIGN OUT
  func signOut() throws { /// ⚾️
    try Auth.auth().signOut()/// 🥎
  }
  
  // DELETE USER
  func deleteUser() async throws { /// 🧵⚾️
    guard let currentAuthenticatedUser = Auth.auth().currentUser else { throw URLError(.badServerResponse) }
    FitUserManager.shared.deleteUser(with: currentAuthenticatedUser.uid)
    try await currentAuthenticatedUser.delete()/// 🧵🥎
  }
}

// MARK: - SignInEMAIL
extension FireAuthManager {
  
  // CREATE USER
  @discardableResult /// 🧵⚾️
  func createUser(email: String, password: String, username: String) async throws -> AuthenticationResultModel {
    let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password) /// 🧵🥎
    let changeRequest = authDataResult.user.createProfileChangeRequest()
    changeRequest.displayName = username
    try await changeRequest.commitChanges() /// 🧵🥎
    return AuthenticationResultModel(user: authDataResult.user)
  }
  
  // LOG IN USER
  @discardableResult /// 🧵⚾️
  func signInUser(email: String, password: String) async throws -> AuthenticationResultModel {
    let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password) /// 🧵🥎
    return AuthenticationResultModel(user: authDataResult.user)
  }
  
  // RESET PASSWORD
  func sendPasswordReset(to email: String) async throws { /// 🧵⚾️
    try await Auth.auth().sendPasswordReset(withEmail: email)
  }
  
  // UPDATE PASSWORD
  func updatePassword(to password: String) async throws { /// 🧵⚾️
    guard let user = Auth.auth().currentUser else {
      throw URLError(.badServerResponse) /// 🥎
    }
    try await user.updatePassword(to: password) /// 🧵🥎
  }
  
  // UPDATE EMAIL
  func updateEmail(to email: String) async throws { /// 🧵⚾️
    guard let user = Auth.auth().currentUser else {
      throw URLError(.badServerResponse) /// 🥎
    }
    try await user.updateEmail(to: email) /// 🧵🥎
  }
}


// MARK: - SignIn SSO
extension FireAuthManager {
  
  // GOOGLE
  func signInWithGoogle(tokens: GoogleResultModel) async throws -> AuthenticationResultModel { /// 🧵⚾️
    let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken,
                                                   accessToken: tokens.accessToken)
    return try await signInWith(credential: credential) /// 🧵🥎
  }
  
  // APPLE
  func signInWithApple(tokens: SignInWithAppleResult) async throws -> AuthenticationResultModel { /// 🧵⚾️
    let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                   rawNonce: tokens.nonce,
                                                   fullName: tokens.appleIDCredential.fullName)
    return try await signInWith(credential: credential) /// 🧵🥎
  }
  
  // CREDENTIAL
  func signInWith(credential: AuthCredential) async throws -> AuthenticationResultModel { /// 🧵⚾️
    let authDataResult = try await Auth.auth().signIn(with: credential) /// 🧵🥎
    return AuthenticationResultModel(user: authDataResult.user)
  }
}


// MARK: - Error
enum FireAuthManError: LocalizedError {
  case noCurrentUser
  case noEmailAddress
  case unableToFetchToken
  case unableToSerializeToken
  case unableToFindNonce
  
  var errorDescription: String? {
    switch self {
      case .noCurrentUser:
        return "No user currently logged in."
      case .noEmailAddress:
        return "The user did not provide a avalid email address."
      case .unableToFetchToken:
        return "Unable to fetch identity token"
      case .unableToSerializeToken:
        return "Unable to serialize token string from data"
      case .unableToFindNonce:
        return "Unable to find Lurrent nonce. "
    }
  }
}
