//
//  User.swift
//  Bucket List
//
//  Created by Michael Stoffer on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct User: Equatable, Codable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int16
    var name: String
    var email: String
    var password: String
    var created: Date
    var token: Token?
}
