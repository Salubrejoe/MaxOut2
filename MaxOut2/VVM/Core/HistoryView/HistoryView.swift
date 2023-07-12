import SwiftUI

struct HistoryView: View {
  @StateObject private var model = HistoryViewModel()
    
  @State private var isShowingCalendar = true
  
  var body: some View {
    NavigationStack {

        VStack {
          if isShowingCalendar  {
            TsCalendartView(model: model)
              .onAppear { model.getViewInfo() }
          }
          WorkoutGrid(model: model)
        }
        .padding(.horizontal)
        .navigationTitle("\(model.currentFocusedMonth) \(model.currentFocusedYear)")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.spring(), value: isShowingCalendar)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button {
              isShowingCalendar.toggle()
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
