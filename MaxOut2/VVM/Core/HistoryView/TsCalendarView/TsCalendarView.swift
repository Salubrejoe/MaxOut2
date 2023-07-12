
import SwiftUI
import SwiftUICalendar

struct TsCalendartView: View {
  
  @StateObject private var controller = CalendarController()
  @ObservedObject var model: HistoryViewModel
  
  var body: some View {
      VStack {
        Group {
          CalendarView(controller, startWithMonday: true, header: { week in
            header(week: week)
          }, component: { date in
            cell(date: date)
          })
        }
        .frame(height: 320)
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


extension TsCalendartView {
  
  // MARK: - WEEKDAYS HEADER
  private func header(week: Week) -> some View {
    GeometryReader { geometry in
      Text(week.shortString)
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
          .foregroundColor(model.focusedDate == date ? .systemBackground : .accentColor)
          .calendarCell(model, date: date)
      }
      else {
        // DAYS label
        Text("\(date.day)")
          .foregroundColor(model.hasWorkoutsRecorded(date) ? .systemBackground : .primary)
          .opacity(date.isFocusYearMonth == true ? 1 : 0.2)
          .calendarCell(model, date: date)
      }
    }.onTapGesture { model.switchFocus(for: date) }
  }
}

// MARK: - VIEW MODIFIER
fileprivate extension View {
  @ViewBuilder
  func calendarCell(_ model: HistoryViewModel, date: YearMonthDay) -> some View {
    self
      .font(.subheadline)
      .padding(4)
      .frame(width: 30, height: 30)
      .background(model.backgroundColor(for: date))
      .cornerRadius(7)
      .shadow(color: model.hasWorkoutsRecorded(date) ? .primary.opacity(model.opacity(for: date)) : .clear, radius: 5)
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
