
import SwiftUI

struct NavBarTitlePK: PreferenceKey {
  static var defaultValue: String = ""
  
  static func reduce(value: inout String, nextValue: () -> String) {
    value = nextValue()
  }
}

struct NavBarSubtitlePK: PreferenceKey {
  static var defaultValue: String? = nil
  
  static func reduce(value: inout String?, nextValue: () -> String?) {
    value = nextValue()
  }
}

struct NavBarBackButtonHiddenPK: PreferenceKey {
  static var defaultValue: Bool = false

  static func reduce(value: inout Bool, nextValue: () -> Bool) {
    value = nextValue()
  }
}


extension View {
  
  func navTitle(_ title: String) -> some View {
    self.preference(key: NavBarTitlePK.self, value: title)
  }
  
  func navSubtitle(_ subtitle: String?) -> some View {
    self.preference(key: NavBarSubtitlePK.self, value: subtitle)
  }
  
  func navBarBackButtonHidden(_ hidden: Bool) -> some View {
    self.preference(key: NavBarBackButtonHiddenPK.self, value: hidden)
  }
  
  func navBarItems(_ title: String = "", subtitle: String? = nil, backButtonHidden hidden: Bool = false) -> some View {
    self
      .navTitle(title)
      .navSubtitle(subtitle)
      .navBarBackButtonHidden(hidden)
  }
}
