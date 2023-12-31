
import SwiftUI
import Combine
import HealthKit

final class ExercisesViewModel: ObservableObject {
  @Published var exercises         : [Exercise] = []
  @Published var selectedExercises : [Exercise] = []
  @Published var templates         : [Exercise] = []

  @Published var selectedExercise = Exercise.mockup
  
  /// Listener canc
  let passthrough = PassthroughSubject<Void, Never>()
  private var cancellables = Set<AnyCancellable>()
  
  @Published var selectedLetter = ""
  @Published var searchText: String?
   
  /// 3 way Picker
  @Published var selectedActivityType: ActivityType?
  @Published var selectedMuscle: Muscle?
  @Published var selectedEquipment: EquipmentType?
  @Published var isEditing: Bool = false

  /// Grid columns
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  /// Locate exercise in array
  func indexOfItem(_ exercise: Exercise, collection exercises: [Exercise]) -> Int? {
    guard let index = exercises.firstIndex(where: { $0.name == exercise.name }) else {
      return nil
    }
    return index
  }
}


// MARK: - GROUPS FOR 3WPICKER
extension ExercisesViewModel {
  public func activities(for collection: [Exercise]) -> [HKWorkoutActivityType] {
    var types = [HKWorkoutActivityType]()
    for element in collection {
      if !types.contains(element.activityType.hkType) {
        types.append(element.activityType.hkType)
      }
    }
    return types
  }
  public func muscles(for collection: [Exercise]) -> [Muscle] {
    var types = [Muscle]()
    for element in collection {
      if !types.contains(element.muscle) {
        types.append(element.muscle)
      }
    }
    return types
  }
  public func equipment(for collection: [Exercise]) -> [EquipmentType] {
    var types = [EquipmentType]()
    for element in collection {
      if !types.contains(element.equipmentType) {
        types.append(element.equipmentType)
      }
    }
    return types
  }
}


