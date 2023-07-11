import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
  @StateObject private var model = LoginViewModel()
  @ObservedObject var manager = TSTextFieldsManager()
  @FocusState private var focus: Field?
  
  @Binding var showingLoginView: Bool
  
  var body: some View {
    ZStack {
      VStack {
        loginOptions
        createAccountFooter
      }
      .loginAnimation(model.isShowingProgressView)
      
      if model.isShowingProgressView {
        FrostedProgressView(text: "Fetching exercises")
      }
    }
    .resignKeyboardOnDragGesture()
    .onTapGesture { focus = nil }
    .navigationTitle("〄 Welcome")
    .padding()
    .toolbar() {
      ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
    }
    .sheet(isPresented: $model.showingCreateAccountView) {
      CreateAccountView(showingLoginView: $showingLoginView)
    }
  }
}

extension LoginView {
  // MARK: - PROPERTIES/COMPONENTS
  
  @ViewBuilder
  private var loginOptions: some View {
    
      ScrollView(showsIndicators: false) {
        VStack(spacing: 8) {
          // MARK: - SIw/ EMAIL
          TSTextFieldsView(model: manager,
                           resetPassword: true,
                           withConfirmation: false,
                           buttonText: "Log In",
                           buttonColor: .accentColor) { signInWithEmail() } /// 🪡🧤
            
          customSpacer
          
          // MARK: - SIw/ APPLE
          SignInWithAppleButton { signInWithApple() } /// 🪡🧤
          
          // MARK: - SIw/ GOOGLE
          SignInWithGoogleButton { signInWithGoogle() } /// 🪡🧤
        }
      }
  }
  
  @ViewBuilder // MARK: - Create New Account
  private var createAccountFooter: some View {
    Divider()
    Text("New around here?")
    Button(K.createAccount) {
      model.showingCreateAccountView = true
    }
  }
  
  
  @ViewBuilder // MARK: - Custom Spacer
  private var customSpacer: some View {
    HStack {
      Rectangle()
        .frame(height: 1)
        .frame(width: 100)
        .foregroundColor(.secondary)
      Text("OR")
        .foregroundColor(.secondary)
        .font(.subheadline)
      Rectangle()
        .frame(height: 1)
        .frame(width: 100)
        .foregroundColor(.secondary)
    }
  }
} // MARK: - PROPERTIES/COMPONENTS

extension LoginView {
  // MARK: - METHODS

  private func signInWithEmail() { /// 🪡🧤
    Task {
      do {
        try await model.signIn(email: manager.email,
                                   password: manager.password) /// 🧵🥎
        showingLoginView = false
      } catch { /// 🧤
        manager.errorMessage = K.TextFieldValidation.ErrorMessage.incorrectInfo
        model.isShowingProgressView = false
      }
    }//: Task
  }
  private func signInWithGoogle() { /// 🪡🧤
    Task {
      do {
        try await model.signInWithGoogle() /// 🧵🥎
        showingLoginView = false
      } catch { /// 🧤
        print("Error with Google Sign In: \(error)")
        manager.errorMessage = K.TextFieldValidation.ErrorMessage.somethingWentWrong
        model.isShowingProgressView = false
      }
    }
  }
  private func signInWithApple() { /// 🪡🧤
    Task {
      do {
        try await model.signInWithApple() /// 🧵🥎
        showingLoginView = false
      } catch { /// 🧤
        print("Error with Apple Sign In: \(error)")
        manager.errorMessage = K.TextFieldValidation.ErrorMessage.somethingWentWrong
        model.isShowingProgressView = false
      }
    }
  }
} // MARK: - TASKS

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      LoginView(showingLoginView: .constant(true))
    }
  }
}
