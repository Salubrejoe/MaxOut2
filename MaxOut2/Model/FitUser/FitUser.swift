
import Foundation

struct FitUser {
  static let mockup = FitUser(id: "")
  
  let id          : String
  var username    : String?
  var firstName   : String?
  var lastName    : String?
  var photoUrl    : String?
  let email       : String?
  let dateCreated : Date?
  
  init(from arm: AuthenticationResultModel) {
    self.id          = arm.uid
    self.username    = arm.displayName
    self.firstName   = nil
    self.lastName    = nil
    self.dateCreated = Date()
    self.photoUrl    = arm.photoURL
    self.email       = arm.email
  }
  
  init(
    id          : String,
    username    : String? = nil,
    firstName   : String? = nil,
    lastName    : String? = nil,
    dateCreated : Date? = nil,
    photoUrl    : String? = nil,
    email       : String? = nil
  ) {
    self.id          = id
    self.username    = username
    self.firstName   = firstName
    self.lastName    = lastName
    self.dateCreated = dateCreated
    self.photoUrl    = photoUrl
    self.email       = email
  }
  
  var dateCreatedShortString: String {
    guard let dateCreated else { return "No creation Date "}
    return dateCreated.formatted(date: .abbreviated, time: .shortened)
  }
}



// MARK: - CODABLE
extension FitUser: Codable {
  enum CodingKeys: String, CodingKey {
    case id
    case username
    case firstName
    case lastName
    case dateCreated
    case photoUrl
    case email
  }
  
  func encode(to encoder: Encoder) throws { var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encodeIfPresent(self.email,       forKey: .email)
    try container.encodeIfPresent(self.username,    forKey: .username)
    try container.encodeIfPresent(self.photoUrl,    forKey: .photoUrl)
    try container.encodeIfPresent(self.lastName,    forKey: .lastName)
    try container.encodeIfPresent(self.firstName,   forKey: .firstName)
    try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
  }
  
  init(from decoder: Decoder) throws { let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id          = try container.decode(String.self, forKey: .id)
    self.username    = try container.decodeIfPresent(String.self, forKey: .username)
    self.firstName   = try container.decodeIfPresent(String.self, forKey: .firstName)
    self.lastName    = try container.decodeIfPresent(String.self, forKey: .lastName)
    self.photoUrl    = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    self.email       = try container.decodeIfPresent(String.self, forKey: .email)
    self.dateCreated = try container.decodeIfPresent(Date.self,   forKey: .dateCreated)
  }
}
