import SwiftUI
import Combine
import BottomSheet
import HealthKit

final class StartViewModel: ObservableObject {
  @Published var fitUser: FitUser = FitUser.mockup
  @Published var routine: Routine? = nil
  @Published var sessions = [Session]()
  
  var startDate = Date()

  
  /// Rest Time
  @Published var restTime = 60.0
  
  /// Bottom Sheet
  @Published var inProgress = false
  @Published var congratulationsScreen = false
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
  @Published var isShowingPicker = true

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
  
  
  
  // MARK: - ACTIVITY TYPE
  public func activityType() -> ActivityType {
    ActivityType(rawValue: routine?.activityType ?? "") ?? .walking
  }
  
  
  
  // MARK: - ROUTINE START/CANCEL
  func startRoutine(_ activityType: HKWorkoutActivityType) {
    routine = Routine(activityType: activityType.commonName)
    inProgress = true
    startDate = Date()
  }
  
  func cancelRoutine() {
    Task {
      await MainActor.run {
        inProgress = false
        sessions = []
        routine = nil
        startDate = Date()
      }
    }
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
  
  private func userId() throws -> String {
    guard let userId = try? FireAuthManager.shared.currentAuthenticatedUser().uid  else {
      isShowingeErrorAlert = true
      errorMessage = "No userId"
      throw URLError(.userAuthenticationRequired)
    }
    return userId
  }
}


// MARK: - GPT NEW SAVE
extension StartViewModel {
  func save(_ routine: Routine?) async throws {
    guard let routine = routine else {
      throw URLError(.cannotCloseFile)
    }
    
    let userId = try userId()
    let currentTime = Date().timeIntervalSince1970
    let sessionPaths = try await createSessionPaths(from: sessions, userId: userId, currentTime: currentTime)
    
    let newRoutine = Routine(
      sessionsPaths: sessionPaths,
      dateEnded: Date(timeIntervalSince1970: currentTime),
      dateStarted: routine.dateStarted,
      duration: currentTime - routine.dateStarted.timeIntervalSince1970,
      activityType: routine.activityType
    )
    
    try? await RoutinesManager.shared.addToRoutines(routine: newRoutine, for: userId)
    cancelRoutine()
  }
  
  func createSessionPaths(from sessions: [Session], userId: String, currentTime: TimeInterval) async throws -> [SessionPath] {
    var sessionPaths = [SessionPath]()
    
    for session in sessions {
      let completedBobs = session.bobs.filter { $0.isCompleted }
      let newBobs = completedBobs.map { Bob(bob: $0) }
      
      let newSession = Session(
        id: "",
        exerciseId: session.exerciseId,
        exerciseName: session.exerciseName,
        dateCreated: Date(timeIntervalSince1970: currentTime),
        activityType: session.activityType,
        bobs: newBobs,
        image: session.image
      )
      
      let sessionId = try await SessionsManager.shared.addToSessions(session: newSession, userId: userId)
      let sessionPath = SessionPath(exerciseId: session.exerciseId, sessionId: sessionId)
      sessionPaths.append(sessionPath)
      
      updateStats(for: session, userId: userId)
    }
    
    return sessionPaths
  }
  
  func updateStats(for session: Session, userId: String) {
    let now = Date()
    
    let bestVolumeDP  = [DataPoint(x: now, y: session.bestVolume)]
    let totalVolumeDP = [DataPoint(x: now, y: session.totalVolume)]
    let speedDP       = [DataPoint(x: now, y: session.averageKmPerHour)]
    let durationDP    = [DataPoint(x: now, y: session.totalDuration)]
    
    let stat = UserStat(exerciseId: session.exerciseId,
                        exerciseName: session.exerciseName,
                        activityType: session.activityType,
                        bestVolumeDP: bestVolumeDP,
                        totalVolumeDP: totalVolumeDP,
                        speedDP: speedDP,
                        durationDP: durationDP)
    
    Task {
      do {
        let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
        try await StatsManager.shared.addToStats(stat: stat, for: userId)
      }
      catch {
        print("Error UPDATING??: \n \(error)")
      }
    }
  }
}





//  @MainActor
//  func save(_ routine: Routine?) async throws {
//    let userId = try userId()
//    guard let routine else { throw URLError(.cannotCloseFile) }
//
//    let dateStarted = routine.dateStarted.timeIntervalSince1970
//    let dateEnded = Date().timeIntervalSince1970
//    let duration = (dateEnded - dateStarted).rounded()
//    var sessionPaths = [SessionPath]()
//    var bobs = [Bob]()
//
//    for session in sessions {
//      for bob in session.bobs {
//        if bob.isCompleted {
//          let newBob = Bob(bob: bob)
//          bobs.append(newBob)
//        }
//      }
//
//      let newSession = Session(id: "",
//                               exerciseId: session.exerciseId,
//                               exerciseName: session.exerciseName,
//                               dateCreated: Date(timeIntervalSince1970: dateStarted),
//                               activityType: session.activityType,
//                               bobs: bobs,
//                               image: session.image)
//      bobs = []
//
//      let sessionId = try await SessionsManager.shared.addToSessions(session: newSession, userId: userId)
//      let sessionPath = SessionPath(exerciseId: session.exerciseId, sessionId: sessionId)
//      sessionPaths.append(sessionPath)
//    }
//
//    let newRoutine = Routine(sessionsPaths: sessionPaths,
//                             dateEnded: Date(timeIntervalSince1970: dateEnded),
//                             dateStarted: Date(timeIntervalSince1970: dateStarted),
//                             duration: duration)
//    try? await RoutinesManager.shared.addToRoutines(routine: newRoutine , for: userId)
//    cancelRoutine()
//  }
