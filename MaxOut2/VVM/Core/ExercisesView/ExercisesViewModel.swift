
import Foundation
import Combine

final class ExercisesViewModel: ObservableObject {
  @Published var exercises         : [Exercise] = []
  @Published var selectedExercises : [Exercise] = []
  
  /// Bools
  @Published var isShowing3WayPicker = false
  @Published var showingAddEdit      = false
  
  /// Searchable
  @Published var searchText       : String = ""
  
  /// Three way picker selections
  @Published var selectedCategory  : String = ""
  @Published var selectedMuscle    : String = ""
  @Published var selectedEquipment : String = ""
  
  /// Exercise.mockup
  @Published var newExercise = Exercise.mockup

  /// Listener canc
  private var cancellables = Set<AnyCancellable>()
  
  /// Alphabetical order 
  @Published var selectedLetter = ""
  
  var groupedExercises: [(String, [Exercise])] {
    let sortedItems = exercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  var alphaSortedExercises: [Exercise] {
    exercises.sorted { $0.name < $1.name }
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
  
  
  // MARK: - Scroll to ID
  var alphabet: [String] {
    var a: [String] = []
    for exercise in groupedExercises {
      a.append(exercise.0)
    }
    return a
  }
  
  func scrollTo(letter: String) {
    selectedLetter = letter
  }
  
  
  // MARK: - Select Action if Picker
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
  
  
  
  
  // MARK: - Commit selected exercises
  @MainActor
  func commitSelection(toRoutineVM model: StartViewModel) {
    Task {
      for exercise in selectedExercises {
        var lastSession = try? await lastSession(exerciseId: exercise.id)
        
        let session = Session(id: exercise.id,
                              exerciseId: exercise.id,
                              exerciseName: exercise.name,
                              dateCreated: Date(),
                              category: exercise.category,
                              bobs: (lastSession == nil ? [Bob()] : lastSession!.bobs),
                              image: exercise.equipmentImage)
        
        model.sessions.insert(session, at: 0)
      }
      selectedExercises = []
    }
  }
  
  func lastSession(exerciseId: String) async throws -> Session { /// 🧵⚾️
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid /// 🧵🥎
    return try await SessionsManager.shared.lastSession(exerciseId: exerciseId, userId: userId) /// 🧵🥎
  }
  
  func remove(exercise id: String) {
    Task {
      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
      try await ExercisesManager.shared.delete(exerciseId: id, for: userId)
    }
  }
  // MARK: - IndexForExercise
  func indexOfItem(_ exercise: Exercise) -> Int? {
    guard let index = self.exercises.firstIndex(where: { $0.id == exercise.id }) else {
      return nil
    }
    return index
  }

}


// MARK: - SEARCH Logic
extension ExercisesViewModel {
  func search() {
    if selectedCategory == "",
       selectedMuscle == "",
       selectedEquipment == "",
       searchText == "" {
      addListenerToFavourites()
      return
    }
    
    addListenerToFavourites()
  
    var filteredExercises = exercises
    
    removeListener()
    
    print(searchText)
//    self.exercises = []

//    if !selectedCategory.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.category == selectedCategory }
//    }
//
//    if !selectedMuscle.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.primaryMuscles.contains(selectedMuscle) }
//    }
//
//    if !selectedEquipment.isEmpty {
//      filteredExercises = filteredExercises.filter { $0.equipment == selectedEquipment }
//    }
//
    if !searchText.isEmpty {
      filteredExercises = filteredExercises.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    exercises = filteredExercises.sorted { ($0.name > $1.name) }
    print(exercises.count)
  }
//  func search() {
//    Task {
//      let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
//      let filteredExercises = try await ExercisesManager.shared.filteredExercises(userId: userId, searchText: searchText)
//      await MainActor.run {
//        guard filteredExercises.count > 0 else {
//          addListenerToFavourites()
//          return }
//        removeListener()
//        self.exercises = filteredExercises
//      }
//    }
//  }
}


// MARK: - Combine LISTENER
extension ExercisesViewModel {
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