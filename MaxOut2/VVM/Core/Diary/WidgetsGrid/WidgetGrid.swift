import SwiftUI

struct WidgetGrid: View {
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
        CardView("Exercise Time", color: .exerciseRing) {
          NavigationLink {
            HistoryView()
          } label: {
            ExerciseMinutesWidget()
              .environmentObject(HealthKitManager())
          }

        }
        CardView("Body Mass", color: .primary) {
          BodyMassChart()
            .environmentObject(HealthKitManager())
        }
      }
    }
  }
}

struct WidgetGrid_Previews: PreviewProvider {
  static var previews: some View {
    WidgetGrid()
  }
}

struct CardView<Content: View>: View {
  
  let text: String
  let color: Color
  let content: () -> Content

  init(_ text: String, color: Color, content: @escaping () -> Content) {
    self.text = text
    self.color = color
    self.content = content
  }
  
  var body: some View {
    GroupBox {
      VStack(alignment: .leading, spacing: 0) {
        Text(text).fontWeight(.semibold)
          .foregroundColor(color)
        content()
          .padding(.top, 3)
      }
      .padding(.leading, 7)
    }
    .frame(maxWidth: 329)
    .frame(maxHeight: 155)
    .cornerRadius(20)
  }
}
