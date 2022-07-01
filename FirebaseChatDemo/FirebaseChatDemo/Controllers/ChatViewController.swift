//
//  ChatViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import MessageKit

class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    private var sender = Sender(senderId: "1", displayName: "abc")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    

}
extension ChatViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        return sender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}

extension ChatViewController : MessagesLayoutDelegate {
    
}

extension ChatViewController : MessagesDisplayDelegate {
    
}
struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
