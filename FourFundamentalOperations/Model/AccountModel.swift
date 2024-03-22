//
//  AccountModel.swift
//  QR-code-generator
//
//  Created by Changyeol Seo on 12/7/23.
//

import Foundation
struct AccountModel {
    let userId:String
    let accountRegDt:Date?
    let accountLastSigninDt:Date?
    let email:String?
    let phoneNumber:String?
    let photoURL:URL?
    let isAnonymous:Bool
}


extension AccountModel {
    
}
