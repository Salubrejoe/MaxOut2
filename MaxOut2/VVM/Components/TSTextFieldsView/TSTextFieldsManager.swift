import Foundation

@MainActor
class TSTextFieldsManager: ObservableObject {
  @Published var username                     = String()
  @Published var email                        = String()
  @Published var password                     = String()
  @Published var confirmPassword              = String()
  @Published var errorMessage                 = String()
  
  /// Password recovery alert Bools
  @Published var showingPswAlert              = false
  @Published var showingEmailPasswordRecovery = false
  @Published var showingEmailPasswordError    = false
  
  
  
  /// Password Reset
  func sendPasswordReset(to email: String) {
    Task {
      do {
        try await FireAuthManager.shared.sendPasswordReset(to: email)
      } catch {
        print("Error resetting password: \(error)")
      }
    }
  }
}

/// Email Validation
extension TSTextFieldsManager {
  
  func validate(withConfirmation: Bool) {
    guard isValidEmail(email) else {
      self.errorMessage = K.TextFieldValidation.ErrorMessage.invalidEmail
      return
    }
    
//    guard isValidPassword(password) else {
//      self.errorMessage = K.TextFieldValidation.ErrorMessage.passwordRequirments
//      //      DispatchQueue.main.async { [weak self] in
//      //
//      //      }
//      return
//    }
    
    if withConfirmation {
      guard confirmPassword == password else {
        self.errorMessage = "The passwords need to be the same"
        return
      }
    }
  }
  
  func isValidEmail(_ email: String) -> Bool {
    let emailRegex = K.TextFieldValidation.emailRegex
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
  }
  
  func isValidPassword(_ password: String) -> Bool {
    let passwordRegex = K.TextFieldValidation.passwordRegex
    let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
    return passwordPredicate.evaluate(with: password)
  }
}
