

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
    
    private var waitingChatsRefference: CollectionReference {
        dataBase.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
    }
    
    var currentUser: MyUser!
    
    func getUserData(user: User, completion: @escaping (Result<MyUser, Error>) -> Void) {
        let docReference = usersRef.document(user.uid)
        docReference.getDocument { document , error  in
            if let document = document,
               document.exists {
                guard let myUser = MyUser(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToMyUser))
                    return
                }
                self.currentUser = myUser
                completion(.success(myUser))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
    
    func saveProfileWith(id: String, email: String, userName: String?, avatarImage: UIImage?, description: String?, sex: String?, completion: @escaping (Result<MyUser, Error>) -> Void) {
        
        guard Validator.isFilled(username: userName, description: description, sex: sex)
        else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        var myUser = MyUser(username: userName!,
                            email: email,
                            description: description!,
                            sex: sex!,
                            avatarStringURL: "Not exist",
                            id: id)
        
        guard avatarImage != #imageLiteral(resourceName: "avatar")  else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        FirebaseStorageService.shared.upload(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                myUser.avatarStringURL = url.absoluteString
                self.usersRef.document(myUser.id).setData(myUser.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(myUser))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        } // storageService
        
    } // saveProfileWith
    
    func createWaitingChat(message: String, recieverUser: MyUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = dataBase.collection(["users", recieverUser.id, "waitingChats"].joined(separator: "/"))
        let messageReference = reference.document(self.currentUser.id).collection("messages")
        
        
        let myMessage = MyMessage(user: currentUser, content: message )
        let chat = MyChat(friendUsername: currentUser.username,
                          friendAvatarStringURL: currentUser.avatarStringURL,
                          lastMessageContent: myMessage.content,
                          friendId: currentUser.id)
        
        reference.document(currentUser.id).setData(chat.representation) { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            messageReference.addDocument(data: myMessage.representation) { error  in
                if let error = error {
                    completion(.failure(error))
                }
                
                completion(.success(Void()))
                
            }
            
            
        }
    } // createWaitingChats
    
    
    func deleteWaitingChat(chat: MyChat, completion: @escaping (Result<Void, Error>) -> Void) {
        waitingChatsRefference.document(chat.friendId).delete { error  in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.deleteMessages(myChat: chat, completion: completion)
        }
    }
    
    private func deleteMessages(myChat: MyChat, completion: @escaping (Result<Void, Error>) -> Void) {
        let reference = waitingChatsRefference.document(myChat.friendId).collection("messages")
        getWaitingChatMessages(myChat: myChat) { result in
            switch result {
            case .success(let messages ):
                for message in messages {
                    guard let documentId = message.id else { return }
                    let messageRefference = reference.document(documentId)
                    messageRefference.delete { error  in
                        if let error = error {
                            completion(.failure(error))
                        }
                        completion(.success(Void()))
                    }
                }
            case .failure(let error ):
                completion(.failure(error))
            }
        }
    }
    
    private func getWaitingChatMessages(myChat: MyChat, completion: @escaping (Result<[MyMessage], Error>) -> Void) {
        
        let reference = waitingChatsRefference.document(myChat.friendId).collection("messages")
        var messages: [MyMessage] = []
        
        reference.getDocuments { querySnapshot, error  in
            if let error = error {
                completion(.failure(error))
                return
            }
            for document in querySnapshot!.documents {
                guard let message = MyMessage(document: document) else { return }
                messages.append(message)
            }
            completion(.success(messages))
        }
    }
}
