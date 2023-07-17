import SwiftUI

struct ProfileView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = SettingsViewModel()
  @Binding var showingLoginView: Bool
  @FocusState private var focus: Field?
  @Binding var fitUser: FitUser
  
  var body: some View {
    NavigationStack {
      VStack {
        List {
          Section("Username") {
            TextField("Username", text: $fitUser.username.bound)
              .focused($focus, equals: .username)
              .onSubmit {
                focus = .firstName
              }
          }
          Section("First Name") {
            TextField("First Name", text: $fitUser.firstName.bound)
              .focused($focus, equals: .firstName)
              .onSubmit {
                focus = .lastName
              }
          }
          Section("Last Name") {
            TextField("Last Name", text: $fitUser.lastName.bound)
              .focused($focus, equals: .lastName)
              .onSubmit {
                focus = nil
              }
          }
           
          Section("Email") {
            Text(fitUser.email ?? "Email Address")
              .foregroundColor(.gray)
          }
          
          Section("Member Since") {
            Text(fitUser.dateCreatedShortString)
              .foregroundColor(.gray)
          }
          
          /// Log Out
          Section {
            if model.authProviders.contains(.email) {
              Button("Reset Password") {
                model.isShowingPassResetAlert = true
              }
            }
            
            Button("Log Out") {
              Task {
                do {
                  try model.signOut()
                  showingLoginView = true
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
          } header: {
            Text("")
          }
        }
        .listStyle(.insetGrouped)
      }
      .navigationTitle("Profile")
      .onFirstAppear { model.loadAuthProviders() }
//      .task { try? await model.loadCurrentUser() }
      .navigationTitle("You").navigationBarTitleDisplayMode(.inline)
      .toolbar { save }
    }
  }
  
  @ViewBuilder
  private var save: some View {
    Button("Save") {
      Task {
        do {
          try FitUserManager.shared.update(user: fitUser)
        }
        catch {
          print("Error updating \(fitUser)")
        }
      }
      dismiss()
    }
  }
  
  private func resetPassword() {
    Task {
      do {
        try await model.resetPassword()
      } catch {
        print("Troubles signin out: \(error)")
      }
    }
  }
  
  
}
//
//
//
//@MainActor
//final class ProfileViewModel: ObservableObject {
//  func update(_ user: FitUser) {
//    try? FitUserManager.shared.update(user: user)
//  }
//}
