//
//  CustomError.swift
//  myinbody
//
//  Created by Changyeol Seo on 10/16/23.
//

import Foundation
enum CustomError : Error {
    /** 로그인하지 않았음.*/
    case notAuth
    /** 익명 계정에서 로그아웃 */
    case anonymousSignOut
    /** 계정 탈퇴를 위한 인증에서 다른 아이디로 로그인함*/
    case wrongAccountSigninWhenLeave
    /** 텍스트가 비어있다 */
    case emptyText
        
}

extension CustomError {
    public var description : String {
        switch self {
        case .anonymousSignOut:
            return "anomymouse sign out"
        case .wrongAccountSigninWhenLeave:
            return "wrong account signin when leave"
        case .emptyText:
            return "emptyText"
        case .notAuth:
            return "notAuth"
        }
    }
}

extension CustomError : LocalizedError {
    public var errorDescription:String? {
        switch self {
        case .wrongAccountSigninWhenLeave:
            return NSLocalizedString("wrongAccountSigninWhenLeave msg", comment: "wrong acount sign in")
        case .anonymousSignOut:
            return NSLocalizedString("anomymouse sign out", comment: "signout")
        case .emptyText:
            return NSLocalizedString("empty text error msg", comment: "text input")
        case .notAuth:
            return NSLocalizedString("not Auth error msg", comment: "auth")
        }
    }
}
