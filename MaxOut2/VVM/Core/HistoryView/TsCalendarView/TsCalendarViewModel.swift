

import SwiftUI
import SwiftUICalendar


final class TsCalendartViewModel: ObservableObject {
//  @Published var calendarWorkouts = [YearMonthDay: [Workout]]()
//  @Published var decorations = [YearMonthDay: [(String, Color)]]()
//  @Published var focusDate: YearMonthDay? = nil
//  @Published var focusInfo: [Workout]? = nil
}



// MARK: - Populate Calendar
extension TsCalendartViewModel {

//  func decorations(for workouts: [Workout]) {
//    
//    for workout in workouts {
//      
//      let endDate = getEndDate(for: workout)
//      
//      //      if let _ = self.calendarWorkouts[endDate] {
//      //        self.calendarWorkouts[endDate]?.append(workout)
//      //      }
//      //      else {
//      //        self.calendarWorkouts[endDate] = []
//      //        self.calendarWorkouts[endDate]?.append(workout)
//      //      }
//      //
//      /// APPEND DECORATIONS
//      let newDecoration = workout.routine.duration
//      
//      if let _ = decorations[endDate] {
//        decorations[endDate]?.append((newDecoration, Color(.systemRed)))
//      }
//      else {
//        decorations[endDate] = []
//        decorations[endDate]?.append((newDecoration, Color(.systemRed)))
//      }
//    }
//    
//    print(self.decorations)
//  }
  
//  private func getEndDate(for workout: Workout) -> YearMonthDay {
//    guard let routineDate = workout.routine.dateEnded else { return YearMonthDay.current}
//    
//    let date = Calendar.current.dateComponents(in: .current, from: routineDate)
//    
//    guard
//      let year = date.year,
//      let month = date.month,
//      let day = date.day else { return YearMonthDay.current }
//    
//    return YearMonthDay(year: year, month: month, day: day)
//  }
  
//  func removeFromFocusInfo(_ workout: Workout) {
//    guard let index = focusInfo?.firstIndex(of: workout) else { return }
//    focusInfo?.remove(at: index)
//  }
//  
//  func reloadInformations(_ workout: Workout) {
//    let endDate = getEndDate(for: workout)
//    
//    if let _ = self.decorations[endDate] {
//      self.decorations[endDate] = []
//      getInformations()
//    }
//  }
}
