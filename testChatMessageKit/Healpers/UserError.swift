//
//  UserError.swift
//  testChatMessageKit
//
//  Created by Nikita on 11.02.21.
//

import Foundation


enum UserError {
    case notFilled
    case photoNotExist
    case cannotGetUserInfo
    case cannotUnwrapToMyUser
}


extension UserError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .photoNotExist:
            return NSLocalizedString("Пользователь не выбрал фотографию", comment: "")
        case .cannotGetUserInfo:
            return NSLocalizedString("Невозможно загрузить инфомрацию о пользователе", comment: "")
        case .cannotUnwrapToMyUser:
            return NSLocalizedString("Невозможно конвертировать MyUser из User", comment: "")
        }
    }
}
