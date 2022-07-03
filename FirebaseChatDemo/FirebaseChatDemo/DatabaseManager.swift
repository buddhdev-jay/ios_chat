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
        
    }
}
struct ChatAppUser {
    let emailAddress: String
    
    var safeEmail : String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        return safeEmail
    }
}
