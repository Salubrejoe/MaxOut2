import SwiftUI
import HealthKit

struct WidgetGrid: View {
  var body: some View {
    ScrollView(showsIndicators: false) {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 300))], spacing: 20) {
        MediumCardView("Exercise Minutes", color: .exerciseRing, style: RegularMaterialStyle()) {
          NavigationLink {
            HistoryView()
          } label: {
            ExerciseMinutesWidget()
              .environmentObject(HealthKitManager())
          }

        }
        MediumCardView("Body Mass", color: .primary, style: RegularMaterialStyle()) {
          BodyMassChart()
            .environmentObject(HealthKitManager())
        }
      }
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 155))]) {
        SmallCardView("Strength", emoji: HKWorkoutActivityType.traditionalStrengthTraining.associatedEmoji, color: .exerciseRing, style: RegularMaterialStyle()) {
          Text("43 kg").font(.largeTitle)
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


// MARK: - CARD VIEW
struct MediumCardView<Content: View, Style: GroupBoxStyle>: View {
  
  let text: String
  let link: String?
  let color: Color
  let style: Style
  let content: () -> Content

  init(_ text: String, link: String? = nil, color: Color, style: Style, content: @escaping () -> Content) {
    self.text = text
    self.link = link
    self.color = color
    self.style = style
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
    .frame(width: 329)
    .frame(height: 155)
    .groupBoxStyle(style)
  }
}

// MARK: - SMALL CARD VIEW
struct SmallCardView<Content: View, Style: GroupBoxStyle>: View {
  
  let text: String
  let emoji: String?
  let color: Color
  let style: Style
  let content: () -> Content
  
  init(_ text: String, emoji: String? = nil, color: Color, style: Style, content: @escaping () -> Content) {
    self.text = text
    self.emoji = emoji
    self.color = color
    self.style = style
    self.content = content
  }
  
  var body: some View {
    GroupBox {
      VStack(alignment: .leading, spacing: 0) {
        HStack {
          Text(text)
            .fontWeight(.semibold)
            .foregroundColor(color)
          Spacer()
          Text(emoji ?? "")
        }
        content()
          .padding(.top, 5)
      }
      .padding(.leading, 7)
    }
    .frame(width: 155)
    .frame(height: 155)
    .groupBoxStyle(style)
  }
}

struct RegularMaterialStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding()
      .background(.regularMaterial)
      .cornerRadius(14)
  }
}

struct BlackMaterialStyle: GroupBoxStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.content
      .padding()
      .background(Color.black.opacity(0.2))
      .cornerRadius(14)
  }
}

