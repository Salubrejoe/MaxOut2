import SwiftUI

struct TSTextFieldsView: View {
  @FocusState private var focus    : Field?
  @StateObject var model           = TSTextFieldsManager()
  @State private var recoveryEmail = ""
  
  let resetPassword    : Bool
  let withConfirmation : Bool
  let buttonText       : String
  let buttonColor      : Color
  var withUsername     : Bool = false
  let action           : () -> Void
  
  
  var body: some View {
    ZStack {
      VStack(spacing: 8) {
        
        /// Fields and Error
        textFieldsAndErrorMessage
        
        /// Reset Psw
        if resetPassword {
          Button {
              model.showingPswAlert = true
          } label: {
            Text(K.TextFieldValidation.passwordLost)
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        
        /// Main Button
        Button { action() } label: { buttonLabel }
        
      }
      .alert("😭 Forgot your Password?", isPresented: $model.showingPswAlert) { alert } /// Reset password action
      
      // MARK: - TEST
      .onAppear {
        model.email = K.emailTest
        model.password = K.passwordTest
        model.confirmPassword = K.passwordTest
      }
      
      /// Confirmation Popup
      popupInfoPanel(systemImage: "checkmark", text: "Email sent!", condition: model.showingEmailPasswordRecovery)
      popupInfoPanel(systemImage: "xmark", text: "Oops..email invalid", condition: model.showingEmailPasswordError)
    }//: ZStack
  }
}



extension TSTextFieldsView {
  
  
  @ViewBuilder // MARK: - MAIN BODY
  private var textFieldsAndErrorMessage: some View {
    //MARK: - ERROR Message
    if !model.errorMessage.isEmpty {
      Text(model.errorMessage)
        .foregroundColor(.red)
        .font(.caption)
    }
    
    //MARK: - USERNAME
    if withUsername {
      TSTextField(text: $model.username, field: .username, isSecure: false) {
        // TODO: Validate
        focus = withUsername ? .newEmail : .email
      } xMarkAction: {
        model.username = ""
        focus = .username
      }
        .focused($focus, equals: .username)
    }
    
    //MARK: - EMAIL
    TSTextField(text: $model.email, field: withUsername ? .newEmail : .email, isSecure: false) {
      model.validate(withConfirmation: true)
      focus = withConfirmation ? .newPassword : .password
    } xMarkAction: {
      model.email = ""
      focus = withUsername ? .newEmail : .email
      model.errorMessage = ""
    }
      .focused($focus, equals: withUsername ? .newEmail : .email)
    
    //MARK: - PASSWORD
    TSTextField(text: $model.password, field: withConfirmation ? .newPassword : .password, isSecure: true) {
      model.validate(withConfirmation: true)
      focus = withConfirmation ? .confirmPassword : nil
    } xMarkAction: {
      model.password = ""
      focus = withConfirmation ? .newPassword : .password
      model.errorMessage = ""
    }
      .focused($focus, equals: withConfirmation ? .newPassword : .password)
    
    //MARK: - Confirm PASSWORD
    if withConfirmation {
      TSTextField(text: $model.confirmPassword, field: .confirmPassword, isSecure: true) {
        model.validate(withConfirmation: true)
        focus = nil
      } xMarkAction: {
        model.confirmPassword = ""
        focus = .confirmPassword
        model.errorMessage = ""
      }
      .focused($focus, equals: .confirmPassword)
    }
  }
  
  @ViewBuilder //MARK: - BUTTON Label
  private var buttonLabel: some View {
    Text(buttonText)
      .buttonLabel(background: .accentColor, foreground: .systemBackground)
  }
  
  @ViewBuilder //MARK: - PASSW RECOVERY ALERT
  private var alert: some View {
    TSTextField(text: $recoveryEmail, field: .email, isSecure: false) { } xMarkAction: { }
    
    Button("Send Email", action: {
      model.showingPswAlert = false
      if model.isValidEmail(recoveryEmail) {
        model.sendPasswordReset(to: recoveryEmail)
        withAnimation {
          model.showingEmailPasswordRecovery = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          withAnimation {
            model.showingEmailPasswordRecovery = false
          }
        }
      }
      else {
        model.sendPasswordReset(to: recoveryEmail)
        withAnimation {
          model.showingEmailPasswordError = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
          withAnimation {
            model.showingEmailPasswordError = false
          }
        }
      }
    })
    Button("Cancel", role: .cancel, action: { model.showingPswAlert = false })
  }
  
  
  // MARK: - POPUP INFO PANEL
  private func popupInfoPanel(systemImage: String, text: String, condition: Bool) -> some View {
    VStack {
      Image(systemName: systemImage)
        .resizable()
        .padding()
        .scaledToFit()
        .opacity(0.5)
      
      Text(text)
        .font(.headline)
        .opacity(0.5)
    }
    .padding()
    .frame(width: 200, height: 200)
    .background(.ultraThinMaterial)
    .cornerRadius(20)
    .opacity(condition ? 1 : 0)
    .scaleEffect(condition ? 1 : 0)
    .animation(.spring(), value: condition)
  }
}


struct AuthFieldsView_Previews: PreviewProvider {
  static var previews: some View {
    TSTextFieldsView(model: TSTextFieldsManager(), resetPassword: true, withConfirmation: true, buttonText: "Button Text", buttonColor: .blue, withUsername: false) { }
  }
}
