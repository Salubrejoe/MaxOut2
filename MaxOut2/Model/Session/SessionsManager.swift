
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class SessionsManager {
  static let shared = SessionsManager()
  private var sessionsListener: ListenerRegistration? = nil
  
  private init() { }
  
  /// Useful shortcuts
  private func exerciseSessionsCollection(exerciseId: String, userId: String) -> CollectionReference {
    ExercisesManager.shared
      .exerciseDocument(exerciseId: exerciseId, userId: userId)
      .collection(K.CollectionNames.sessions)
  }
  private func sessionDocument(sessionId: String, exerciseId: String, userId: String) -> DocumentReference {
    exerciseSessionsCollection(exerciseId: exerciseId, userId: userId)
      .document(sessionId)
  }
}

extension SessionsManager {
  /// Pass in a Session(),
  /// create a dictionary/document to save to the 'sessions' collection of the current Exercise
  func addToSessions(session: Session, userId: String) async throws -> String { /// 🧵⚾️
  
    let document = exerciseSessionsCollection(exerciseId: session.exerciseId, userId: userId).document()
    let documentId = document.documentID
    
    var bobs: [[String: Any]] = []
    for bob in session.bobs {
      let dict: [String: Any] = [
        Bob.CodingKeys.id.rawValue          : bob.id,
        Bob.CodingKeys.kg.rawValue          : bob.kg,
        Bob.CodingKeys.reps.rawValue        : bob.reps,
        Bob.CodingKeys.duration.rawValue    : bob.duration,
        Bob.CodingKeys.distance.rawValue    : bob.distance,
        Bob.CodingKeys.isCompleted.rawValue : bob.isCompleted,
        Bob.CodingKeys.restTime.rawValue    : bob.restTime,
      ]
      bobs.append(dict)
    }
    
    let fields: [String: Any] = [
      Session.CodingKeys.id.rawValue           : documentId,
      Session.CodingKeys.exerciseName.rawValue : session.exerciseName,
      Session.CodingKeys.exerciseId.rawValue   : session.exerciseId,
      Session.CodingKeys.dateCreated.rawValue  : Date(),
      Session.CodingKeys.activityType.rawValue : session.activityType,
      Session.CodingKeys.bobs.rawValue         : bobs,
      Session.CodingKeys.image.rawValue        : session.image
    ]
   
    try await exerciseSessionsCollection(exerciseId: session.exerciseId, userId: userId)
      .document(documentId)
      .setData(fields, merge: false)/// 🧵🥎
    ///
    return documentId
  }
  
  
//  func getColor(with session: Session) async throws  -> Color {
//    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
//    let exercise = try await ExercisesManager.shared.exerciseDocument(exerciseId: session.exerciseId, userId: userId).getDocument(as: Exercise.self)
//    return exercise.color
//  }
  
  
  /// Finds and returns the Last Session for a given exercise.
  func lastSession(exerciseId: String, userId: String) async throws -> Session { /// 🧵⚾️
    let collection = exerciseSessionsCollection(exerciseId: exerciseId, userId: userId)
      .order(by: "dateCreated", descending: true)
      .limit(to: 1)
    
    let snapshot = try await collection.getDocuments() /// 🧵🥎
    guard let document = snapshot.documents.first else { throw URLError(.fileDoesNotExist) }
    
    let session = try await document.reference.getDocument(as: Session.self) /// 🧵🥎
    
    return session
  }
  
  
  func session(id: String, exerciseId: String, userId: String) async throws -> Session { /// 🧵⚾️
    try await exerciseSessionsCollection(exerciseId: exerciseId, userId: userId)
      .document(id)
      .getDocument(as: Session.self) /// 🧵🥎
  }
}
