import SwiftUI

struct CreateAccountView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = CreateAccountViewModel()
  @ObservedObject var manager = LoginTextFieldsManager()
  
  @Binding var showingLoginView: Bool
  
  let progressText = "Fetching exercises"
  
  var body: some View {
    ZStack {
      NavigationStack {
        ScrollView {
          VStack {
            LoginTextFieldsView(model: manager, resetPassword: false, withConfirmation: true, buttonText: K.Strings.signUpWithEmail, buttonColor: .accentColor, withUsername: true) { createNewUser() } /// 🪡🧤
            Spacer()
          }
        }
        .navigationTitle(K.Strings.createAccount)
        .padding()
        .toolbar {
          ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
          ToolbarItem(placement: .navigationBarLeading) { dismissButton }
        }
      }
      .loginAnimation(model.isShowingProgressView)
      
      if model.isShowingProgressView {
        FrostedProgressView(text: progressText)
      }
    }
  }
}

extension CreateAccountView {
  @ViewBuilder // MARK: - Dismiss xMark BUTTON
  private var dismissButton: some View {
    Button {
      dismiss()
    } label: {
      Image(systemName: "xmark.circle.fill")
        .foregroundColor(.gray)
    }
  }
  
  private func createNewUser() { /// 🪡🧤
    Task{
      do {
        guard !manager.confirmPassword.isEmpty else { /// Check the last textfield is not empty
          manager.errorMessage = "Please confirm your password"///
          return
        }
        manager.validate(withConfirmation: true) /// Validate info
        
        model.isShowingProgressView = true
        
        try await model.createUser(email: manager.email,
                                   password: manager.password,
                                   username: manager.username) /// 🧵🥎
        
        if model.authResult != nil { showingLoginView = false }
      } catch { /// 🧤
        model.isShowingProgressView = false
        manager.errorMessage = "The email address is already in use by another account"
      }
    }
  }
}

struct SignInWithEmailView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      CreateAccountView(showingLoginView: .constant(true))
    }
  }
}


