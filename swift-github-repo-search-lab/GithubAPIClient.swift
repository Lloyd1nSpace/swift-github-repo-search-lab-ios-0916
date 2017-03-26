//
//  FISGithubAPIClient.swift
//  github-repo-list-swift
//
//  Created by  susan lovaglio on 10/23/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GithubAPIClient {
    
    static func getRepositories(with completion: @escaping ([String : Any]?, Error?) -> ()) {
        let urlString = "https://api.github.com/repositories?client_id=\(Secrets.clientID)&client_secret=\(Secrets.clientSecret)"
        Alamofire.request(urlString).responseJSON { (response) in
            if let data = response.data {
                let json = JSON(data: data)
                completion(json.dictionary, nil)
            }
        }
    }
    
    static func checkIfRepositoryIsStarred(_ repoFullName: String, completion: @escaping (Bool?, Error?) -> ()) {
        let urlString = "https://api.github.com/user/starred/\(repoFullName)?access_token=\(Secrets.personalAccessToken)"
        Alamofire.request(urlString).responseJSON { (response) in
            if response.response?.statusCode == 204 {
                completion(true, nil)
            } else if response.response?.statusCode == 404 {
                completion(false, nil)
            }
        }
    }
    
    static func starRepository(named: String, completion: @escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        
        

        guard let url = URL(string:  urlString) else {
            print("There was an error unwrapping the URL in the GithubAPIClient")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    completion()
                }
            }
        }).resume()
    }
    
    static func unstarRepository(named: String, completion: @escaping () -> ()) {
        let urlString = "https://api.github.com/user/starred/\(named)?access_token=\(Secrets.personalAccessToken)"
        guard let url = URL(string: urlString) else {
            print("There was an error unwrapping the url in the GithubAPIClient")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        _ = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 204 {
                    completion()
                }
            }
        }).resume()
    }
    
}
