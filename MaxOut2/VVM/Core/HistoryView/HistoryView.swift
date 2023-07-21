import SwiftUI
import SwiftUICalendar

struct HistoryView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var model: HistoryViewModel
  
  @Binding var isShowingHistory: Bool
  
  var body: some View {
    NavigationStack {
      if model.isShowingCalendar { TsCalendarView().environmentObject(model) }
      
      ScrollView(showsIndicators: false, content: {
        WorkoutGrid() .environmentObject(model) .padding(.horizontal)
      })
      .onAppear { model.getViewInfo() }
      .navigationTitle("\(model.currentFocusedMonth) \(model.currentFocusedYear)")
      .animation(.spring(), value: model.isShowingCalendar)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            model.jumpToToday()
          } label: {
            Text("Today")
          }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            model.isShowingCalendar.toggle()
          } label: {
            Image(systemName: "calendar")
              .imageScale(.large)
          }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            isShowingHistory = false
            dismiss()
          } label: {
            Image(systemName: "xmark.circle.fill")
              .foregroundColor(.secondary)
          }
        }
      }
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView(isShowingHistory: .constant(true))
  }
}
