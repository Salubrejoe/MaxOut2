import SwiftUI
import SwiftUICalendar

struct HistoryView: View {
  @EnvironmentObject var model: HistoryViewModel
  
  var body: some View {
    NavigationStack {
      VStack {
        if model.isShowingCalendar {
          TsCalendarView().environmentObject(model)
        }
        
        Divider()
        ScrollView(showsIndicators: false) {
          WorkoutGrid() .environmentObject(model)
        }
      }
      .padding(.horizontal)
      .navigationTitle(navTitle())
      .onAppear { model.getViewInfo() }
      .animation(.spring(), value: model.isShowingCalendar)
      .toolbar { showHideCalendar }
      .dismissButton()
    }
  }
  
  private func navTitle() -> String {
    if model.isShowingCalendar { return "\(model.currentFocusedMonth) \(model.currentFocusedYear)" }
    else { return ""}
  }
  
  @ToolbarContentBuilder // MARK: - TOOLBAR
  private var showHideCalendar: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        model.isShowingCalendar.toggle()
      } label: {
        HStack(alignment: .lastTextBaseline,spacing: 2) {
          Image(systemName: "calendar")
            .imageScale(.small)
          Text(model.isShowingCalendar ? "Hide" : "Show")
        }
        .foregroundColor(.primary)
      }
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}
