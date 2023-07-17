import SwiftUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var model: DiaryViewModel
  @Binding var showingLoginView: Bool
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        List {
          namesSection
          
          datePicker
           
          measuresSection

          emailSection
          
          logoutSection
        }
        .listStyle(.grouped)
        .scrollDismissesKeyboard(.immediately)
        
        LargeTsButton(text: "Save", background: Color.accentColor, textColor: .systemBackground) {
          model.update(user: model.user)
          dismiss()
        }
        .padding()
      }
      .navigationTitle("Profile")
      .onFirstAppear { model.loadAuthProviders() }
    }
  }
}

extension ProfileView {
  
  @ViewBuilder // MARK: - Date Picker
  private var datePicker: some View {
    DatePicker("Date of birth", selection: Binding<Date>(get: {model.user.dateOfBirth ?? Date()}, set: {model.user.dateOfBirth = $0}),
               displayedComponents: .date)
    .datePickerStyle(.compact)
  }
  
  
  @ViewBuilder // MARK: - Email SECTION
  private var emailSection: some View {
    Section {
      HStack {
        Text("Email")
          .minimumScaleFactor(0.7)
        Spacer()
        Text(model.user.email ?? "no email")
          .foregroundColor(.secondary)
      }
    }
  }
  
  
  @ViewBuilder // MARK: - Names SECTION
  private var namesSection: some View {
    Section {
      HStack {
        Text("First Name")
        Spacer()
        TextField("", text: $model.user.firstName.bound)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
        
      }
      
      HStack {
        Text("Nickname")
        Spacer()
        TextField("", text: $model.user.username.bound)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
      }
      
      HStack {
        Text("Last Name")
        Spacer()
        TextField("", text: $model.user.lastName.bound)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
      }
    }
  }
  
  
  @ViewBuilder // MARK: - Measures SECTION
  private var measuresSection: some View {
    HStack {
      Text("Height(cm)")
      Spacer()
      TextField("cm", text: $model.height)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
        .numbersOnly($model.height)
        .onChange(of: model.height) { newValue in
          model.user.height = newValue
        }
    }
    
    HStack {
      Text("Weight(kg)")
      Spacer()
      TextField("kg", text: $model.weight)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.trailing)
        .numbersOnly($model.weight)
        .onChange(of: model.weight) { newValue in
          model.user.weight = newValue
        }
    }
  }
  
  
  @ViewBuilder // MARK: - LogOut SECTION
  private var logoutSection: some View {
    Section {
      if model.authProviders.contains(.email) {
        Button("Reset Password") {
          Task {
            try? await model.resetPassword()
          }
        }
      }
      
      Button("Log Out") {
        Task {
          do {
            try model.signOut()
            showingLoginView = true
            dismiss()
          } catch {
            print("Troubles signin out: \(error)")
          }
        }
      }
      
      /// Delete account
      Button("Delete your account", role: .destructive) {
        Task {
          do {
            try await model.deleteAccount()
            showingLoginView = true
          } catch {
            print("Troubles deleting account out: \(error)")
          }
        }
      }
    }
  }
}
