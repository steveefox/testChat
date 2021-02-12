//
//  FireStoreService.swift
//  testChatMessageKit
//
//  Created by Nikita on 11.02.21.
//

import Foundation
import Firebase
import FirebaseFirestore


class FirestoreService {
    
    static let shared = FirestoreService()
    private init () {}
    
    
    let dataBase = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        dataBase.collection("users")
    }
    
    func getUserData(user: User, completion: @escaping (Result<MyUser, Error>) -> Void) {
        let docReference = usersRef.document(user.uid)
        docReference.getDocument { document , error  in
            if let document = document,
               document.exists {
                guard let myUser = MyUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMyUser))
                    return
                }
                completion(.success(myUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarImageString: String?, description: String?, sex: String?, completion: @escaping (Result<MyUser, Error>) -> Void) {
        
        guard Validator.isFilled(username: userName, description: description, sex: sex)
        else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        let myUser = MyUser(username: userName!,
                            email: email,
                            description: description!,
                            sex: sex!,
                            avatarStringURL: "Not exist",
                            id: id)
        
        self.usersRef.document(myUser.id).setData(myUser.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(myUser))
            }
        }
        
    }
    
    
}
