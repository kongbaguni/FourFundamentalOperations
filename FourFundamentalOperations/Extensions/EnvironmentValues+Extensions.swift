//
//  EnvironmentValues+Extensions.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/2/24.
//

import Foundation
import SwiftUI
public extension EnvironmentValues {
   var isPreview: Bool {
      #if DEBUG
      return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
      #else
      return false
      #endif
   }
}
