import Foundation
import FirebaseAuth

class AuthController: ObservableObject {
  @Published private(set) var user: AuthenticationResultModel?
  
  init() {
    self.user  = try? FireAuthManager.shared.currentAuthenticatedUser()
  }
  
  public var isLoggedIn: Bool {
    user != nil
  }
}

struct AuthenticationResultModel {
  let uid         : String
  let displayName : String?
  let email       : String?
  let photoURL    : String?
  
  init(user: User) {
    self.uid         = user.uid
    self.displayName = user.displayName
    self.email       = user.email
    self.photoURL    = user.photoURL?.absoluteString
  }
}
