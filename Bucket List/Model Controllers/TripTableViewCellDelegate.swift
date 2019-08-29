//
//  TripTableViewCellDelegate.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

protocol TripTableViewCellDelegate: class {
    func toggleCompleted(for cell: TripTableViewCell)
}
