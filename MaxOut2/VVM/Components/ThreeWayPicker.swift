
import SwiftUI


//struct ThreeWayPicker: View {
//  @Binding var selectedCategory  : String
//  @Binding var selectedMuscle    : String
//  @Binding var selectedEquipment : String
//  let categories : [String] = Category.allCases.map { $0.rawValue }
//  let equipments : [String] = Equipment.allCases.map { $0.rawValue }
//  let muscles    : [String] = Muscle.allCases.map { $0.rawValue }
//  let action: () -> Void
//  
//  @State private var isOpen = false
//  
//  var body: some View {
//    HStack(spacing: 20) {
//      // MARK: - Categories
//      VStack {
//        Picker("Categories", selection: $selectedCategory) {
//          ForEach(categories, id: \.self) {
//            Text($0)
//          }
//        }
//        .pickerStyle(.inline)
//        .onChange(of: selectedCategory) { _ in
//          action()
//        }
//      }
//      
//      // MARK: - Muscles
//      VStack {
//        Picker("Muscles", selection: $selectedMuscle) {
//          ForEach(muscles, id: \.self) {
//            Text($0)
//          }
//        }
//        .pickerStyle(.inline)
//        .onChange(of: selectedMuscle) { _ in
//          action()
//        }
//      }
//      
//      
//      // MARK: - Equipment
//      VStack {
//        Picker("Equipment", selection: $selectedEquipment) {
//          ForEach(equipments, id: \.self) {
//            Text($0)
//          }
//        }
//        .pickerStyle(.inline)
//        .onChange(of: selectedEquipment) { _ in
//          action()
//        }
//      }
//    }
//    .frame(height: 90)
//    .background(.ultraThinMaterial)
//    .cornerRadius(15)
//  }
//}
