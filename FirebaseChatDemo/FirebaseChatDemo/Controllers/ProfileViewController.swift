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
            self.navigationController?.pushViewController(newChatVC, animated: true)
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
