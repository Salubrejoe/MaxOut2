import SwiftUI
import Combine
import BottomSheet


final class StartViewModel: ObservableObject {
  @Published var fitUser: FitUser = FitUser.mockup
  @Published var routine: Routine? = nil
  @Published var sessions = [Session]()
  
  var startDate = Date()
  
  /// Rest Time
  @Published var restTime = 60.0
  
  /// Bottom Sheet
  @Published var inProgress = false
  @Published var position = BottomSheetPosition.relative(0.93)
  let switchablePositions: [BottomSheetPosition] = [.absoluteBottom(180), .relative(0.93)]
  
  /// Login Bool
  @Published var showingLoginView = false
 
  /// Grid element
  let columns = [GridItem(.adaptive(minimum: 155))]
  let largeColumns = [GridItem(.adaptive(minimum: 300))]
  
  /// Cancel Alert
  @Published var showingCancelAlert = false
  let alertText = "Are you sure you want to discard your progress?"

  /// Error Message
  @Published var errorMessage: String? = nil
  @Published var isShowingeErrorAlert = false
  
  /// Exercise Picker bool
  @Published var isShowingPicker = false

  @Published var controller = GaugeViewController()

  
  // MARK: - USER
  @MainActor
  func loadCurrentUser() async throws { /// 🧵⚾️
    let authDataResult = try FireAuthManager.shared.currentAuthenticatedUser() /// 🥎
    self.fitUser = try await FitUserManager.shared.user(id: authDataResult.uid) /// 🧵🥎
  }
  
  func checkCurrentUser() {
    let user = try? FireAuthManager.shared.currentAuthenticatedUser()
    self.showingLoginView = user == nil
  }
  
  
  
  // MARK: - ROUTINE START/CANCEL
  func startRoutine() {
    routine = Routine()
    startDate = Date()
  }
  
  func cancelRoutine() {
    sessions = []
    routine = nil
    startDate = Date()
  }
  
  // MARK: - REMOVE SESSION
  func remove(_ session: Session) {
    guard let index = sessions.firstIndex(of: session) else {
      print("No session named like that")
      return
    }
    sessions.remove(at: index)
  }
  
}


// MARK: - SAVE
extension StartViewModel {
  func saveTask() {
    Task {
      do {
        try await save(routine)
      }
      catch {
        errorMessage = "Error in startViewModel.save(routine:) : \n \(error.localizedDescription)"
      }
    }
  }
  
  @MainActor
  func save(_ routine: Routine?) async throws {
    let userId = try userId()
    guard let routine else { throw URLError(.cannotCloseFile) }
    let dateStarted = routine.dateStarted.timeIntervalSince1970
    let dateEnded = Date().timeIntervalSince1970
    let duration = (dateEnded - dateStarted).rounded()
    var sessionPaths = [SessionPath]()
    var bobs = [Bob]()
    
    for session in sessions {
      for bob in session.bobs {
        if bob.isCompleted {
          let newBob = Bob(bob: bob)
          bobs.append(newBob)
        }
      }
      
      let newSession = Session(id: "",
                               exerciseId: session.exerciseId,
                               exerciseName: session.exerciseName,
                               dateCreated: Date(timeIntervalSince1970: dateStarted),
                               activityType: session.activityType,
                               bobs: bobs,
                               image: session.image)
      bobs = []
      
      let sessionId = try await SessionsManager.shared.addToSessions(session: newSession, userId: userId)
      let sessionPath = SessionPath(exerciseId: session.exerciseId, sessionId: sessionId)
      sessionPaths.append(sessionPath)
    }
    
    let newRoutine = Routine(sessionsPaths: sessionPaths,
                             dateEnded: Date(timeIntervalSince1970: dateEnded),
                             dateStarted: Date(timeIntervalSince1970: dateStarted),
                             duration: duration)
    try? await RoutinesManager.shared.addToRoutines(routine: newRoutine , for: userId)
    cancelRoutine()
  }
  
  private func userId() throws -> String {
    guard let userId = try? FireAuthManager.shared.currentAuthenticatedUser().uid  else {
      isShowingeErrorAlert = true
      errorMessage = "No userId"
      throw URLError(.userAuthenticationRequired)
    }
    return userId
  }
}


