//
//  CustomError.swift
//  myinbody
//
//  Created by Changyeol Seo on 10/16/23.
//

import Foundation
enum CustomError : Error {
    /** 익명 계정에서 로그아웃 */
    case anonymousSignOut
    /** 계정 탈퇴를 위한 인증에서 다른 아이디로 로그인함*/
    case wrongAccountSigninWhenLeave
    /** 포인트가 부족하다*/
    case notEnoughPoint
    /** 이미 등록된 태그*/
    case tagsAlreadyRegistered
    /** 코드 삭제하기 확인창 띄우기 */
    case deleteCodeConfirm
    /** 광고를 보고 포인트를 얻으세요 프롬프트 띄우기*/
    case watchAddAndEarnPointPrompt
    /** 텍스트가 비어있다 */
    case emptyText
    /** 이름 입력 안함*/
    case emptyName
    /** 전화번호 입력 안함*/
    case emptyPhoneNumber
    /** 제목 입력 안함 */
    case emptyTitle
    /** 테마 삭제*/
    case deleteTheme
}

extension CustomError {
    public var description : String {
        switch self {
        case .anonymousSignOut:
            return "anomymouse sign out"
        case .notEnoughPoint:
            return "Not enough Point"
        case .wrongAccountSigninWhenLeave:
            return "wrong account signin when leave"
        case .tagsAlreadyRegistered:
            return "Tags already registered"
        case .deleteCodeConfirm:
            return "delete code confirm"
        case .watchAddAndEarnPointPrompt:
            return "watchAddAndEarnPointPrompt"
        case .emptyText:
            return "emptyText"
        case .emptyName:
            return "empty name"
        case .emptyPhoneNumber:
            return "empty phonenumber"
        case .emptyTitle:
            return "empty title"
        case .deleteTheme:
            return "delete theme"
        }
    }
}

extension CustomError : LocalizedError {
    public var errorDescription:String? {
        switch self {
        case .notEnoughPoint:
            return NSLocalizedString("Not enough Point", comment: "Not enough Point")
        case .wrongAccountSigninWhenLeave:
            return NSLocalizedString("wrongAccountSigninWhenLeave msg", comment: "wrong acount sign in")
        case .anonymousSignOut:
            return NSLocalizedString("anomymouse sign out", comment: "signout")
        case .tagsAlreadyRegistered:
            return NSLocalizedString("Tags already registered", comment: "tag")
        case .deleteCodeConfirm:
            return NSLocalizedString("delete code confirm message", comment: "delete tag")
        case .watchAddAndEarnPointPrompt:
            return NSLocalizedString("watchAddAndEarnPointPrompt", comment: "watch ad")
        case .emptyText:
            return NSLocalizedString("empty text error msg", comment: "text input")
        case .emptyName:
            return NSLocalizedString("empty name error msg", comment: "text input")
        case .emptyPhoneNumber:
            return NSLocalizedString("empty phonenumber error msg", comment: "text input")
        case .emptyTitle:
            return NSLocalizedString("empty title error msg", comment: "text input")
        case .deleteTheme:
            return NSLocalizedString("delete theme msg", comment: "theme")
        }
    }
}
