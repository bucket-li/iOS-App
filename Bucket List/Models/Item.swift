//
//  Item.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/26/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct Item: Equatable, Codable {
    var id: UUID
    var userId: Int
    var completed: Bool
    var description: String
    var created: Date
}
