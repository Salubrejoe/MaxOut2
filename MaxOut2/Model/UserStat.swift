import Foundation

struct ChartsData: Codable {
  var userStats: [UserStat]
}

struct UserStat: Identifiable, Codable {
  var id           : String { exerciseId }
  let exerciseId   : String
  let exerciseName : String
  let activityType : String
  
  var bestVolumeDP  : [DataPoint]
  var totalVolumeDP : [DataPoint]
  var speedDP       : [DataPoint]
  var durationDP    : [DataPoint]
  
  enum CodingKeys: String, CodingKey {
    case exerciseId
    case exerciseName
    case activityType
    case bestVolumeDP
    case totalVolumeDP
    case speedDP
    case durationDP
  }
}

struct DataPoint: Identifiable, Codable {
  var id: String { x.description }
  let x: Date
  let y: Double
  
  enum CodingKeys: String, CodingKey {
    case x
    case y
  }
}
//
//final class ChartStatsManager {
//  let fileManager = FileManager.default
//  private let documentsDirectory: URL
//  private let fileUrl: URL
//  
//  init() {
//    self.documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
//    self.fileUrl = documentsDirectory.appendingPathComponent("chartStatsData.json")
//    print(fileUrl)
//  }
//  
//  func encode(_ chartsData: ChartsData) {
//    do {
//      let jsonEncoder = JSONEncoder()
//      let jsonData = try jsonEncoder.encode(chartsData)
//      
//      try jsonData.write(to: fileUrl)
//    } catch {
//      print("Error encoding data: \(error)")
//    }
//  }
//  
//  func decodedChartStats() -> ChartsData? {
//    do {
//      let jsonData = try Data(contentsOf: fileUrl)
//      
//      let jsonDecoder = JSONDecoder()
//      let data = try jsonDecoder.decode(ChartsData.self, from: jsonData)
//      return data
//    } catch {
//      print("Error decoding data: \(error)")
//      return nil
//    }
//  }
//  
//  func updateStats(_ newStats: [UserStat]) {
//    guard var oldStats = decodedChartStats()?.userStats else {
//      encode(ChartsData(userStats: newStats))
//      return
//    }
//    
//    for newStat in newStats {
//      if let index = oldStats.firstIndex(where: { $0.id == newStat.id }) {
//        var updatedStat = oldStats[index]
//        updatedStat.dataPoints.append(contentsOf: newStat.dataPoints)
//        
//        oldStats[index] = updatedStat
//      } else {
//        oldStats.append(newStat)
//      }
//    }
//    
//    encode(ChartsData(userStats: oldStats))
//  }
//}
