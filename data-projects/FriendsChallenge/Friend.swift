//
//  Friend.swift
//  FriendsChallenge
//
//  Created by Diogo Melo on 10/10/20.
//  Copyright © 2020 Diogo Melo. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: String
    let name: String
    let isActive: Bool
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
        let registered: String
    let tags: [String]
    let friends: [Friend]
    
}

struct Friend: Codable {
    
    let id: String
    let name: String
}
