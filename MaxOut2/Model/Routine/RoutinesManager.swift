
import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class RoutinesManager {
  static let shared = RoutinesManager()
  private var userRoutinesListener: ListenerRegistration? = nil // ??
  
  private init() { }
  
  /// Useful shortcuts
  private func userRoutinesCollection(userId: String) -> CollectionReference {
    FitUserManager.shared
      .userDocument(id: userId)
      .collection(K.routinesCollectionName)
  }
  private func routineDocument(routineId: String, userId: String) -> DocumentReference {
    userRoutinesCollection(userId: userId)
      .document(routineId)
  }
}


extension RoutinesManager {
  func addToRoutines(routine: Routine, for userId: String) async throws { /// 🧵⚾️
    var sessionsPaths: [[String: Any]] = [] // Create paths to each sessions
    for sessionsPath in routine.sessionsPaths {
      let dict: [String: Any] = [ 
        "exerciseId": sessionsPath.exerciseId,
        "sessionId": sessionsPath.sessionId
      ]
      sessionsPaths.append(dict)
    }
    
    let fields: [String: Any] = [ // Set the fields manually
      "id"            : routine.id,
      "sessionsPaths" : sessionsPaths,
      "title"         : routine.title,
      "dateStarted"   : routine.dateStarted,
      "dateEnded"     : routine.dateEnded ?? Date(),
      "duration"      : routine.duration,
      "activityType"  : routine.activityType
    ]
    
    try await routineDocument(routineId: routine.id, userId: userId) /// 🧵🥎
      .setData(fields) // SET DATA
  }
  
  func routines(for userId: String) async throws -> [Routine] { /// 🧵⚾️
    try await userRoutinesCollection(userId: userId) /// 🧵🥎
      .getDocuments(as: Routine.self)
  }
  
  func workouts(for userId: String) async throws -> [Workout] {
    var workouts = [Workout]()
    
    let routines = try await self.routines(for: userId)
    
    
    for routine in routines { 
      /// For each routine create a session array
      var sessions = [Session]()
      for sessionPath in routine.sessionsPaths {
        let session = try await SessionsManager.shared.session(id: sessionPath.sessionId,
                                                     exerciseId: sessionPath.exerciseId,
                                                     userId: userId)
        sessions.append(session)
      }
      
      let workout = Workout(routine: routine, sessions: sessions)
      workouts.append(workout)
    }
    
    return workouts
  }
  
  func delete(routineId id: String, for userId: String) async throws { /// 🧵⚾️
    try await routineDocument(routineId: id, userId: userId).delete() /// 🧵🥎
  }
}


/// MARK: - Listener in "exercises"
//extension RoutinesManager {
//  func addListenerToRoutines(for userId: String) -> AnyPublisher<[Routine], Error> {
//    let (publisher, listener) = userRoutinesCollection(userId: userId)
//      .addSnaphotListener(as: Routine.self)
//    // now this is super reusable, just need to put any query and boom!
//    print("Added Listener")
//
//    userRoutinesListener = listener
//    return publisher
//  }
//
//  func removeListenerFromRoutines() {
//    self.userRoutinesListener?.remove()
//  }
//}
