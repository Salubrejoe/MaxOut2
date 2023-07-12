
import Foundation


final class K {
  static let emailTest = "salubrejoe@gmail.com"
  static let passwordTest = "1Qaz0Okmlp?"
  
  static let usersCollectionName = "users"
  static let routinesCollectionName = "routines"
  static let exercisesCollectionName = "exercises"
  static let sessionsCollectionName = "sessions"
  static let workoutsCollectionName = "workouts"
  
  
  
  static let signUpEmail = "Sign Up with Email"
  static let createAccount = "Create an Account"
  static let addNewTrans = "Add New Expense"
  
  struct TextFieldValidation {
    static let passwordLost = "Forgot your password? Click here!"
    static let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9]).{8,}$"
        
    struct ErrorMessage {
      static let somethingWentWrong = "Sorry, something went horribly..try restarting the app!"
      static let incorrectInfo = "Incorrect info 🫤"
      static let invalidEmail = "Please enter a valid email."
      static let passwordRequirments = "The password needs to contain at least 6 characters, at least one Uppercased letter and one number."

    }
  }
}
