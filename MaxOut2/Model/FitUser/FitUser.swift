
import Foundation

struct FitUser {
  static let mockup = FitUser(id: "", username: "", firstName: "", lastName: "", dateCreated: Date(), photoUrl: nil, email: "X@spaghetti.man", weight: "75", height: "178", dateOfBirth: Date(timeIntervalSince1970: 623_721_600))
  
  let id          : String
  var username    : String?
  var firstName   : String?
  var lastName    : String?
  var photoUrl    : String?
  let email       : String?
  let dateCreated : Date?
  
  var weight      : String?
  var height      : String?
  
  var dateOfBirth : Date?
  
  var color       : String?
  
  init(from arm: AuthenticationResultModel) {
    self.id          = arm.uid
    self.username    = arm.displayName
    self.firstName   = nil
    self.lastName    = nil
    self.dateCreated = Date()
    self.photoUrl    = arm.photoURL
    self.email       = arm.email
    self.weight      = nil
    self.height      = nil
    self.dateOfBirth = nil
    self.color       = nil
  }
  
  init(
    id          : String,
    username    : String? = nil,
    firstName   : String? = nil,
    lastName    : String? = nil,
    dateCreated : Date?   = nil,
    photoUrl    : String? = nil,
    email       : String? = nil,
    weight      : String? = nil,
    height      : String? = nil,
    color       : String? = nil,
    dateOfBirth : Date?   = nil
  ) {
    self.id          = id
    self.username    = username
    self.firstName   = firstName
    self.lastName    = lastName
    self.dateCreated = dateCreated
    self.photoUrl    = photoUrl
    self.email       = email
    self.weight      = nil
    self.height      = nil
    self.color       = nil
    self.dateOfBirth = nil
  }
}

extension FitUser {
  var firstLetter: String {
    if let username = username, !username.isEmpty {
      return String(username.prefix(1))
    } else if let firstName = firstName, !firstName.isEmpty {
      return String(firstName.prefix(1))
    } else if let email = email, !email.isEmpty {
      return String(email.prefix(1))
    } else {
      return ""
    }
  }
  
  // MARK: - COMPUTED PROPERTIES
  var displayName: String {
    if let username = self.username, username.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
      return username }
    if let firstName = self.firstName, firstName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
      return firstName }
    if let lastName = self.lastName, lastName.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
      return lastName }
    return emailUsername
  }
  
  var displayLetter: String {
    guard displayName.count > 0 else { return "" }
    return String(displayName.trimmingCharacters(in: .whitespacesAndNewlines).first!)
  }
  
  var emailUsername: String {
    guard let email, let atIndex = email.firstIndex(of: "@") else { return "" }
    
    let username = email.prefix(upTo: atIndex)
    return String(username)
  }
  
  var dateCreatedShortString: String {
    guard let dateCreated else { return "No creation Date "}
    return dateCreated.formatted(date: .abbreviated, time: .shortened)
  }
  
  var ageString: String {
    guard let dateOfBirth else { return "" }
    let calendar = Calendar.current
    let yearOfBirth = calendar.component(.year, from: dateOfBirth)
    let currentYear = calendar.component(.year, from: Date())
    let result = currentYear - yearOfBirth
    return "🎂 \(result) years old   •"
  }
  
  var heightString: String {
    guard let height else { return "" }
    return height + " cm"
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
    case weight
    case height
    case dateOfBirth
    case color
  }
  
  func encode(to encoder: Encoder) throws { var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.id, forKey: .id)
    try container.encodeIfPresent(self.email,       forKey: .email)
    try container.encodeIfPresent(self.username,    forKey: .username)
    try container.encodeIfPresent(self.photoUrl,    forKey: .photoUrl)
    try container.encodeIfPresent(self.lastName,    forKey: .lastName)
    try container.encodeIfPresent(self.firstName,   forKey: .firstName)
    try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
    try container.encodeIfPresent(self.weight,      forKey: .weight)
    try container.encodeIfPresent(self.color,       forKey: .color)
    try container.encodeIfPresent(self.height,      forKey: .height)
    try container.encodeIfPresent(self.dateOfBirth, forKey: .dateOfBirth)
  }
  
  init(from decoder: Decoder) throws { let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id          = try container.decode(String.self, forKey: .id)
    self.username    = try container.decodeIfPresent(String.self, forKey: .username)
    self.firstName   = try container.decodeIfPresent(String.self, forKey: .firstName)
    self.lastName    = try container.decodeIfPresent(String.self, forKey: .lastName)
    self.photoUrl    = try container.decodeIfPresent(String.self, forKey: .photoUrl)
    self.email       = try container.decodeIfPresent(String.self, forKey: .email)
    self.dateCreated = try container.decodeIfPresent(Date.self,   forKey: .dateCreated)
    self.dateOfBirth = try container.decodeIfPresent(Date.self,   forKey: .dateOfBirth)
    self.weight      = try container.decodeIfPresent(String.self, forKey: .weight)
    self.height      = try container.decodeIfPresent(String.self, forKey: .height)
    self.color       = try container.decodeIfPresent(String.self, forKey: .color)
    
  }
}
