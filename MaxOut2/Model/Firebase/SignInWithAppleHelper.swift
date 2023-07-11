
import SwiftUI
import AuthenticationServices
import CryptoKit

// MARK: - Model
struct SignInWithAppleResult {
  let token: String
  let nonce: String
  let appleIDCredential: ASAuthorizationAppleIDCredential
}



// MARK: - MAIN METHOD
@MainActor
final class SignInWithAppleHelper: NSObject {
  private var currentNonce: String?
  private var completionHandler: ((Result<SignInWithAppleResult, Error>) -> Void)? = nil
  
  
  // MARK: - Start Flow
  // 🧵🤮
  func startSignInWithAppleFlow() async throws -> SignInWithAppleResult { /// 🧵⚾️
    try await withCheckedThrowingContinuation { continuation in
      self.startSignInWithAppleFlow { result in
        switch result {
          case .success(let signInWithAppleResult):
            continuation.resume(returning: signInWithAppleResult)
            return
          case .failure(let error):
            continuation.resume(throwing: error) /// 🧵🥎
            return
        }
      }
    }
  }
  
  func startSignInWithAppleFlow(completion: @escaping (Result<SignInWithAppleResult, Error>) -> Void) {
    // Get the current topmost View Controller
    guard let topVC = Utilities.shared.topViewController() else {
      completion(.failure(SignInWithAppleError.invalidState))
      return
    }
    
    // Get a nonce, save it for later
    let nonce = randomNonceString()
    currentNonce = nonce
    
    // Save the completion for later
    completionHandler = completion
    
    // Create a request with Appple ID Provider
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    // Assign scope and nonce
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    // Create a AuthViewController with the request
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = topVC // place it in the context of the current topmost VC
    authorizationController.performRequests() // Call to Delegate Methods (self)
  }
}

// MARK: - CryptoKit
extension SignInWithAppleHelper {
  private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
      fatalError(
        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
      )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
      // Pick a random character from the set, wrapping around if needed.
      charset[Int(byte) % charset.count]
    }
    
    return String(nonce)
  }
  
  @available(iOS 13, *)
  private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
}


// MARK: - Delegate Methods
extension SignInWithAppleHelper: ASAuthorizationControllerDelegate {
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    // Get values for creating a Model instance from authorization.credential, currentNonce .. throws
    guard
      let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
      let appleIDToken = appleIDCredential.identityToken,
      let nonce = currentNonce,
      let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
      completionHandler?(.failure(SignInWithAppleError.invalidCredential))
      return
    }
    
    // Instanciate a SIWA Result, call it a success!
    let result = SignInWithAppleResult(token: idTokenString, nonce: nonce, appleIDCredential: appleIDCredential )
    completionHandler?(.success(result))
  }
  
  
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Something went wrong
    completionHandler?(.failure(SignInWithAppleError.unableToFetchToken))
  }
}


// MARK: - UIViewRepresentable
struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
  let type: ASAuthorizationAppleIDButton.ButtonType
  let style: ASAuthorizationAppleIDButton.Style
  
  // Return an Auth Button
  func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
    ASAuthorizationAppleIDButton(type: type, style: style)
  }
  
  func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {}
}
extension UIViewController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    self.view.window!
  }
}


// MARK: - ERROR
enum SignInWithAppleError: LocalizedError {
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
