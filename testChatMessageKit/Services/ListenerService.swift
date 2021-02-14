//
//  ListenerService.swift
//  testChatMessageKit
//
//  Created by Nikita on 14.02.21.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore

class ListenerService {
    
    static let shared = ListenerService()
    private init() {}
    
    private let database = Firestore.firestore()
    private var usersRef: CollectionReference {
        database.collection("users")
    }
    private var currentUserId: String {
        Auth.auth().currentUser!.uid
    }
    
    func usersObserve(users: [MyUser],  completion: @escaping (Result<[MyUser], Error>) -> Void) -> ListenerRegistration?  {
        
        var users = users
        
        let usersListener = usersRef.addSnapshotListener { querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { difference in
                guard let myUser = MyUser(document: difference.document) else { return }
                
                switch difference.type {
                case .added:
                    guard !users.contains(myUser),
                          myUser.id != self.currentUserId
                    else { return }
                    users.append(myUser)
                case .modified:
                    guard let index = users.firstIndex(of: myUser) else { return }
                    users[index] = myUser
                case .removed:
                    guard let index = users.firstIndex(of: myUser) else { return }
                    users.remove(at: index)
                }
            } // forEach

            completion(.success(users))
            
        } //usersObserve
        
        return usersListener
    }
    
    
    func waitingChatsObserve(chats: [MyChat],  completion: @escaping (Result<[MyChat], Error>) -> Void) -> ListenerRegistration?  {
        
        var chats = chats
        let chatsReference = database.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
        let chatsListener = chatsReference.addSnapshotListener { querySnapshot , error  in
            guard let snapshot = querySnapshot else {
                completion(.failure(error!))
                return
            }
            
            snapshot.documentChanges.forEach { difference in
                guard let myChat = MyChat(document: difference.document) else { return }
                
                switch difference.type {
                case .added:
                    guard !chats.contains(myChat)  else { return }
                    chats.append(myChat)
                case .modified:
                    guard let index = chats.firstIndex(of: myChat) else { return }
                    chats[index] = myChat
                case .removed:
                    guard let index = chats.firstIndex(of: myChat) else { return }
                    chats.remove(at: index)
                }
            }
            completion(.success(chats))
        }
        return chatsListener
    } //waitingChatsObserve
    
}
