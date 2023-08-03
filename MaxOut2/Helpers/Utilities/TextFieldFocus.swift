
import UIKit

// MARK: - TEXT FIELDS FOCUS
enum Field: String, Hashable {
  case email, password, name, amount, username, firstName, lastName, confirmPassword, newEmail, newPassword, muscleGroup, equipment
  
  var stringValue: String {
    switch self {
      case .email:
        return "Email"
      case .password:
        return "Password"
      case .name:
        return "Name"
      case .amount:
        return "Amount"
      case .username:
        return "Username"
      case .firstName:
        return "First Name"
      case .lastName:
        return "Last Name"
      case .confirmPassword:
        return "Confirm Password"
      case .newEmail:
        return "New Email"
      case .newPassword:
        return "New Password"
      case .muscleGroup:
        return "Muscle Group"
      case .equipment:
        return "Equipment"
    }
  }
  
  static func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

