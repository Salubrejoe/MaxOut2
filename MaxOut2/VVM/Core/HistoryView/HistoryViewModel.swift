import SwiftUI
import SwiftUICalendar

struct WidgetStat {
  let amount: Double?
  let unit: TSUnit?
  
  enum TSUnit: String {
    case km, kg, min
  }
  
  init(amount: Double? = nil, unit: TSUnit? = nil) {
    self.amount = amount
    self.unit = unit
  }
  
//  var queryResultString: (String, String) {
//    guard let amount, let unit else { return ("", "") }
//    if unit == .min, amount > 59 {
//      let hour = Int(amount/60.rounded(.down))
//      let minute = Int(amount)%60
//      return 
//    }
//    return (String(format: "%.1f", amount), unit.rawValue)
//  }
}


final class HistoryViewModel: ObservableObject {
  @Published var widgetData : [CalendarGridData] = []
  @Published var widgetStat = WidgetStat()
  
  /// Main array used for populating WorkoutGrid()
  @Published var workouts        : [Workout] = []
  
  /// CalendarView
  @Published var focusedWorkouts : [Workout]? = nil 
  @Published var focusedDate     : YearMonthDay? = nil
  
  /// Still needed because some methods (hasWorkotsRecorded) rely on it
  @Published var decorations = [YearMonthDay: [(String, Color)]]()

  /// Placeholders for the title
  @Published var currentFocusedMonth : String = "Calendar"
  @Published var currentFocusedYear  : String = "📆"
  
  /// Toolbar condition
  @Published var isShowingCalendar = true
  
  
  /// Returns the name of the current day (eg Monday, Tuesday, ..)
  var focusedDayName: String? {
    guard
      let date = focusedDate
    else { return nil }
    
    let dayOfWeek = date.dayOfWeek
    return weekdayName(from: dayOfWeek.rawValue)
  }
  
  // MARK: - WORKOUTS SECTIONED
  /// Method returns section headers and respective array of workouts
  var groupedWorkouts: [(String, [Workout])] {
    let sortedItems = workouts.sorted { $0.monthYear < $1.monthYear }
    let grouped = Dictionary(grouping: sortedItems) { String($0.month) + " " + String($0.year) }
    return grouped.sorted { $0.0 < $1.0 }
  }
  
  
  init() {
    getViewInfo()

  }
  
  
  // MARK: - BACKGROUND
  /// Style for cells
  func opacity(for yearMonthDay: YearMonthDay) -> CGFloat {
    guard hasWorkoutsRecorded(yearMonthDay) else { return 1 }
    let totalDuration = workoutTime(for: yearMonthDay)
    return max(totalDuration/3600, 0.4)
  }
  
  // Widget Method
  func opacity(by date: Date) -> CGFloat {
    let yearMonthDay = yearMonthDay(from: date)
    guard hasWorkoutsRecorded(yearMonthDay) else { return 0 }
    let totalDuration = workoutTime(for: yearMonthDay)
    return max(totalDuration/3600, 0.4)
  }
  
  func hasWorkoutsRecorded(_ date: YearMonthDay) -> Bool {
    guard let _ = decorations[date] else { return false }
    return true
  }
  
  func backgroundColor(for date: YearMonthDay) -> some ShapeStyle {
    guard hasWorkoutsRecorded(date) else { return Color.secondarySytemBackground.gradient.opacity(0.01) }
    return Color.primary.gradient.opacity(opacity(for: date))
  }


  
  /// This init is missing from the API..........
  func yearMonthDay(from date: Date) -> YearMonthDay {
    let calendar = Calendar.current
    let year = calendar.component(.year, from: date)
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    return YearMonthDay(year: year, month: month, day: day)
  }
  
  
  /// TOOLBAR method for "Today" Button
  func jumpToToday() {
    if isShowingCalendar == false { isShowingCalendar = true }
    focusedDate = YearMonthDay.current
  }
  
  // MARK: - WIDGET METHOD
  func getCalendarData() {
    var data: [CalendarGridData] = []
    
    let today = Date()
    for i in 0..<84 {
      let date = Calendar.current.date(byAdding: .day, value: -i, to: today)
      let dateSecure = date ?? Date()
      let widgetData = CalendarGridData(opacity: opacity(by: dateSecure), date: dateSecure)
      data.append(widgetData)
    }
    self.widgetData = data.reversed()
  }
  
  
  
