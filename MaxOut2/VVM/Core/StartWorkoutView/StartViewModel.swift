import SwiftUI
import Combine


final class StartViewModel: ObservableObject {
  @Published var fitUser: FitUser = FitUser.mockup

  @Published var focusedBob: (Session, Int, Int)? = nil
  
  @Published var routine: Routine? = nil
  @Published var sessions = [Session]()
  
  /// KEYBOARD REFERENCE
  @Published var number = 0.0
  
  @Published var currentFocusedValue: Double?
  
  var startDate = Date()
  
  /// Rest Time
  @Published var restTime = 60.0
  
  
  /// Grid element
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  /// Cancel Alert
  @Published var showingCancelAlert = false
  let alertText = "Are you sure you want to discard your progress?"
  
  /// View State
  @Published var viewState: ViewState = .startButton
  
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
  
  
  // MARK: - Start/Cancel Routine
  func startRoutine() {
    routine = Routine()
    startDate = Date()
  }
  
  func cancelRoutine() {
    sessions = []
    routine = nil
    viewState = .startButton
    startDate = Date()
  }
  
  
  // MARK: - Remove session
  func remove(_ session: Session) {
    guard let index = sessions.firstIndex(of: session) else {
      print("No session named like that")
      return
    }
    sessions.remove(at: index)
  }
  
  
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
  
  
  // MARK: - Save Routine
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
//          let newBob = Bob(kg: bob.kg,
//                           reps: bob.reps,
//                           duration: bob.duration,
//                           distance: bob.distance,
//                           isCompleted: false,
//                           restTime: bob.restTime)
          let newBob = Bob(bob: bob)
          bobs.append(newBob)
        }
      }
      
      let newSession = Session(id: "",
                               exerciseId: session.exerciseId,
                               exerciseName: session.exerciseName,
                               dateCreated: Date(timeIntervalSince1970: dateStarted),
                               category: session.category,
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

// MARK: - View State Enum
extension StartViewModel {
  func stateTextString() -> String {
      switch viewState {
        case .startButton : return "New Workout"
        case .inProgress  : return routine?.title ?? ""
      }
  }
  
  enum ViewState {
    case inProgress, startButton
  }
}


