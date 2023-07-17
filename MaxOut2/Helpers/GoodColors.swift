import SwiftUI

let goodColors = [
  "#ff9ff3", "#f368e0", "#feca57", "#ff9f43", "#ff6b6b", "#ee5253", "#48dbfb", "#1dd1a1", "#1dd1a1", "#10ac84", "#5f27cd", "#01a3a4", "#C4E538", "#009432", "#009432", "#FFC312", "#F79F1F", "#12CBC4", "#D980FA"
]


// Init Color(hex:)
extension Color {
  init(hex: String) {
    // Remove the "#" character from the beginning of the string
    var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if hexString.hasPrefix("#") {
      hexString.remove(at: hexString.startIndex)
    }
    
    // Convert the hex string to a 6-digit integer
    var rgbValue: UInt64 = 0
    Scanner(string: hexString).scanHexInt64(&rgbValue)
    
    // Create a Color object from the integer value
    self.init(red: Double((rgbValue >> 16) & 0xFF) / 255.0,
              green: Double((rgbValue >> 8) & 0xFF) / 255.0,
              blue: Double(rgbValue & 0xFF) / 255.0)
  }
}
