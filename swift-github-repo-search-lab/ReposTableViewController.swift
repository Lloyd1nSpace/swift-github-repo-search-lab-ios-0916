//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        store.getRepositories {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRepo = store.repositories[(indexPath as NSIndexPath).row]
        store.toggleStarStatusForRepository(selectedRepo) { (isStarred) in
            if isStarred {
                DispatchQueue.main.async(execute: {
                    self.showAlert("You just starred", repoFullName: selectedRepo.fullName)
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.showAlert("You just unstarred", repoFullName: selectedRepo.fullName)
                })
            }
        }
    }
        
    func showAlert(_ message: String, repoFullName: String) {
            let alertMessage = "\(message) \(repoFullName)"
            let alertController = UIAlertController(title: "Success!", message: alertMessage, preferredStyle: .alert)
            alertController.accessibilityLabel = alertMessage
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            ok.accessibilityLabel = "OK"
            self.present(alertController, animated: true, completion: nil)
        }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Search for Repo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0].text
            if let searchName = answer {
                self.store.searchRepo(searchName, completion: {
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                })
            }
            
            
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
        
        
        
    }
    
    

}
