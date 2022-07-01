//
//  NewConverstionViewController.swift
//  FirebaseChatDemo
//
//  Created by Jay Buddhdev on 01/07/22.
//

import UIKit

class NewConverstionViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var users = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableview.delegate = self
        tableview.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissVc))
        // Do any additional setup after loading the view.
    }

}

extension NewConverstionViewController : UITableViewDelegate {
    
}

extension NewConverstionViewController :UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = "Hello world"
        return cell
    }
    
    
}

extension NewConverstionViewController {
    @objc private func dismissVc() {
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension NewConverstionViewController :UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !text.replacingOccurrences(of: "", with: "").isEmpty else {
            return
        }
        self.searchUsers(query: text)
    }
    func searchUsers(query: String){
        
    }
}
