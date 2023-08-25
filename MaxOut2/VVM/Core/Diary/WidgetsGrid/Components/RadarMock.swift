
import SwiftUI

let dimensions = [
  Ray(maxValue: 10, rayCase: .arms),
  Ray(maxValue: 10, rayCase: .chest),
  Ray(maxValue: 10, rayCase: .shoulders),
  Ray(maxValue: 10, rayCase: .back),
  Ray(maxValue: 10, rayCase: .core),
  Ray(maxValue: 10, rayCase: .legs),
]

let data = [
  PolygonData(shoulders: 3, arms: 7, chest: 4, back: 1, core: 7, legs: 5, color: .indigo),
  PolygonData(shoulders: 5, arms: 1, chest: 5, back: 5, core: 1, legs: 2, color: .blue),
  PolygonData(shoulders: 2, arms: 2, chest: 2, back: 1, core: 7, legs: 1, color: .purple),
]

struct RadarMock: View {
  var body: some View {
    RadarChart(size: 132,
               labelWidth: 0,
               mainColor: .secondary,
               subtleColor: .secondary,
               numberOfLines: 3,
               dimensions: dimensions,
               data: data)
  }
}

struct Content_Previews: PreviewProvider {
  static var previews: some View {
    RadarMock()
  }
}
