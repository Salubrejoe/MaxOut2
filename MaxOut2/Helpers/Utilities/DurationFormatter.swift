
import Foundation


class DurationFormatter: Formatter {
  override func string(for obj: Any?) -> String? {
    guard let duration = obj as? Double else {
      return nil
    }
    
    let minutes = Int(duration / 60)
    let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
    
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  override func editingString(for obj: Any) -> String? {
    return nil
  }
  
  override func getObjectValue(
    _ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?,
    for string: String,
    errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?
  ) -> Bool {
    
    let components = string.components(separatedBy: ":")
    
    guard components.count == 2,
          let minutes = Int(components[0]),
          let seconds = Int(components[1]) else {
      return false
    }
    
    let timeInterval = TimeInterval(minutes * 60 + seconds)
    
    obj?.pointee = timeInterval as AnyObject
    return true
  }
}
