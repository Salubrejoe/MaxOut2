import SwiftUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  @ObservedObject var model: DiaryViewModel
  @EnvironmentObject var manager: HealthKitManager
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
        .listStyle(.automatic)
        .scrollDismissesKeyboard(.immediately)
        
        LargeTsButton(text: "Save", background: Color.accentColor, textColor: .systemBackground) {
          model.update(user: model.user)
          dismiss()
        }
        .padding()
      }
      .navigationTitle("Profile")
      .onFirstAppear { model.loadAuthProviders() }
      .onAppear {
        UITextField.appearance().clearButtonMode = .whileEditing
      }
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
        TextField("", text: $model.firstName)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
          .onChange(of: model.firstName) { _ in
            model.updateUser()
          }
      }
      
      HStack {
        Text("Nickname")
        Spacer()
        TextField("", text: $model.username)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
          .onChange(of: model.username) { _ in
            model.updateUser()
          }
      }
      
      HStack {
        Text("Last Name")
        Spacer()
        TextField("", text: $model.lastName)
          .foregroundColor(.secondary)
          .multilineTextAlignment(.trailing)
          .onChange(of: model.lastName) { _ in
            model.updateUser()
          }
      }
    }
  }
  
  
  @ViewBuilder // MARK: - Measures SECTION
  private var measuresSection: some View {
    Group {
      HStack {
        Text("Height")
        Spacer()
        Text("\(manager.heightStats.last?.heightString ?? "") m")
      }
      
      HStack {
        Text("Weight")
        Spacer()
        Text("\(manager.bodyMassStats.last?.weightString ?? "") kg")
      }
    }
    .foregroundColor(.secondary)
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
