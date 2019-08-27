//
//  Image.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

struct Image: Equatable, Codable {
    var id: Int
    var postId: Int
    var url: String
    var created: String
}
