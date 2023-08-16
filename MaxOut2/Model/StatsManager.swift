import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class StatsManager {
  static let shared = StatsManager()
  private init() {}
  
  /// Useful shortcuts
  private func userStatsCollection(userId: String) -> CollectionReference {
    FitUserManager.shared
      .userDocument(id: userId)
      .collection("stats")
  }
  private func statDocument(statId: String, userId: String) -> DocumentReference {
    userStatsCollection(userId: userId)
      .document(statId)
  }
}


extension StatsManager {
  
  // MARK: - UPLOAD STAT
  func addToStats(stat: UserStat, for userId: String) async throws {
    let documentId = stat.exerciseId
    
    let firestoreStat = statDocument(statId: stat.id, userId: userId)
    
    let fs = try? await firestoreStat.getDocument(as: UserStat.self)
    
    var totalVolumeDict = [[String: Any]]()
    var bestVolumeDict  = [[String: Any]]()
    var durationDict    = [[String: Any]]()
    var speedDict       = [[String: Any]]()
    
    
    if let fs {
      let totalVolumeDataPoints = fs.totalVolumeDP + stat.totalVolumeDP
      let bestVolumeDataPoints = fs.bestVolumeDP + stat.bestVolumeDP
      let durationDataPoints = fs.durationDP + stat.durationDP
      let speedDataPoints = fs.speedDP + stat.speedDP
      
      totalVolumeDict = dictionary(for: totalVolumeDataPoints)
      bestVolumeDict  = dictionary(for: bestVolumeDataPoints)
      durationDict    = dictionary(for: durationDataPoints)
      speedDict       = dictionary(for: speedDataPoints)
    }
    else {
      totalVolumeDict = dictionary(for: stat.totalVolumeDP)
      bestVolumeDict  = dictionary(for: stat.bestVolumeDP)
      durationDict    = dictionary(for: stat.durationDP)
      speedDict       = dictionary(for: stat.speedDP)
    }
    
    
    let fields: [String: Any] = [
      UserStat.CodingKeys.totalVolumeDP.rawValue : totalVolumeDict,
      UserStat.CodingKeys.exerciseName.rawValue  : stat.exerciseName,
      UserStat.CodingKeys.bestVolumeDP.rawValue  : bestVolumeDict,
      UserStat.CodingKeys.exerciseId.rawValue    : stat.exerciseId,
      UserStat.CodingKeys.durationDP.rawValue    : durationDict,
      UserStat.CodingKeys.speedDP.rawValue       : speedDict,
      UserStat.CodingKeys.activityType.rawValue  : stat.activityType,
    ]
    
    try await userStatsCollection(userId: userId)
      .document(documentId)
      .setData(fields, merge: false)
  }
  
  func dictionary(for dataPoints: [DataPoint]) -> [[String: Any]] {
    var dPs : [[String: Any]] = []
    for dataPoint in dataPoints {
      let dict: [String: Any] = [
        DataPoint.CodingKeys.x.rawValue : dataPoint.x,
        DataPoint.CodingKeys.y.rawValue : dataPoint.y
      ]
      dPs.append(dict)
    }
    return dPs
  }
  
  func allStats() async throws -> [UserStat] {
    let userId = try FireAuthManager.shared.currentAuthenticatedUser().uid
    return try await userStatsCollection(userId: userId).getDocuments(as: UserStat.self)
  }
}
