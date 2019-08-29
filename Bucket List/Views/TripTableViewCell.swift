//
//  TripTableViewCell.swift
//  LambdaBucketList
//
//  Created by Michael Stoffer on 8/27/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class TripTableViewCell: UITableViewCell {
    var item: Item? {
        didSet {
            self.updateViews()
        }
    }
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var completedButton: UIButton!

    weak var delegate: TripTableViewCellDelegate?
    
    private func updateViews() {
        guard let item = self.item else { return }
        
        self.messageLabel.text = item.description
        
        if item.completed == true {
            let checked = UIImage(named: "checked")
            self.completedButton.setImage(checked, for: .normal)
        } else {
            let unchecked = UIImage(named: "unchecked")
            self.completedButton.setImage(unchecked, for: .normal)
        }
    }

    @IBAction func completedButtonTapped(_ sender: UIButton) {
        delegate?.toggleCompleted(for: self)
    }
}
