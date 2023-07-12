
import Foundation


// MARK: - This allows me to modify the user in Profile view, together with the static mockups
///Ultimately the API doesn't allow this - but there is a very simple and versatile workaround:
extension Optional where Wrapped == String {
  var _bound: String? {
    get {
      return self
    }
    set {
      self = newValue
    }
  }
  public var bound: String {
    get {
      return _bound ?? ""
    }
    set {
      _bound = newValue.isEmpty ? nil : newValue
    }
  }
} ///This allows you to keep the optional while making it compatible with Bindings: $test.bound
