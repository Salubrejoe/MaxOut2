
import SwiftUI
import Combine

final class ExercisesViewModel: ObservableObject {
  @Published var exercises         : [Exercise] = []
  @Published var selectedExercises : [Exercise] = []

  /// Listener canc
  private var cancellables = Set<AnyCancellable>()
  
  @Published var selectedLetter = ""
  
  
  /// 3 way Picker
  @Published var selectedActivity: Activity?
  @Published var selectedActivityType: ActivityType?
  @Published var selectedMuscle: Muscle?
  @Published var selectedEquipment: EquipmentType?
  
  /// Grid columns
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  var groupedActivities: [Activity] {
    let sortedItems = exercises.sorted { $0.activityType.rawValue < $1.activityType.rawValue }
    let grouped = Dictionary(grouping: sortedItems) { String($0.activityType.rawValue) }
    let sortedGroup = grouped.sorted { $0.0 < $1.0 }
    return sortedGroup.map { Activity(name: ActivityType(rawValue: $0.key) ?? .mixedCardio, exercises: $0.value) }
  }
  
  public var groupedExercises: [(String, [Exercise])] {
    var filteredExercises = exercises
    if let selectedMuscle {
      filteredExercises = exercises.filter { $0.muscle.rawValue == selectedMuscle.rawValue }
    }
    
    if let selectedEquipment {
      filteredExercises = filteredExercises.filter { $0.equipmentType.rawValue == selectedEquipment.rawValue }
    }
    
    if let selectedActivityType {
      filteredExercises = filteredExercises.filter { $0.activityType.rawValue == selectedActivityType.rawValue }
    }
    
    let sortedItems = filteredExercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }

    return grouped.sorted { $0.0 < $1.0 }
  }
  
  public var alphabet: [String] {
    var a: [String] = []
    for groupedExercise in groupedExercises {
      a.append(groupedExercise.0)
    }
    return a
  }
  
  // MARK: - Body Part SEARCH
  func sieveByBodyPart() {
    exercises = []
    addListenerToFavourites()
    if let muscle = selectedMuscle {
      exercises = exercises.filter { $0.primaryMuscles[0] == muscle.rawValue }
    }
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
                              category: exercise.category,
                              bobs: (lastSession == nil ? [Bob()] : lastSession!.bobs),
                              image: exercise.equipmentType.image)
        
        model.sessions.append(session)
      }
      selectedExercises = []
    }
  }
  
  
  // SELECT
  func toggleIsSelected(_ exercise: Exercise) {
    guard let generalIndex = indexOfItem(exercise) else { return }
    
    if !exercise.isSelected {
      exercises[generalIndex].isSelected = true
      selectedExercises.append(exercise)
    }
    else {
      for i in selectedExercises.indices {
        let id = selectedExercises[i].id
        if id == exercise.id {
          selectedExercises.remove(at: i)
          exercises[generalIndex].isSelected = false
          break
        }
      }
    }
  }
  
  
  // DESELECT
  func removeFromSelected(_ exercise: Exercise) {
    guard let generalIndex = indexOfItem(exercise) else { return }
    exercises[generalIndex].isSelected = false
    for i in selectedExercises.indices {
      let id = selectedExercises[i].id
      if id == exercise.id {
        selectedExercises.remove(at: i)
      }
    }
  }
  
  // LAST SESSION
  func lastSession(exerciseId: String) async throws -> Session { /// 🧵⚾️
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid /// 🧵🥎
    return try await SessionsManager.shared.lastSession(exerciseId: exerciseId, userId: userId) /// 🧵🥎
  }
  
  
  // MARK: - IndexForExercise
  func indexOfItem(_ exercise: Exercise) -> Int? {
    guard let index = self.exercises.firstIndex(where: { $0.id == exercise.id }) else {
      return nil
    }
    return index
  }
}


// MARK: - ADD/REMOVE form DB
extension ExercisesViewModel {
  
  // ADD TO FAV
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
}


// MARK: - SEARCH LOGIC
//extension ExercisesViewModel {
//
//  
//  func search() {
//    if selectedCategory == "",
////       selectedMuscle == "",
//       selectedEquipment == "",
//       searchText == "" {
//      addListenerToFavourites()
//      return
//    }
//    
//    addListenerToFavourites()
//  
//    var filteredExercises = exercises
//    
//    removeListener()
//    
//    self.exercises = []
//
//    if !selectedCategory.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.category == selectedCategory }
//    }
//
////    if !selectedMuscle.isEmpty {
////      filteredExercises = filteredExercises.filter { $0.primaryMuscles.contains(selectedMuscle) }
////    }
//
//    if !selectedEquipment.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.equipment == selectedEquipment }
//    }
//
//    if !searchText.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//    }
//    
//    exercises = filteredExercises.sorted { ($0.name > $1.name) }
//  }
//}


// MARK: - JLOADER/LISTENER
extension ExercisesViewModel {
  
  func loadTemplateJson() {
    removeListener()
    
    self.exercises = []
    let result: ExercisesArray = Bundle.main.decode("exercises.json")
    
    let decodedExercises = result.exercises
    
    exercises = decodedExercises
  }
  
  func addListenerToFavourites() {
    Task {
      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
      ExercisesManager.shared.addListenerToExercises(for: userId)
        .sink { completion in
          
        } receiveValue: { [weak self] exercises in
          self?.exercises = exercises.sorted { $0.name < $1.name}
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


