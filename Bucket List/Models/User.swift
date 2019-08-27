//
//  User.swift
//  Bucket List
//
//  Created by Michael Stoffer on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct User: Equatable, Codable {
    var id: Int
    var name: String
    var email: String
    var created: String
}
