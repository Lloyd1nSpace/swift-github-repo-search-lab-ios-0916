//
//  FISReposDataStore.swift
//  github-repo-list-swift
//
//  Created by  susan lovaglio on 10/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    var repositories = [GithubRepository]()
    
    func getRepositoriesFromAPI(_ completion: @escaping () -> ()) {
        repositories = []
        
        GithubAPIClient.getRepositories { [weak self] (repos, error) in
            guard let strongSelf = self else { return }
            if let repos = repos {
                strongSelf.repositories.append(GithubRepository(dictionary: repos))
                completion()
            } else if let error = error {
                print("There was an error appending the repo to the repositories array in the ReposDataStore: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleStarStatus(for repo: GithubRepository, completion: @escaping (Bool) -> ()) {
        GithubAPIClient.checkIfRepositoryIsStarred(repo.fullName) { (starred, error) in
            if let error = error {
                print("There was an error toggling the star status in the ReposDataStore: \(error.localizedDescription)")
            } else if starred == true {
                GithubAPIClient.unstarRepository(named: repo.fullName, completion: {
                    completion(false)
                })
            } else {
                GithubAPIClient.starRepository(named: repo.fullName, completion: {
                    completion(true)
                })
            }
        }
    }
 
    func searchRepositories(_ searchText: String, completion: @escaping () -> ()) {
        GithubAPIClient.searchRepositories(searchText) { [weak self] (repo, error) in
            guard let strongSelf = self else { return }
            if let repo = repo {
                strongSelf.repositories.append(GithubRepository(dictionary: repo))
                completion()
            } else if error != nil {
                print("There was an error searching repos in the DataStore")
            }
        }
    }
    
}
