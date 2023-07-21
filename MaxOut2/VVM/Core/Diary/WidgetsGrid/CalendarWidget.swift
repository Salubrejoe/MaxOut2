import SwiftUI


struct CalendarWidget: View {
  @EnvironmentObject var model: HistoryViewModel
  
  var body: some View {
    GroupBox {
      HStack {
        WidgetCalendarView(widgetData: model.widgetData, size: 90)
        Spacer()
      }
    }
    .groupBoxStyle(RegularMaterialStyle())
  }
}

struct CalendarGridData: Identifiable, Equatable {
  var id: String { date.description }
  let opacity: Double
  let date: Date
}

struct WidgetCalendarView: View {
  let widgetData: [CalendarGridData]?
  let size: CGFloat
  var body: some View {
    VStack(alignment: .leading) {
      grid
        .background(ContainerRelativeShape().fill(Color.clear))
      Text("last 50 days")
        .font(.caption)
        .foregroundColor(.secondary)
      
      Text("12983 kg")
        .font(.title)
        .foregroundColor(.primary)
    }
  }
}

extension WidgetCalendarView {
  
  @ViewBuilder
  private var grid: some View {
    Group {
      GeometryReader() { proxy in
        LazyHGrid(rows: rows(proxy), spacing: spacing(proxy)) {
          if let widgetData {
            ForEach(widgetData) { datum in
              Circle()
                .frame(width: size(proxy), height: size(proxy))
                .foregroundStyle(Color.primary.gradient.shadow(.inner(radius: 3)))
                .opacity(datum.opacity != 0 ? 1 : 0.1)
            }
          }
        }
        .frame(width: edge(proxy), height: edge(proxy))
      }
    }
    .frame(width: size)
    .frame(height: size)
  }
  
  private func rows(_ proxy: GeometryProxy) -> [GridItem] {
    [
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy)),
      GridItem(.fixed(size(proxy)), spacing: spacing(proxy))
    ]
  }
  
  private func size(_ proxy: GeometryProxy) -> CGFloat {
    let containerWidth = proxy.size.width
    let dayWidth = containerWidth / 7
    return dayWidth * 3 / 4
  }
  
  private func spacing(_ proxy: GeometryProxy) -> CGFloat {
    size(proxy) / 3
  }
  
  func edge(_ proxy: GeometryProxy) -> CGFloat {
    let totalSpacing = spacing(proxy) * 6
    let totalDaysHeight = size(proxy) * 7
    return totalSpacing + totalDaysHeight
  }
}

//struct WidgetCalendarView_Previews: PreviewProvider {
//  static var previews: some View {
//    Group {
//      WidgetCalendarView(widgetData: controller., size: <#T##CGFloat#>size: 90)
//    }
//  }
//}