// MARK: - SEARCH LOGIC
extension ExercisesViewModel {
  func filter(_ exercises: [Exercise]) -> [Exercise] {
    var filteredExercises = exercises
    
    if let searchText {
      filteredExercises = filteredExercises.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    if let selectedMuscle {
      filteredExercises = filteredExercises.filter { $0.muscle.rawValue == selectedMuscle.rawValue }
    }
    
    if let selectedEquipment {
      filteredExercises = filteredExercises.filter { $0.equipmentType.rawValue == selectedEquipment.rawValue }
    }
    
    if let selectedActivityType {
      filteredExercises = filteredExercises.filter { $0.activityType.rawValue == selectedActivityType.rawValue }
    }
    
    return filteredExercises
  }
  
  public var groupedExercises: [(String, [Exercise])] {
    let filteredExercises = filter(exercises)
    let sortedItems = filteredExercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  public var groupedTemplates: [(String, [Exercise])] {
    
    let filteredExercises = filter(templates)
    let sortedItems = filteredExercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  public var alphabetTemplates: [String] {
    var a: [String] = []
    for groupedExercise in groupedTemplates {
      a.append(groupedExercise.0)
    }
    return a
  }
  
  public var alphabet: [String] {
    var a: [String] = []
    for groupedExercise in groupedExercises {
      a.append(groupedExercise.0)
    }
    return a.count > 3 ? a : []
  }
  
  func loadSelectedExercisesJson() {
    let array: ExercisesArray = Bundle.main.decode("selectedExercises.json")
    exercises = array.exercises
  }
  
  func loadTemplatesJson() {
    let array: ExercisesArray = Bundle.main.decode("exercises.json")
    templates = array.exercises
  }
}


// MARK: - PICKER LOGIC
extension ExercisesViewModel {
  
  // COMMIT
  @MainActor
  func commitSelection(toRoutineVM model: StartViewModel) {
    Task {
      for exercise in selectedExercises {
        
        let lastSession = try? await lastSession(exerciseId: exercise.id)
        
        let session = Session(id: exercise.id,
                              exerciseId: exercise.id,
                              exerciseName: exercise.name,
                              dateCreated: Date(),
                              activityType: exercise.activityType.hkType.commonName,
                              bobs: (lastSession == nil ? [Bob()] : lastSession!.bobs),
                              image: exercise.equipmentType.image)
        model.sessions.append(session)
      }
      model.sessions.sort { $0.activityType < $1.activityType }
      selectedExercises = []
    }
  }
  
  // LAST SESSION
  func lastSession(exerciseId: String) async throws -> Session { /// 🧵⚾️
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid /// 🧵🥎
    return try await SessionsManager.shared.lastSession(exerciseId: exerciseId, userId: userId) /// 🧵🥎
  }
  
  
  // SELECT - DESELECT
  func select(_ exercise: Exercise) {
    if deselect(exercise) { return }
    else {
      let newExercise = Exercise(id: exercise.id, name: exercise.name, category: exercise.category, primaryMuscles: exercise.primaryMuscles, instructions: exercise.instructions)
      selectedExercises.append(newExercise)
    }
  }
  
  @discardableResult
  func deselect(_ exercise: Exercise) -> Bool {
    guard let index = indexOfItem(exercise, collection: selectedExercises) else { return false }
    selectedExercises.remove(at: index)
    return true
  }
}


// MARK: - ADD/REMOVE form DB
extension ExercisesViewModel {
  
  func add() {
    addToExercises(selectedExercises)
    selectedExercises = []
  }
  
  func remove(exercise id: String) {
    Task {
      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
      try await ExercisesManager.shared.delete(exerciseId: id, for: userId)
    }
  }
  
  func addToExercises(_ exercises: [Exercise]) {
    Task {
      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
      for exercise in exercises {
        try await ExercisesManager.shared.addToExercises(exercise: exercise, for: userId)
      }
    }
  }
  
  func update(_ exercise: Exercise) {
//    do {
//      try ExercisesManager.shared.update(exercise: exercise)
//    }
//    catch {
//      print("Could not update exercise!")
//    }
  }
}


// MARK: - LISTENER
extension ExercisesViewModel {

  func addListenerToFavourites() {
    Task {
      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
      ExercisesManager.shared.addListenerToExercises(for: userId)
        .sink { completion in
          
        } receiveValue: { [weak self] exercises in
          guard let self else { return }
          let allExercises = self.exercises + exercises
          self.exercises = allExercises.sorted { $0.name < $1.name}
        }
        .store(in: &cancellables)
    }
  }
  
  func removeListener() {
    ExercisesManager.shared.removeListenerToFavourites()
  }
}


//  func pushExercises() {
//    for exercise in exercises {
//      try? ExercisesSelectionManager.shared.push(exercise: exercise)
//    }
//  }

//    func makeJson() -> String? {
//      var exercisesDictionary: [[String: Any?]] = []
//
//      for exercise in exercises {
//        let exerciseDictionary: [String: Any?] = [
//          Exercise.CodingKeys.id.rawValue : exercise.id,
//          Exercise.CodingKeys.name.rawValue : exercise.name,
//          Exercise.CodingKeys.aliases.rawValue : exercise.aliases,
//          Exercise.CodingKeys.primaryMuscles.rawValue : exercise.primaryMuscles,
//          Exercise.CodingKeys.secondaryMuscles.rawValue : exercise.secondaryMuscles,
//          Exercise.CodingKeys.force.rawValue : exercise.force,
//          Exercise.CodingKeys.level.rawValue : exercise.level,
//          Exercise.CodingKeys.mechanic.rawValue : exercise.mechanic,
//          Exercise.CodingKeys.equipment.rawValue : exercise.equipment,
//          Exercise.CodingKeys.category.rawValue : exercise.category,
//          Exercise.CodingKeys.instructions.rawValue : exercise.instructions,
//          Exercise.CodingKeys.description.rawValue : exercise.description,
//          Exercise.CodingKeys.tips.rawValue : exercise.tips
//        ]
//        exercisesDictionary.append(exerciseDictionary)
//      }
//
//
//      let mainDictionary: [String: [[String: Any?]]] = [
//        "exercises" : exercisesDictionary
//      ]
//
//      return JSONStringEncoder().encode(mainDictionary)
//    }


