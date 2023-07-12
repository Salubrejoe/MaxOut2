
import SwiftUI

struct TemplatePickerDetailView: View {
  let exercise: Exercise
  
  var body: some View {
    Form {
      Section {
        Text(exercise.category)
      }
      
      Section {
        Text(exercise.muscleGroup)
      }
      
      Section {
        Text(exercise.equipment ?? "No equipment")
      }
      
      Section {
        ForEach(exercise.instructions, id: \.self) {
          Text($0)
        }
      }
    }
  }
}
