//
//  DatabaseManager.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}


// Chat Functions
extension DatabaseManager {
    
    public func createNewConversation(otherEmail :String,name: String, firstMessage: Message , completion: @escaping(Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey:"email") as? String else {
            return
        }
        var safeEmail = currentEmail.replacingOccurrences(of: ".", with: "-")
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value, with: {[weak self] DataSnapshot in
            guard var userNode = DataSnapshot.value as? [String:Any] else {
                completion(false)
                return
            }
            let messageDate = firstMessage.sentDate
            var message = ""
            switch firstMessage.kind {
                
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            let conversationId =  "conversations_\(firstMessage.messageId)"
            let newConverstionData :[String:Any] = [
                "id" :conversationId,
                "other_user_email": otherEmail,
                "name" : name,
                "latest_message": [
                    "date" :"4/7/2022",
                    "message" : message,
                    "is_read": false
                    
                ]
            ]
            
            let recipient_newConverstionData :[String:Any] = [
                "id" :conversationId,
                "other_user_email": safeEmail,
                "name" : "Me",
                "latest_message": [
                    "date" :"4/7/2022",
                    "message" : message,
                    "is_read": false
                    
                ]
            ]
            //update recipient user entry
            self?.database.child("\(otherEmail)/conversations").observeSingleEvent(of:.value ,with: { [weak self] DataSnapshot in
                if var conversations = DataSnapshot.value as? [[String:Any]] {
                    conversations.append(recipient_newConverstionData)
                    self?.database.child("\(otherEmail)/conversations").setValue(conversationId)
                }
                else {
                    self?.database.child("\(otherEmail)/conversations").setValue([recipient_newConverstionData])
                }
            })
            
            
            //Current User Entry
            if var converstion = userNode["conversations"] as? [[String:Any]] {
                converstion.append(newConverstionData)
                userNode["conversations"] = converstion
                ref.setValue(userNode, withCompletionBlock: {[weak self] error , _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                })
                
            } else {
                userNode["conversations"] = [
                newConverstionData
                ]
                ref.setValue(userNode, withCompletionBlock: { [weak self] error , _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name,conversationID: conversationId, firstMessage: firstMessage, completion: completion)
                })
            }
        })
        
    }
    
    private func finishCreatingConversation(name: String,conversationID: String,firstMessage: Message, completion: @escaping(Bool) -> Void ){
        
        var message = ""
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        guard let myEmail = UserDefaults.standard.value(forKey:"email") as? String else {
            completion(false)
            return
        }
        var safeEmail = myEmail.replacingOccurrences(of: ".", with: "-")
        let collectionMessage: [String:Any] = [
            "id":firstMessage.messageId,
            "type": "text",
            "content": message,
            "date":"4/7/2022",
            "sender_email":safeEmail,
            "isRead": false,
            "name" : name
        ]
        let value: [String:Any] = [
            "messages" : [
                collectionMessage
            ]
        ]
        database.child("\(conversationID)").setValue(value, withCompletionBlock: {error , _ in
            guard error == nil else {
                completion(false)
                return
            }
         completion(true)
        })
        
    }
    public func getAllConversation(email : String, completion: @escaping (Result<[Conversation],Error>) -> Void){
        database.child("\(email)/conversations").observe(.value, with: { DataSnapshot in
            guard let value = DataSnapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let convesationsId = dictionary["id"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String:Any],
                      let date = latestMessage["date"] as? String,
                    let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                    return nil
                }
                        
                 let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
                return Conversation(id: convesationsId, name: "abc", otherEmail: otherUserEmail, latestMessage: latestMessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    public func getAllMessagesForConversation(id :String, completion: @escaping(Result<[Message],Error>) -> Void){
        database.child("\(id)/messages").observe(.value, with: { DataSnapshot in
            guard let value = DataSnapshot.value as? [[String:Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String ,
                      let isRead = dictionary["isRead"] as? Bool,
                      let messageId = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                        let senderEmail = dictionary["sender_email"] as? String,
                        let type = dictionary["type"] as? String,
                        let dateString = dictionary["date"] as? String else {
                    return nil
                }
                let sender = Sender(senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageId, sentDate:Date(), kind: .text(content))
            })
            completion(.success(messages))
        })
    }
    
    public func sendMessage(converstion :String , otherEmail: String,name : String,newMessage : Message, completion: @escaping(Bool) -> Void){
        guard let myEmail = UserDefaults.standard.value(forKey:"email") as? String else {
            completion(false)
            return
        }
        var safeEmail = myEmail.replacingOccurrences(of: ".", with: "-")
        
        self.database.child("\(converstion)/messages").observeSingleEvent(of: .value, with: { DataSnapshot in
            guard var currentMessages = DataSnapshot.value as? [[String:Any]] else {
                completion(false)
                return
            }
            var message = ""
            switch newMessage.kind {
                
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            guard let myEmail = UserDefaults.standard.value(forKey:"email") as? String else {
                completion(false)
                return
            }
            var safeEmail = myEmail.replacingOccurrences(of: ".", with: "-")
            let newMessageEntry: [String:Any] = [
                "id":newMessage.messageId,
                "type": "text",
                "content": message,
                "date":"4/7/2022",
                "sender_email":safeEmail,
                "isRead": false,
                "name" : name
            ]
            currentMessages.append(newMessageEntry)
            self.database.child("\(converstion)/messages").setValue(currentMessages,withCompletionBlock: { error , _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                
                self.database.child("\(safeEmail)/conversation").observeSingleEvent(of: .value, with: { DataSnapshot in
                    guard var currentUserConversation = DataSnapshot.value as? [[String:Any]] else {
                        completion(false)
                        return
                    }
                     // for Finding latest message
                    let updatedValue : [String:Any] = [
                        "date":"4/7/2022",
                        "message" : message,
                        "is_read": false
                    ]
                    var targetConversation:[String:Any]?
                    var i = 0
                    for conversationDict in currentUserConversation {
                        if let currentId = conversationDict["id"] as? String, currentId == converstion {
                          targetConversation = conversationDict
                            break
                            
                        }
                        i += 1
                    }
                    targetConversation?["latest_message"] = updatedValue
                    guard let finalConversation = targetConversation else {
                        completion(false)
                        return
                    }
                    currentUserConversation[i] = finalConversation
                    self.database.child("\(safeEmail)/conversation").setValue(currentUserConversation, withCompletionBlock: { error , _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                })
                
            })
        })
    }
}

// Account
extension DatabaseManager {
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)){
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        
        
        database.child(safeEmail).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard DataSnapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser , completion: @escaping (Bool) -> Void ) {
        database.child(user.safeEmail).setValue([
            "email_address" : user.safeEmail
        ],withCompletionBlock: { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { DataSnapshot in
                if var usersCollection =  DataSnapshot.value as? [[String: String]] {
                    let newUser = [
                        "email" : user.safeEmail
                    ]
                    usersCollection.append(newUser)
                    self.database.child("users").setValue(usersCollection, withCompletionBlock: { error , _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
                else {
                    let newCollection: [[String:String]] = [
                        [
                            "email" : user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: { error , _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                }
            })
            
        })
    }
    
    public func getAllUsers(completion: @escaping(Result<[[String:String]],Error>) -> Void){
        database.child("users").observeSingleEvent(of: .value, with: { DataSnapshot in
            guard let value = DataSnapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    public enum DatabaseError : Error {
        case failedToFetch
    }
}
struct ChatAppUser {
    let emailAddress: String
    
    var safeEmail : String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
}
