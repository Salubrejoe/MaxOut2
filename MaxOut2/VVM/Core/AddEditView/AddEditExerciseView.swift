

import SwiftUI


struct AddEditExerciseView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject private var model = AddEditViewModel()
  @FocusState private var focus: Field?

  
  @State private var exercise: Exercise = Exercise.mockup
  
  let passedExercise: Exercise
  
  
  var body: some View {
    
      ScrollView {
        
        TSTextField(text: $exercise.name, field: .name, isSecure: false) {
          Field.hideKeyboard()
        } xMarkAction: {
          focus = .name
          exercise.name = ""
        }
        .focused($focus, equals: .name)
        .onChange(of: exercise.name) { newValue in
          print(newValue)
        }

        ThreeWayPicker(selectedCategory: $exercise.category,
                       selectedMuscle: $exercise.primaryMuscles[0],
                       selectedEquipment: $exercise.equipment.bound) {}
          .padding(.vertical)
        
        VStack {
          ForEach($exercise.instructions.indices, id: \.self) { index in
            TextEditor(text: $exercise.instructions[index])
          }
          
          Button("Add") { exercise.instructions.append("")}
        }
      }
      .padding()
      .frame(maxWidth: 432)
      .resignKeyboardOnDragGesture()
      .navigationTitle(exercise.id.isEmpty ? "Add New" : "Edit")
      
      .onAppear {
        exercise = passedExercise
      }
      
      // MARK: - TOOLBAR
      .toolbar {
        if exercise.id.isEmpty {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") {
              exercise = Exercise.mockup
              dismiss()
            }
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") {
            exercise.dateModified = Date()
            try? model.save(exercise)
            dismiss()
          }.bold()
        }
      }
    
  }
}


/*
 ScrollView {
 
 //      CategoryImageView(systemName: exercise.image, size: 200, color: exercise.color)
 //        .padding()
 //        .onTapGesture {
 //          model.showSymbolPicker = true
 //        }
 
 
 TSTextField(text: $exercise.name, field: .name, isSecure: false) {
 //        Field.hideKeyboard()
 } xMarkAction: {
 focus = .name
 exercise.name = ""
 }
 .focused($focus, equals: .name)
 .onChange(of: exercise.name) { newValue in
 print(newValue)
 }
 
 
 ThreeWayPicker(selectedCategory: $exercise.category,
 selectedMuscle: $exercise.primaryMuscles[0],
 selectedEquipment: $exercise.equipment.bound) {}
 .padding(.vertical)
 
 VStack {
 ForEach($exercise.instructions, id: \.self) { $instruction in
 TextEditor(text: $instruction)
 }
 
 Button("Add") { exercise.instructions.append("")}
 }
 }
 .padding()
 .frame(maxWidth: 432)
 .resignKeyboardOnDragGesture()
 
 .navigationTitle(exercise.id.isEmpty ? "Add New" : "Edit")
 
 // MARK: - Symbol Picker
 //    .sheet(isPresented: $model.showSymbolPicker, content: {
 //      SymbolPicker(symbol: $exercise.image, symbolGroup: model.symbolGroup)
 //    })
 
 // MARK: - TOOLBAR
 .toolbar {
 if exercise.id.isEmpty {
 ToolbarItem(placement: .navigationBarLeading) {
 Button("Cancel") {
 exercise = Exercise.mockup
 dismiss()
 }
 }
 }
 ToolbarItem(placement: .navigationBarTrailing) {
 Button("Save") {
 model.save(exercise)
 dismiss()
 }.bold()
 }
 }
 */
