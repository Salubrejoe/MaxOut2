
import SwiftUI
import SwiftUICalendar

struct TsCalendarView: View {
  
  @StateObject private var controller = CalendarController()
  @EnvironmentObject var model: HistoryViewModel
  
  var body: some View {
      VStack {
        Group {
          CalendarView(controller, startWithMonday: true, header: { week in
            header(week: week)
          }, component: { date in
            cell(date: date)
          })
        }
        .frame(height: 260)
        .padding(.horizontal)
      }
      .onReceive(controller.$yearMonth) { _ in
        getMonthAndYear()
      }
      .onChange(of: model.focusedDate) { newValue in
        guard let date = newValue else { return }
        let yearMonth = YearMonth(year: date.year, month: date.month)
        controller.scrollTo(yearMonth)
      }
  }
  
  /// GET TITLE
  private func getMonthAndYear() {
    model.currentFocusedYear = controller.yearMonth.year.description
    model.currentFocusedMonth = controller.yearMonth.monthShortString
  }
}


extension TsCalendarView {
  
  // MARK: - WEEKDAYS HEADER
  private func header(week: Week) -> some View {
    GeometryReader { geometry in
      Text(week.shortString.uppercased())
        .font(.caption.bold())
        .foregroundColor(.secondary)
        .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
    }
  }
  
  
  // MARK: - CELL
  private func cell(date: YearMonthDay) -> some View {
    VStack {
      
      if date.isToday {
        // TODAY label
        Text("\(date.day)")
          .foregroundColor(.red)
          .calendarCell(model, date: date)
      }
      else {
        // DAYS label
        Text("\(date.day)")
          .foregroundColor(model.hasWorkoutsRecorded(date) ? .systemBackground : .primary)
          .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
          .calendarCell(model, date: date)
      }
    }.onTapGesture { model.switchFocus(for: date) }
      .minimumScaleFactor(0.8)
      .overlay {
        Circle()
          .stroke(lineWidth: 2)
          .opacity(date == model.focusedDate ? 1 : 0)
          .scaleEffect(0.85)
      }
  }
}

// MARK: - VIEW MODIFIER
fileprivate extension View {
  @ViewBuilder
  func calendarCell(_ model: HistoryViewModel, date: YearMonthDay) -> some View {
    self
//      .font(.subheadline)
      .bold()
      .padding(4)
      .frame(width: 30, height: 30)
      .background(model.backgroundColor(for: date))
      .clipShape(Circle())
  }
}


// MARK: - DECORATIONS
//        if let decorations = model.decorations[date] {
//          ForEach(decorations.indices, id: \.self) { index in
//            let decoration = decorations[index]
//            let focusedInfo = model.focusedWorkouts != nil
//
//
//            HStack {
//              if !focusedInfo {
//                Spacer()
//              }
//
//
//              Text(!focusedInfo ? "" : decoration.0)
//                .lineLimit(2)
//                .foregroundColor(.white)
//                .font(.system(size: 9))
//                .padding(EdgeInsets(top: 2, leading: 4, bottom: 2, trailing: 4))
//                .frame(width: !focusedInfo ? 4 : geometry.size.width-2, alignment: .center)
//                .frame(height: !focusedInfo ? 4 : 14)
//                .background(decoration.1)
//                .cornerRadius(!focusedInfo ? 2 : 7)
//                .opacity(date.isFocusYearMonth == true ? 1 : 0.4)
//            }
//          }
//        }
