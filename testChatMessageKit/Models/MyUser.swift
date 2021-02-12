//
//   MyUser.swift
//  testChatMessageKit
//
//  Created by Nikita on 8.02.21.
//

import Foundation
import FirebaseFirestore

struct MyUser: Hashable, Decodable {
    
    var username: String
    var email: String
    var description: String
    var sex: String
    var avatarStringURL: String
    var id: String
    
    
    init(username: String, email: String, description: String, sex: String, avatarStringURL: String, id: String) {
        self.username = username
        self.email = email
        self.description = description
        self.sex = sex
        self.avatarStringURL = avatarStringURL
        self.id = id
    }
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else { return nil }
        guard let username = data["username"] as? String,
              let email = data["email"] as? String,
              let description = data["description"] as? String,
              let sex = data["sex"] as? String,
              let avatarStringUrl = data["avatarStringURl"] as? String,
              let uid = data["uid"] as? String
        else { return nil }
        
        self.username = username
        self.email = email
        self.description = description
        self.sex = sex
        self.avatarStringURL = avatarStringUrl
        self.id = uid
    }
    
    var representation: [String: Any] {
        var rep = ["username": username]
        rep["email"] = email
        rep["description"] = description
        rep["sex"] = sex
        rep["avatarStringURl"] = avatarStringURL
        rep["uid"] = id
        return rep 
    }
    
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
 
