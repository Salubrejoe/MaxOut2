import SwiftUI

struct HistoryView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @StateObject private var model = HistoryViewModel()
  
  
  var body: some View {
    NavigationStack {
      ParallaxScrollView(background: Color.secondarySytemBackground, coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: model.isShowingCalendar ? 300 : 0, content: {
        WorkoutGrid(model: model)
      }, header: {
        if model.isShowingCalendar { TsCalendartView(model: model) }
      })
      .onAppear { model.getViewInfo() }
      .navigationTitle("\(model.currentFocusedMonth) \(model.currentFocusedYear)")
      .navigationBarTitleDisplayMode(.inline)
      .animation(.spring(), value: model.isShowingCalendar)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            model.isShowingCalendar.toggle()
          } label: {
            Image(systemName: "calendar")
              .imageScale(.large)
              .foregroundColor(.accentColor)
          }
        }
      }
    }
  }
}

struct HistoryView_Previews: PreviewProvider {
  static var previews: some View {
    HistoryView()
  }
}
