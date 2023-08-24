import SwiftUI
import HealthKit

struct SwiftUIView: View {
  @StateObject private var manager = HealthKitManager()
  
  var body: some View {
    List(HKWorkoutActivityType.allCases, id: \.self) {
      Text($0.commonName)
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIView()
  }
}
