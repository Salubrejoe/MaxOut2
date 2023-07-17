import Foundation
import CryptoKit
import GoogleSignIn
import GoogleSignInSwift
import AuthenticationServices

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
  @Published var showingCreateAccountView = false
  @Published var isShowingProgressView = false
  var authResult: AuthenticationResultModel?
  
  // CREATE FitUSER
  func createFitUser() async throws { /// 🧵⚾️
    guard let authResult = authResult else { throw  FireAuthManError.noCurrentUser } /// 🥎
    // CHECK FOR EXISTING ACCOUNT
    let isNewUser = try await FitUserManager.shared.isNewUser(with: authResult.uid) /// 🧵🥎
    if isNewUser {
      var newUser = FitUser(from: authResult)
      newUser.color = goodColors.randomElement()
      try await FitUserManager.shared.pushNew(user: newUser) /// 🥎
      self.isShowingProgressView = false
    }
  }
}

extension LoginViewModel {
  /// SIGN w/ EMAIL
  func signIn(email: String, password: String) async throws { /// 🧵⚾️
    self.isShowingProgressView = true
    authResult = try await FireAuthManager.shared.signInUser(email: email, password: password)
    try await createFitUser() /// 🧵🥎
  }
  
  /// SIGN w/ GOOGLE
  func signInWithGoogle() async throws { /// 🧵⚾️
    
    let helper = SignInGoogleHelper()
    let tokens = try await helper.getGoogleSignInTokens() /// 🧵🥎
    self.isShowingProgressView = true
    authResult = try await FireAuthManager.shared.signInWithGoogle(tokens: tokens) /// 🧵🥎
    try await createFitUser() /// 🧵🥎
  }
  
  /// SIGN w/ APPLE
  func signInWithApple() async throws { /// 🧵⚾️
    
    let helper = SignInWithAppleHelper()
    let tokens = try await helper.startSignInWithAppleFlow() /// 🧵🥎
    self.isShowingProgressView = true
    authResult = try await FireAuthManager.shared.signInWithApple(tokens: tokens) /// 🧵🥎
    try await createFitUser() /// 🧵🥎
  }
}
