//
//  ViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import FirebaseAuth

class ConverstionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapnewChat))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController {
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }

}

extension ConverstionsViewController {
    @objc private func didTapnewChat() {
        if let newChatVC = self.storyboard?.instantiateViewController(withIdentifier: "newConverstionViewController") as? NewConverstionViewController {
            self.navigationController?.pushViewController(newChatVC, animated: true)
        }
        
    }
}

extension ConverstionsViewController : UITableViewDelegate {
    
    
}

extension ConverstionsViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController {
            chatVC.title = "Hello"
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
