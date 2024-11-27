//
//  UserCell.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 27.11.24.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userMailLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: User) {
        userNameLabel.text = model.name
        userMailLabel.text = model.email
        addressLabel.text = model.address.city
    }
}
