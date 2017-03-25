//
//  GithubRepository.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

struct GithubRepository {
    let fullName: String
    let htmlURL: URL
    let repositoryID: String
    
    init(dictionary: [String : Any]) {
        self.fullName = dictionary["full_name"] as! String
        let owner = dictionary["owner"] as! [String : Any]
        self.htmlURL = URL(string: owner["html_url"] as! String)!
        self.repositoryID = "\(owner["id"] as! Int)"
    }
    
}
