import WidgetKit
import HealthKit
import SwiftUI

let pad: CGFloat = 9

struct WorkoutMediumWidget: View {
  let data: RepresentableWorkout
  
  var body: some View {
    VStack {
      HStack {
        something
        
      }
      .padding(pad)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .clipShape(ContainerRelativeShape())
  }
  
  @ViewBuilder
  private var something: some View {
    VStack(alignment: .leading) {
      Label(data.activityType.commonName.capitalized,
            systemImage: data.activityType.sfSymbol)
      .font(.headline)
      .padding(6)
      .background(
        ContainerRelativeShape().fill(.orange)
      )
      Spacer(minLength: 0)
      HStack(alignment: .firstTextBaseline) {
        if let km = data.km {
          Text(km)
            .font(.largeTitle.bold())
          Text("km")
            .font(.title)
            .foregroundColor(.secondary)
        }
        Spacer(minLength: 0)
        Text(data.minutes)
          .font(.largeTitle.bold())
        Text("min")
          .font(.title)
          .foregroundColor(.secondary)
      }
      .padding(.horizontal, pad)
      .background(
        ContainerRelativeShape().fill(.primary.opacity(0.1))
      )
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(pad)
    .background(
      ContainerRelativeShape().fill(.yellow)
    )
  }
}

struct WorkoutMediumWidget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      WorkoutMediumWidget(data: RepresentableWorkout.previewData)
        .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
  }
}
