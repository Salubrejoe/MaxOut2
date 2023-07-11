import SwiftUI

struct CreateAccountView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = CreateAccountViewModel()
  @ObservedObject var manager = TSTextFieldsManager()
  @State private var showAlert = false
  
  @Binding var showingLoginView: Bool
  
  var body: some View {
    ZStack {
      NavigationStack {
        ScrollView {
          VStack {
            TSTextFieldsView(model: manager, resetPassword: false, withConfirmation: true, buttonText: K.signUpEmail, buttonColor: .accentColor, withUsername: true) { createNewUser() } /// 🪡🧤
            Spacer()
          }
        }
        .navigationTitle(K.createAccount)
        .padding()
        .toolbar() {
          ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
          ToolbarItem(placement: .navigationBarLeading) { dismissButton }
        }
      }
      .loginAnimation(model.isShowingProgressView)
      
      if model.isShowingProgressView {
        FrostedProgressView(text: "Fetching exercises")
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

struct FrostedProgressView: View {
  let text: String
  
  var body: some View {
    VStack {
      ProgressView()
        .frame(width: 50, height: 50)
        .imageScale(.large)
        .scaleEffect(2)
      
      Text(text)
    }
    .padding()
    .frame(width: 150, height: 150)
    .font(.headline)
    .foregroundColor(.secondary)
    .background(.ultraThinMaterial)
    .cornerRadius(20)
  }
}


