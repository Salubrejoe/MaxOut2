import SwiftUI

struct ExerciseMinutesWidget: View {
  @ObservedObject var controller: ExerciseMinutesController
  
  var body: some View {
    ChartView(values: controller.values(), labels: controller.labels(), xAxisLabels: controller.xAxisLabels())
      .onAppear {
        controller.repository.requestAuthorization { success in
          print(success)
        }
      }
//      .frame(maxWidth:  329)
//      .frame(maxHeight: 155)
//      .padding(.bottom)
  }
}

struct ExerciseMinutesWidget_Previews: PreviewProvider {
  static var previews: some View {
    ExerciseMinutesWidget(controller: ExerciseMinutesController())
  }
}
