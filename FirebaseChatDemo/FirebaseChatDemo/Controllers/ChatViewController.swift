//
//  ChatViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController {

    private var messages = [Message]()
    
    public var isNewConverstion  = false
    public var userEmail:String = ""
    public var conversationId:String?
    private var selfSender: Sender?  {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        return Sender(senderId: safeEmail as! String, displayName: "abc")
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //messages.append(Message(sender: sender, messageId: "1", sentDate: Date(), kind: .text("Hello")))
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessage(id: conversationId)
        }
       
    }
    

}

extension ChatViewController {
    private func listenForMessage(id :String){
        DatabaseManager.shared.getAllMessagesForConversation(id: id, completion: { [weak self] result in
            switch result {
            case .success(let messages):
                guard !messages.isEmpty else {
                    return
                }
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                }
            
            case .failure(let error):
                print("Failer")
            }
            
        })
    }
    
}

extension ChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty, let selfSender = self.selfSender, let messageId = createMessage() else {
            return
        }
        print("Text \(text)")
        let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
        if isNewConverstion {
            let message = Message(sender: selfSender, messageId: messageId, sentDate: Date(), kind: .text(text))
            DatabaseManager.shared.createNewConversation(otherEmail: userEmail,name: self.title ?? "abc", firstMessage: message, completion: { [weak self] success in
                if success {
                    print("Message send")
                    self?.isNewConverstion = false
                } else {
                    print("Message Failed")
                }
            })
        }
        else {
            guard let conversationId = conversationId else {
                return
            }
            DatabaseManager.shared.sendMessage(converstion: conversationId,otherEmail:userEmail, name: "abc", newMessage: message, completion: {success in
                    if success {
                        print("sucess")
                    } else {
                        print("failer")
                    }
            })
        }
    }
    
    private func createMessage() -> String?  {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }
        var safeEmail = currentUserEmail.replacingOccurrences(of: ".", with: "-")
        let newId = "\(userEmail)_\(safeEmail)_\(Date())"
        return newId
    }
}
extension ChatViewController : MessagesDataSource {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        return Sender(senderId: "abc@gmail.com", displayName: "abc")
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
    public var sender: SenderType
   public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}
