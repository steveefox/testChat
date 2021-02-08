//
//   MyUser.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import Foundation


struct MyUser: Hashable, Decodable {
    
    
    var username: String
    var avatarStringURL: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MyUser, rhs: MyUser) -> Bool {
        return lhs.id == rhs.id
    }
    
    func contains(filterText: String?) -> Bool {
        guard let text = filterText, !text.isEmpty else { return true }
        let textLowerCased = text.lowercased()
        return username.lowercased().contains(textLowerCased)
    }
}
 
