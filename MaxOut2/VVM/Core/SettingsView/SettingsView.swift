import SwiftUI

struct SettingsView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = SettingsViewModel()
  @Binding var showingLoginView: Bool
  @FocusState private var focus: Field?
  @Binding var fitUser: FitUser
  
  var body: some View {
    NavigationStack {
      VStack {
        
        Group {
          if let photoUrl = fitUser.photoUrl {
            AsyncImage(url: URL(string: photoUrl))
              .frame(width: 100, height: 100)
              .cornerRadius(12)
          } else {
            Image(systemName: "person.circle")
              .resizable()
              .scaledToFit()
              .frame(width: 100, height: 100)
          }
        }
        .padding(.vertical)
        
        List {
          Section{
            ZStack(alignment: .trailing) {
              TextField("Username", text: $fitUser.username.bound)
                .focused($focus, equals: .username)
                .onSubmit {
                  focus = .firstName
                }
              XMarkButton {
                fitUser.username = ""
                focus = .username
              }
            }
          } header: {
            Text("Username")
          }
          Section{
            ZStack(alignment: .trailing) {
              TextField("First Name", text: $fitUser.firstName.bound)
                .focused($focus, equals: .firstName)
                .onSubmit {
                  focus = .lastName
                }
              XMarkButton {
                fitUser.firstName = ""
                focus = .firstName
              }
            }
          } header: {
            Text("First Name")
          }
          Section{
            ZStack(alignment: .trailing) {
              TextField("Last Name", text: $fitUser.lastName.bound)
                .focused($focus, equals: .lastName)
                .onSubmit {
                  focus = nil
                }
              XMarkButton {
                fitUser.lastName = ""
                focus = .lastName
              }
            }
          } header: {
            Text("Last Name")
          }
          Section {
            Text(fitUser.email ?? "Email Address")
              .foregroundColor(.secondary)
          } header: {
            Text("Email")
          }
          Section {
            Text(fitUser.dateCreatedShortString)
              .foregroundColor(.secondary)
          } header: {
            Text("Member Since")
          }
          /// Log Out
          Section {
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
        .listStyle(.plain)
      }
      .navigationTitle("Settings")
      .onFirstAppear {
        model.loadAuthProviders()
      }
      .task { try? await model.loadCurrentUser() }
      .resignKeyboardOnDragGesture()
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
}



@MainActor
final class ProfileViewModel: ObservableObject {
  func update(_ user: FitUser) {
    try? FitUserManager.shared.update(user: user)
  }
}
