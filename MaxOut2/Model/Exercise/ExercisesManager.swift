import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ExercisesManager {
  static let shared = ExercisesManager()
  private init() { }
  
  /// Listener
  private var userExercisesListener: ListenerRegistration? = nil
  
  /// Useful shortcuts
  private func userExercisesCollection(userId: String) -> CollectionReference {
    FitUserManager.shared
      .userDocument(id: userId)
      .collection(K.exercisesCollectionName)
  }
  func exerciseDocument(exerciseId: String, userId: String) -> DocumentReference {
    userExercisesCollection(userId: userId)
      .document(exerciseId)
  }
}



// MARK: - Firestore Methods
extension ExercisesManager {
  
  /// Choose from all Template Exercises available,
  /// attach your choice as a dictionary to the 'exercises' collection of the current User
  func addToExercises(exercise: Exercise, for userId: String) async throws { /// 🧵⚾️
    
    /// Create a fresh documentID to pass to the dictionary to be able to add same exercise more than once
    let document = userExercisesCollection(userId: userId).document()
    let documentId = document.documentID
    
    
    /// Create a dictionary with all the same fields as the Exercise.Type
    let fields: [String: Any] = [
      Exercise.CodingKeys.id.rawValue                : documentId,
      Exercise.CodingKeys.dateModified.rawValue      : Date(),
      Exercise.CodingKeys.name.rawValue              : exercise.name,
      Exercise.CodingKeys.primaryMuscles.rawValue    : exercise.primaryMuscles,
      Exercise.CodingKeys.equipment.rawValue         : exercise.equipment ?? "",
      Exercise.CodingKeys.category.rawValue          : exercise.category,
      Exercise.CodingKeys.activity.rawValue          : exercise.activity,
      Exercise.CodingKeys.instructions.rawValue      : exercise.instructions,
    ]
    
    try await document /// 🧵🥎
      .setData(fields) // SET DATA
  }
  
  
  func save(exercise: Exercise, userId: String) throws { /// ⚾️
    try exerciseDocument(exerciseId: exercise.id, userId: userId) /// 🥎
      .setData(from: exercise, merge: false)
  }
  
  func update(exercise: Exercise) throws { /// ⚾️
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
    try exerciseDocument(exerciseId: exercise.id, userId: userId) /// 🥎
      .setData(from: exercise, merge: true)
  }
  
  
  func delete(exerciseId id: String, for userId: String) async throws { /// 🧵⚾️
    try await exerciseDocument(exerciseId: id, userId: userId).delete() /// 🧵🥎
  }
  
  
  func getExercises(with userId: String) async throws -> [Exercise] { /// 🧵⚾️
    try await userExercisesCollection(userId: userId).getDocuments(as: Exercise.self) /// 🧵🥎
  }
  
  
//  func filteredExercises(userId: String, searchText: String) async throws -> [Exercise] { /// 🧵⚾️
//    try await userExercisesCollection(userId: userId) /// 🧵🥎
//      .whereField(Exercise.CodingKeys.keywordsForLookup.rawValue, arrayContains: searchText.lowercased())
//      .getDocuments(as: Exercise.self)
//  }
}







// MARK: - Listener in "exercises"
extension ExercisesManager {
  func addListenerToExercises(for userId: String) -> AnyPublisher<[Exercise], Error> {
    let (publisher, listener) = userExercisesCollection(userId: userId)
      .addSnaphotListener(as: Exercise.self)
    // now this is super reusable, just need to put any query and boom!
    userExercisesListener = listener
    return publisher
  }
  
  func removeListenerToFavourites() {
    self.userExercisesListener?.remove()
  }
}
