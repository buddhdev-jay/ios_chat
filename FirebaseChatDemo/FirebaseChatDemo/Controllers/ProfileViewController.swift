//
//  ProfileViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import FirebaseAuth
class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func newConvwerstionButtonTapped(_ sender: Any) {
        if let newChatVC = self.storyboard?.instantiateViewController(withIdentifier: "newConverstionViewController") as? NewConverstionViewController {
            newChatVC.completion = { [weak self] result in
                print("\(result)")
                self?.createNewConverstion(result: result)
            }
            self.navigationController?.pushViewController(newChatVC, animated: true)
        }
    }
    private func createNewConverstion(result: [String:String]) {
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController {
            guard let email = result["email"] else {
                return
            }
            chatVC.title = email
            chatVC.isNewConverstion = true
            chatVC.userEmail = email
            chatVC.conversationId = nil
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        catch {
            debugPrint("Error")
        }
        
        
    }
}
