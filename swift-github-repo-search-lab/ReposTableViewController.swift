//
//  FISReposTableViewController.swift
//  github-repo-list-swift
//
//  Created by  susan lovaglio on 10/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    var store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.accessibilityLabel = "tableView"
        tableView.accessibilityIdentifier = "tableView"
        store.getRepositoriesFromAPI  { [weak self] in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let alertVC = UIAlertController(title: "Search Repos", message: "", preferredStyle: .alert)
        alertVC.addTextField(configurationHandler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        present(alertVC, animated: true, completion: nil)
    }
}

//MARK: tableView Data Source
extension ReposTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.repositories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        cell.textLabel?.text = store.repositories[indexPath.row].fullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        store.toggleStarStatus(for: store.repositories[indexPath.row]) { [weak self] (starred) in
            guard let strongSelf = self else { return }
            if starred {
                let alertVC = UIAlertController(title: "STARRED!", message: "You just starred \(strongSelf.store.repositories[indexPath.row].fullName)", preferredStyle: .alert)
                alertVC.accessibilityLabel = "You just unstarred \(strongSelf.store.repositories[indexPath.row].fullName)"
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertVC.addAction(action)
                strongSelf.present(alertVC, animated: true, completion: nil)
            } else {
                let alertVC = UIAlertController(title: "UNSTARRED!", message: "You just unstarred \(strongSelf.store.repositories[indexPath.row].fullName)", preferredStyle: .alert)
                alertVC.accessibilityLabel = "You just starred \(strongSelf.store.repositories[indexPath.row].fullName)"
                let action = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertVC.addAction(action)
                strongSelf.present(alertVC, animated: true, completion: nil)
            }
        }
        
    }
    
}
