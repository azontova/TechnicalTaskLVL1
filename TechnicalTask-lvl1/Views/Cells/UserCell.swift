//
//  UserCell.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import UIKit

final class UserCell: UITableViewCell {

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userMailLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    func configure(with model: User) {
        userNameLabel.text = model.name
        userMailLabel.text = model.email
        addressLabel.text = model.address.fullAddress
    }
}
