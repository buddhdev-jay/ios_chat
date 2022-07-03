//
//  RegisterViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Register"
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
   

}

extension RegisterViewController {
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text,!email.isEmpty,!password.isEmpty,password.count >= 6 else {
            alert(customMessage: "Email or Password is not Proper")
            return
        }
        
        DatabaseManager.shared.userExists(with: email, completion: { exists in
            guard !exists else {
                self.alert(customMessage: "User Already exist")
                return
            }
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion:{[weak self] authResult, error in
                guard let result = authResult, error == nil else {
                    print("error in creating error")
                    return
                }
                DatabaseManager.shared.insertUser(with: ChatAppUser(emailAddress: email),completion: { success in
                    if success {
                        let user = result.user
                        self?.alert(customMessage: "User Created: \(user.email)")
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.alert(customMessage: "Error in Creating User")
                    }
                })
//                let user = result.user
//                self?.alert(customMessage: "User Created: \(user.email)")
//                self?.navigationController?.popViewController(animated: true)
            })
        })
        
      
    }
}

// MARK: - UITextFieldDelegate
extension RegisterViewController :UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField :
            passwordTextField.becomeFirstResponder()
        case  passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
}
