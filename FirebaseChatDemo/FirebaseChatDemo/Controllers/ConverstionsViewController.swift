//
//  ViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit
import FirebaseAuth


struct Conversation {
    let id: String
    let name: String
    let otherEmail : String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date:String
    let text:String
    let isRead:Bool
}


class ConverstionsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var conversations = [Conversation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapnewChat))
        tableView.register(UINib(nibName: "ConversationTableViewCell", bundle: nil), forCellReuseIdentifier: "ConversationTableViewCell")
        startListeningForConversation()
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
    
    private func startListeningForConversation(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return 
        }
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        DatabaseManager.shared.getAllConversation(email: safeEmail, completion: {[weak self] result in
            switch result {
            case .success(let conversations):
                print("got converstion")
                guard !conversations.isEmpty else {
                    return
                }
                self?.conversations = conversations
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to get Conversation\(error)")
            }
            
        })
    }
}

extension ConverstionsViewController {
    @objc private func didTapnewChat() {
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
}

extension ConverstionsViewController : UITableViewDelegate {
    
    
}

extension ConverstionsViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationTableViewCell",for: indexPath) as? ConversationTableViewCell {
            cell.configure(model: model)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = conversations[indexPath.row]
        if let chatVC = self.storyboard?.instantiateViewController(withIdentifier: "chatViewController") as? ChatViewController {
            chatVC.title = "Hello"
            chatVC.userEmail = model.otherEmail
            chatVC.conversationId = model.id
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
