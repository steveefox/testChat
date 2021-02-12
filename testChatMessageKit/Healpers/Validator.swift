//
//  Validator.swift
//  testChatMessageKit
//
//  Created by Nikita on 11.02.21.
//

import Foundation


class Validator {
    
    static func isFilled(email: String?, password: String?, confirmPassword: String?) -> Bool {
        
        guard let password = password, let confirmPassword = confirmPassword, let email = email,
              !password.isEmpty, !confirmPassword.isEmpty, !email.isEmpty
        else { return false }
        
        return true
    }
    
    static func isFilled(username: String?, description: String?, sex: String?) -> Bool {
        
        guard let description = description,
              let sex = sex,
              let username = username,
              !description.isEmpty,
              !sex.isEmpty,
              !username.isEmpty
        else { return false }
        
        return true
    }
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
