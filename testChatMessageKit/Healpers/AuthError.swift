//
//  AuthError.swift
//  testChatMessageKit
//
//  Created by Nikita on 11.02.21.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case passwordNotMatched
    case unknownedError
    case serverError
    
}


extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Формат почты не является допустимым", comment: "")
        case .passwordNotMatched:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unknownedError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        }
    }
}
