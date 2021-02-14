


import Foundation


protocol WaitingChatsNavigationDelegate: class {
    func remove(waitingChat: MyChat)
    func changeToActive(waitingChat: MyChat)
}
