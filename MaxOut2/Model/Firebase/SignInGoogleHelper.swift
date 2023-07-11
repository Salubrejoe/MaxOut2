
import Foundation
import GoogleSignIn

final class SignInGoogleHelper {
  
  @MainActor // MARK: - GET TOKENS
  func getGoogleSignInTokens() async throws -> GoogleResultModel { /// 🧵⚾️
    
    /// Get top most VC
    guard let topVC = Utilities.shared.topViewController() else {
      throw SignInWithGoogleError.invalidState /// 🥎
    }
    
    /// Call to SDK method
    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC) /// 🧵🥎
    
    
    /// Grab values to create a GoogleResultModel that holds the 2 tokes
    guard let idToken = result.user.idToken?.tokenString else {
      throw SignInWithGoogleError.unableToFetchToken /// 🥎
    }
    let accessToken = result.user.accessToken.tokenString
    let name = result.user.profile?.name
    let email = result.user.profile?.email
    
    /// Return it
    let tokens = GoogleResultModel(idToken: idToken, accessToken: accessToken, name: name, email: email)
    return tokens
  }
}


// MARK: - MODEL
struct GoogleResultModel {
  let idToken: String
  let accessToken: String
  let name: String?
  let email: String?
}


extension SignInGoogleHelper {
  // MARK: - ERROR
  private enum SignInWithGoogleError: LocalizedError {
    case invalidCredential
    case invalidState
    case unableToFetchToken
    case unableToSerializeToken
    case unableToFindNonce
    
    var errorDescription: String? {
      switch self {
        case .invalidCredential:
          return "Invalid credential: ASAuthorization failure."
        case .invalidState:
          return "Invalid state: A login callback was received, but no login request was sent"
        case .unableToFetchToken:
          return "Unable to fetch identity token"
        case .unableToSerializeToken:
          return "Unable to serialize token string from data"
        case .unableToFindNonce:
          return "Unable to find Lurrent nonce. "
      }
    }
  }

}

