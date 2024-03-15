//
//  URLCache+Extensions.swift
//  FourFundamentalOperations
//
//  Created by Changyeol Seo on 3/15/24.
//

import Foundation
extension URLCache {    
    static let imageCache = URLCache(memoryCapacity: 512*1000*1000, diskCapacity: 10*1000*1000*1000)
}
