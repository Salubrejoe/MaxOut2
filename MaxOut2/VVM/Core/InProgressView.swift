
import SwiftUI

struct InProgressHeader: View {
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarIsHidden: Bool
  
  var body: some View {
    VStack(alignment: .leading) {
      if tabBarIsHidden {
        HStack {
          Button("Quit") {
            model.showingCancelAlert = true
          }
          .imageScale(.large)
          .foregroundColor(.secondary)
          .frame(width: 80, alignment: .leading)
          
          Text(Date().formattedString())
            .frame(maxWidth: .infinity)
            .fontWeight(.semibold)
          
          Button("Finish") {
            model.inProgress = false
            tabBarIsHidden = false
            model.saveTask()
          }
          .bold()
          .frame(width: 80, alignment: .trailing)
          .buttonStyle(.bordered)
          .foregroundColor(.green)
        }
      }
      
      VStack(alignment: .leading) {
        HStack(alignment: .firstTextBaseline) {
          Text(model.routine?.title ?? "")
            .font(model.position == .absoluteBottom(220) ? .title2.bold() : .largeTitle.bold())
          Spacer()
          Image(systemName: "ellipsis.rectangle.fill")
            .imageScale(.large)
        }
        
        Text(model.startDate, style: .timer)
          .font(.headline)
          .foregroundColor(.secondary)
      }
    }
    .padding(.horizontal)
  }
}

struct SessionsGrid: View {
  @EnvironmentObject var model: StartViewModel
  @Binding var tabBarIsHidden: Bool
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack {
        sessionGrid
          .padding(.horizontal)
          .padding(.vertical, 10)
        //        .background(.ultraThinMaterial)
          .cornerRadius(20)
        //        .shadow(color: .primary.opacity(0.2), radius: 2, y: 1)
      }
      
    }
    .scrollDismissesKeyboard(.interactively)
    .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
    .animation(.spring(), value: model.sessions)
    .alert(model.alertText, isPresented: $model.showingCancelAlert) { finishAlert }
    .toolbar {
      ToolbarItem(placement: .keyboard) { Spacer() }
      ToolbarItem(placement: .keyboard) { ResignKeyboardButton() }
    }
  }
}

extension SessionsGrid {
  
  
  @ViewBuilder
  private var sessionGrid: some View {
    LazyVGrid(columns: model.largeColumns, spacing: 5) {
      ForEach($model.sessions) { $session in
        SessionView(session: $session, model: model)
      }
      
      LargeTsButton(text: "Add Exercises", background: .ultraThinMaterial, textColor: .accentColor, image: "exercisesList") {
        model.isShowingPicker = true
      }
      .padding(.top, 20)
      
      Spacer(minLength: 100)
    }
  }
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisesPicker()
    }
  }
  
  @ViewBuilder // MARK: - CANCEL Alert
  private var finishAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Quit", role: .destructive) {
      model.cancelRoutine()
      model.showingCancelAlert = false
      model.inProgress = false
      tabBarIsHidden = false
    }
  }
}
