import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @StateObject private var model = LoginViewModel()
  @ObservedObject var manager = TSTextFieldsManager()
  @FocusState private var focus: Field?
  
  @Binding var showingLoginView: Bool
  
  let background = LinearGradient(colors: [
    Color.gray,
    Color.systemBackground
  ], startPoint: .topLeading, endPoint: .bottomTrailing)
  
  var body: some View {
    ZStack {
      VStack {
        ParallaxScrollView(background: background, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 300) {
          mainLoginInterface
            .loginAnimation(model.isShowingProgressView)
        } header: { header }
          .edgesIgnoringSafeArea(.bottom)
        
//        createAccountFooter
      }
      
      
      if model.isShowingProgressView {
        FrostedProgressView(text: "Fetching exercises")
      }
    }
    .resignKeyboardOnDragGesture()
    .onTapGesture { focus = nil }
//    .edgesIgnoringSafeArea(.bottom)
    .toolbar {
      ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
    }
    .sheet(isPresented: $model.showingCreateAccountView) {
      CreateAccountView(showingLoginView: $showingLoginView)
    }
  }
}

extension LoginView {
  
  @ViewBuilder // MARK: - HEADER
  private var header: some View {
    Text("Welcome")
      .font(.largeTitle.bold())
      .shadow(color: .systemBackground, radius: 10)
  }
  
  @ViewBuilder // MARK: - MAIN
  private var mainLoginInterface: some View {
    VStack(spacing: 8) {
      // SIw/ EMAIL
      TSTextFieldsView(model: manager,
                       resetPassword: true,
                       withConfirmation: false,
                       buttonText: "Log In",
                       buttonColor: .accentColor) { signInWithEmail() } /// 🪡🧤
      
      customSpacer
      
      // SIw/ APPLE
      SignInWithAppleButton { signInWithApple() } /// 🪡🧤
      
      // SIw/ GOOGLE
      SignInWithGoogleButton { signInWithGoogle() } /// 🪡🧤
        .padding(.bottom, 12)
      
      createAccountFooter
    }
  }
  
  @ViewBuilder // MARK: - Create New Account
  private var createAccountFooter: some View {
    VStack {
      Divider()
      Text("New around here?")
      Button(K.createAccount) {
        model.showingCreateAccountView = true
      }
    }
    .font(.subheadline)
    .padding(.bottom, 5)
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
}

extension LoginView {
  // MARK: - Sign In With
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
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      LoginView(showingLoginView: .constant(true))
    }
  }
}
