
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
      
  }
  
  private func getMonthAndYear() {
    model.currentFocusedYear = controller.yearMonth.year.description
    model.currentFocusedMonth = controller.yearMonth.monthShortString
  }
}


extension TsCalendartView {
  
  
  // MARK: - CV HEADER
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
    GeometryReader { geometry in
//      let height = geometry.size.height
      VStack(alignment: .center) {
        
        // MARK: - TODAY label
        if date.isToday {
          
            Text("\(date.day)")
            .font(.headline)
              .padding(4)
              .foregroundColor(model.focusedDate == date ? .background : .accentColor)
              .frame(width: 30, height: 30)
              .background(background(for: date))
              .cornerRadius(7)
          
        } else {
          
          // MARK: - DAYS label
            Text("\(date.day)")
              .font(model.hasWorkoutsRecorded(date) ? .headline : .subheadline)
              .foregroundColor(model.hasWorkoutsRecorded(date) ? .systemBackground : .primary)
              .padding(4)
              .frame(width: 30, height: 30)
              .background(background(for: date))
              .cornerRadius(7)
              .opacity(date.isFocusYearMonth == true ? 1 : 0.2)
              
        }
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
//              // MARK: - Decoration
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
      }
        .frame(width: geometry.size.width - 2, height: geometry.size.height - 2, alignment: .top)
        .padding(.top, geometry.size.height/5)
        
        .cornerRadius(7)
        .onTapGesture { model.switchFocus(for: date) }
    }
  }

  func background(for date: YearMonthDay) -> Color {
    if model.hasWorkoutsRecorded(date) {
      return model.focusedDate == date ? Color.accentColor.opacity(model.opacity(for: date)) : Color.primary.opacity(model.opacity(for: date))
    }
    else {
      return model.focusedDate == date ? Color.accentColor : Color.clear
    }
  }
}

struct TsCalendartView_Previews: PreviewProvider {
  static var previews: some View {
    TsCalendartView(model: HistoryViewModel())
  }
}