  // MARK: - WEEKDAY NAME
  func weekdayName(from dayOfWeek: Int) -> String {
    let calendar = Calendar.current
    let weekdaySymbols = calendar.weekdaySymbols

    let dateFormatter = DateFormatter()
    dateFormatter.weekdaySymbols = weekdaySymbols
    
    let weekdayName = dateFormatter.weekdaySymbols[dayOfWeek]
    
    return weekdayName // 0 = SUNDAY
  }
  
  // MARK: - Get Workout Duration
  func workoutTime(for date: YearMonthDay) -> TimeInterval {
    var duration = 0.0
    
    let calendar = Calendar.current
    let selectedDateYear = date.year
    let selectedDateMonth = date.month
    let selectedDateDay = date.day
    
    for workout in workouts {
      let date = workout.routine.dateStarted
      let year = calendar.component(.year, from: date)
      let month = calendar.component(.month, from: date)
      let day = calendar.component(.day, from: date)
      if year == selectedDateYear,
         month == selectedDateMonth,
         day == selectedDateDay {
        duration += workout.routine.duration
      }
    }
    return duration
  }
  
  
  // MARK: - Populate Calendar method
  /// Gets workouts for WorkoutGrid and decorations for CalendarView
  func getViewInfo() {
    Task {
      do {
        let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
        let workouts = try await RoutinesManager.shared.workouts(for: userId)
        
        await MainActor.run {
          self.workouts = []
          self.workouts = workouts.sorted { $0.routine.dateStarted > $1.routine.dateStarted}
          self.getDecorations(for: workouts)
          self.getCalendarData()
        }
      }
      catch {
        print("\n Error retrieving workouts, HistoryViewModel: ")
        print("\n ----------------------- \n \(error) \n")
      }
    }
  }
  
  // MARK: - Decorations
  func getDecorations(for workouts: [Workout]) {
    for workout in workouts {
      let endDate = getEndDate(for: workout)
      let newDecoration = workout.routine.duration.asTimeString(style: .abbreviated)
      var foundMatchingDecoration = false
      
      if let decos = decorations[endDate] {
        
        /// CHECK IF DECORATION ALREADY LAID
      decorationLoop: for decoration in decos {
          if decoration.0 == newDecoration {
            foundMatchingDecoration = true
            break decorationLoop
          }
        }
        
        if !foundMatchingDecoration {
          decorations[endDate]?.append((newDecoration, Color(.systemRed)))
        }
      }
      else {
        decorations[endDate] = []
        decorations[endDate]?.append((newDecoration, Color(.systemRed)))
      }
    }
  }
  
  
  // MARK: - GET END DATE FOR WORKOUT
  private func getEndDate(for workout: Workout) -> YearMonthDay {
    guard let routineDate = workout.routine.dateEnded else { return YearMonthDay.current}
    
    let date = Calendar.current.dateComponents(in: .current, from: routineDate)
    
    guard
      let year = date.year,
      let month = date.month,
      let day = date.day else { return YearMonthDay.current }
    
    return YearMonthDay(year: year, month: month, day: day)
  }
  
  // MARK: - TAP CALEND CELLS ACTION
  func switchFocus(for date: YearMonthDay) {
    withAnimation {
      if focusedDate == date {
        focusedDate = nil
        focusedWorkouts = nil
      }
      else {
        focusedDate = date
        focusedWorkouts = []
        for workout in workouts {
          let endDate = getEndDate(for: workout)
          if endDate == date { focusedWorkouts?.append(workout) }
        }
      }
    }
  }
  
  
  // MARK: - Delete Workout
    func delete(_ workout: Workout) {
      Task {
        do {
          let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
          try await RoutinesManager.shared.delete(routineId: workout.routine.id, for: userId)
          
          let endDate = getEndDate(for: workout)
          await MainActor.run {
            decorations[endDate] = []
          }
          
          guard let index = focusedWorkouts?.firstIndex(of: workout) else {
            self.getViewInfo()
            return
          }
          
          await MainActor.run {
            let _ = focusedWorkouts?.remove(at: index)
          }
          
          self.getViewInfo()
          
        }
        catch {
          print("Could not delete routine: \(error)")
        }
      }
    }
}
