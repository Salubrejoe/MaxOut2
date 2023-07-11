
import Foundation


extension Bundle {
  func decode<T: Codable>(_ file: String) -> T {
    guard let url = self.url(forResource: file, withExtension: nil) else {
      fatalError("Failed to locate \(file) in bundle")
    }
    
    guard let data = try? Data(contentsOf: url) else {
      fatalError("Failed to load \(file) in bundle")
    }
    
    let decoder = JSONDecoder()
    let formatter = DateFormatter()
    formatter.dateFormat = "y-MM-dd"
    decoder.dateDecodingStrategy = .formatted(formatter)
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      fatalError("Error cazzomerda: \n \(error)")
    }
//    guard let decodedData = try? decoder.decode(T.self, from: data) else {
//      fatalError("Failed to decode \(file) from bundle")
//    }
    
//    return decodedData
  }
  
//  func export(_ file: ExercisesArray) {
//    guard let url = self.url(forResource: "exercises_with_id", withExtension: "json") else {
//      fatalError("Failed to locate \(file) in bundle")
//    }
//
//
//    let encoder = JSONEncoder()
//    encoder.outputFormatting = .prettyPrinted
//
//    if let encodedData = try? encoder.encode(file) {
//      do {
//        try encodedData.write(to: url)
//      }
//      catch {
//        print("Failed to write JSON data: \(error.localizedDescription)")
//      }
//    }
//  }
}
