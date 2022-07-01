//
//  LoginViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
   
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController :UITextFieldDelegate {
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

extension LoginViewController {
    
    @objc private func didTapRegister() {
        if let registerVC = self.storyboard?.instantiateViewController(withIdentifier: "registerViewController") as? RegisterViewController {
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextField.text,!email.isEmpty,!password.isEmpty,password.count >= 6 else {
            alert(customMessage: "Email or Password is not Proper")
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let result = authResult, error == nil else {
                print("error in Login")
                return
            }
            let user = result.user
            self?.alert(customMessage: "User Logged in : \(user.email)")
            UserDefaults.standard.set(email, forKey:"email")
            if let converstionVC = self?.storyboard?.instantiateViewController(withIdentifier: "registerViewController") as? ConverstionsViewController {
                self?.navigationController?.pushViewController(converstionVC, animated: true)
            }
        })
    }
}
