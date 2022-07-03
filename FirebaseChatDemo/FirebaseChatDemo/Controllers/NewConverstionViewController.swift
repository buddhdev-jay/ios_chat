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
    private var results = [[String:String]]()
    private var hasFetched = false
    
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
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["email"]
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
        results.removeAll()
        self.searchUsers(query: text)
    }
    func searchUsers(query: String){
        if hasFetched {
            self.filterUsers(term: query)
            
        }
        else {
            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
                switch result {
                case .success(let userCollection):
                    self?.hasFetched = true 
                    self?.users = userCollection
                    self?.filterUsers(term: query)
                case .failure(let error):
                    print("Error")
                }
                
            })
        }
    }
    
    func filterUsers(term : String){
        guard hasFetched else {
            return
        }
        var results : [[String:String]] = self.users.filter({
            guard let email = $0["email"]?.lowercased() else {
                return false
            }
            return email.hasPrefix(term.lowercased())
        })
        self.results = results
        updateUI()
    }
    
    func updateUI(){
        if !results.isEmpty {
            self.tableview.reloadData()
        }
    }
}
