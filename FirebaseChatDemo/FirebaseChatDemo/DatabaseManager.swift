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
        //var safeEmail = email.replacingOccurrences(of: ".", with: "-")
    
        
        database.child(email).observeSingleEvent(of: .value, with: {DataSnapshot in
            guard DataSnapshot.value as? String != nil else {
               completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.emailAddress).setValue([
            "email_address" : user.safeEmail
        ])
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
