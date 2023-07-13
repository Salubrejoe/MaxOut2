
import SwiftUI

struct NewInProgressView: View {
  private enum CoordinateSpaces {
    case scrollView
  }
  
  @ObservedObject var model: StartViewModel

  var body: some View {
    ScrollView(showsIndicators: false) {
      ParallaxHeader(coordinateSpace: CoordinateSpaces.scrollView, defaultHeight: 170) {
        header
      }
      sessionGrid
        .padding(.horizontal)
        .padding(.vertical, 5)
        .background(Color.clear)
        .cornerRadius(20)
        .shadow(color: .primary.opacity(0.5), radius: 5)
    }
    .coordinateSpace(name: CoordinateSpaces.scrollView)
    .scrollDismissesKeyboard(.interactively)
    .fullScreenCover(isPresented: $model.isShowingPicker) { fullScreenPicker }
    .animation(.spring(), value: model.sessions)
    .alert(model.alertText, isPresented: $model.showingCancelAlert) { finishAlert }
  }
}

extension NewInProgressView {
  
  @ViewBuilder
  private var header: some View {
    VStack {
      HStack {
        Button {
          model.showingCancelAlert = true
        } label: {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.secondary)
        }
        Text(model.stateTextString())
          .font(.largeTitle.bold())
      }
      
      HStack {
        Spacer()
        TSTimerView(startDate: model.startDate) {
          model.saveTask()
        }
      }
    }
    .padding(.horizontal)
  }
  
  
  @ViewBuilder
  private var sessionGrid: some View {
    LazyVGrid(columns: model.columns, spacing: 5) {
      ForEach($model.sessions) { $session in
        SessionView(session: $session, model: model)
      }
      LargeTsButton(text: "🦾 Add Exercises", buttonColor: Color.accentColor.opacity(0.1), textColor: .accentColor) {
        model.isShowingPicker = true
      }
    }
  }
  
  @ViewBuilder // MARK: - FULL SCREEN PICKER
  private var fullScreenPicker: some View {
    ZStack(alignment: .topLeading) {
      Button("Cancel") {
        model.isShowingPicker = false
      }
      ExercisePickerView(routineModel: model)
    }
  }
  
  @ViewBuilder // MARK: - CANCEL Alert
  private var finishAlert: some View {
    Button("Resume", role: .cancel) {}
    Button("Quit", role: .destructive) {
      model.cancelRoutine()
      model.showingCancelAlert = false
    }
  }
}
