import SwiftUI

struct WidgetGrid: View {
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
        CardView("Exercise Minutes", color: .exerciseRing) {
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
  let link: String?
  let color: Color
  let content: () -> Content

  init(_ text: String, link: String? = nil, color: Color, content: @escaping () -> Content) {
    self.text = text
    self.link = link
    self.color = color
    self.content = content
  }
  
  var body: some View {
    GroupBox {
      VStack(alignment: .leading, spacing: 0) {
        Text(text)
          .fontWeight(.semibold)
          .foregroundColor(color)
        content()
          .padding(.top, 5)
      }
      .padding(.leading, 7)
    }
    .groupBoxStyle(TransparentGroupBox())
  }
}

struct TransparentGroupBox: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .frame(maxWidth: 329)
      .frame(maxHeight: 155)
      .padding(.horizontal, 14)
      .padding(.vertical, 12)
      .background(RoundedRectangle(cornerRadius: 17).fill(.regularMaterial))
  }
}
