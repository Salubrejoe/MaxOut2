import SwiftUI


final class TemplatesPickerViewModel: ObservableObject {
  @Published var templateExercises: [Exercise] = []
  @Published var selectedTemplates: [Exercise] = [] /// Selectable
  
  /// Searchable
  @Published var searchText: String = ""
  
  /// Three way picker selections
  @Published var selectedCategory  : String = ""
  @Published var selectedMuscle    : String = ""
  @Published var selectedEquipment : String = ""
  
  /// Grid columns
  let columns = [GridItem(.adaptive(minimum: 300))]
  
  
  init() { // MARK: - INIT
    loadJson()
  }
  
  @Published var selectedLetter = ""
  
  
  // MARK: - Letter Picker var
  var groupedExercises: [(String, [Exercise])] {
    let sortedItems = templateExercises.sorted { $0.name < $1.name }
    let grouped = Dictionary(grouping: sortedItems) { String($0.name.prefix(1)) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  var alphabet: [String] {
    var a = [""]
    for exercise in groupedExercises {
      a.append(exercise.0)
    }
    return a
  }
  
  func scrollTo(letter: String) {
    selectedLetter = letter
  }
  
  
  func removeFromSelected(_ exercise: Exercise) {
    guard let generalIndex = indexOfItem(exercise) else { return }
    templateExercises[generalIndex].isSelected = false
    for i in selectedTemplates.indices {
      let id = selectedTemplates[i].id
      if id == exercise.id {
        selectedTemplates.remove(at: i)
      }
    }
  }
  
  
  // MARK: - IndexForExercise
  func indexOfItem(_ exercise: Exercise) -> Int? {
    guard let index = self.templateExercises.firstIndex(where: { $0.id == exercise.id }) else {
      return nil
    }
    return index
  }
  
  func toggleIsSelected(_ exercise: Exercise) {
    guard let generalIndex = indexOfItem(exercise) else { return }
    
    if exercise.isSelected == false {
      templateExercises[generalIndex].isSelected = true
      selectedTemplates.append(exercise)
    }
    else {
      templateExercises[generalIndex].isSelected = false
      for i in selectedTemplates.indices {
        let id = selectedTemplates[i].id
        if id == exercise.id {
          selectedTemplates.remove(at: i)
        }
      }
    }
  }
  
  /// Load all templates
  private func loadJson() {
    self.templateExercises = []
    let result: ExercisesArray = Bundle.main.decode("exercises.json")
    
    let decodedExercises = result.exercises

    templateExercises = decodedExercises
  }
  
  /// SAVE
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
extension TemplatesPickerViewModel {
  func search() {
    if selectedCategory == "",
       selectedMuscle == "",
       selectedEquipment == "",
       searchText == "" {
      loadJson()
      return
    }
    
    loadJson()
    var filteredExercises = templateExercises
    self.templateExercises = []
    
    if !selectedCategory.isEmpty {
      filteredExercises = filteredExercises.filter { $0.category == selectedCategory }
    }
    
    if !selectedMuscle.isEmpty {
      filteredExercises = filteredExercises.filter { $0.primaryMuscles.contains(selectedMuscle) }
    }
    
    if !selectedEquipment.isEmpty {
      filteredExercises = filteredExercises.filter { $0.equipment == selectedEquipment }
    }
    
    if !searchText.isEmpty {
      filteredExercises = filteredExercises.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    templateExercises = filteredExercises.sorted { ($0.category > $1.category) || ($0.primaryMuscles[0] > $1.primaryMuscles[0]) }
  }
}


/*
 DOWNLOAD PRODUCTS FROM JSON --> UPLOAD TO FS
 
 func setUpExercises() {
 if exercises.isEmpty {
 let result: ExercisesArray = Bundle.main.decode("exercises.json")
 exercises = result.exercises
 
 Task {
 do {
 for exercise in exercises {
 try await ExercisesManager.shared.upload(exercise)
 }
 }
 catch {
 print("Caught \(error) in setUp exercises")
 }
 }
 } else {
 print("exercises not empty at start, upload NOT executed")
 }
 print("setUpExercises run ok! -----------------------------------------------")
 }
 
 */
