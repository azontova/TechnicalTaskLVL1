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
    @IBOutlet private weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: User) {
        colorView.backgroundColor = UIColor.random
        userNameLabel.text = model.name
        userMailLabel.text = model.email
        addressLabel.text = model.address.fullAddress
    }
}
