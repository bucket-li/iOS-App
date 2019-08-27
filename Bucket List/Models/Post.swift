//
//  Post.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct Post: Equatable, Codable {
    var id: Int
    var itemId: Int
    var message: String
    var created: String
}
