//
//  Int+Extensions.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 4/1/24.
//

import Foundation
extension Int {
    static func random(digits: Int) -> Int {
        guard digits > 0 else {
            fatalError("Number of digits must be greater than 0")
        }
        
        let minBound = Int(pow(10, Double(digits - 1)))
        let maxBound = Int(pow(10, Double(digits))) - 1
        
        return Int(arc4random_uniform(UInt32(maxBound - minBound + 1))) + minBound
    }
}
