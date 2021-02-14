//
//  MyMessage.swift
//  testChatMessageKit
//
//  Created by Nikita on 14.02.21.
//

import Foundation
import FirebaseFirestore


struct MyMessage: Hashable {
    let content: String
    let senderId: String
    let senderUserName: String
    let sendDate: Date
    var id: String?
    
    var representation: [String: Any] {
        let representation: [String: Any] = [
            "created": sendDate,
            "senderId": senderId,
            "senderName": senderUserName,
            "content": content
        ]
        return representation
    }
    
    init(user: MyUser, content: String) {
        self.content = content
        senderId = user.id
        senderUserName = user.username
        sendDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let sendDate = data["created"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderUserName = data["senderName"] as? String,
              let content = data["content"] as? String
        else { return nil}
        
        self.sendDate = sendDate.dateValue()
        self.senderId = senderId
        self.senderUserName = senderUserName
        self.id = document.documentID
        self.content = content
    }
    
}
