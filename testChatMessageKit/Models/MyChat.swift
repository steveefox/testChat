//
//  MyChat.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import Foundation


struct MyChat: Hashable, Decodable {
    var username: String
    var userImageString: String
    var lastMessage: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: MyChat, rhs: MyChat) -> Bool {
        return lhs.id == rhs.id
    }
}
