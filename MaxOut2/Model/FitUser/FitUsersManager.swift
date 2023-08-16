
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


final class FitUserManager {
  static let shared = FitUserManager()
  private init() {}
  
  private let usersCollection = Firestore.firestore().collection(K.usersCollectionName)
  
  func userDocument(id: String) -> DocumentReference {
    usersCollection
      .document(id)
  }
  
  /// PUSH New Users on FStore providing an instance of FitUser Model
  func pushNew(user: FitUser) async throws { /// ⚾️
    try userDocument(id: user.id)/// 🥎
      .setData(from: user, merge: false)
    
//    let array: ExercisesArray = Bundle.main.decode("selectedExercises.json")
//    
//    let exercises = array.exercises
//    for exercise in exercises {
//      try await ExercisesManager.shared.addToExercises(exercise: exercise, for: user.id)
//    }
  }
  
  /// UPDATE USER
  func update(user: FitUser) throws { /// ⚾️
    try userDocument(id: user.id)/// 🥎
      .setData(from: user, merge: true)
  }
  
  /// GET - User With Id
  func user(id userId: String) async throws -> FitUser { /// 🧵⚾️
    try await userDocument(id: userId)/// 🧵🥎
      .getDocument(as: FitUser.self)// 🧙🏻‍♂️ Magic of CodingKeys!
  }
  
  /// DELETE User
  func deleteUser(with userId: String) {
    userDocument(id: userId).delete()
  }
}


/// Two methods to check if User is Signing in for the first time
///
extension FitUserManager {
  func isNewUser(with authResultID: String) async throws -> Bool { /// 🧵⚾️
    return try await !checkDocumentExists(in: K.usersCollectionName, by: authResultID) /// 🧵🥎
  }
  
  func checkDocumentExists(in collection: String, by id: String) async throws -> Bool { /// 🧵⚾️
    let docRef = Firestore.firestore()
      .collection(collection)
      .document(id)
    
    let document = try await docRef.getDocument() /// 🧵🥎
    if document.exists { return true }
    else { return false }
  }
}



