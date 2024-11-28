//
//  InputUserDataCell.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import UIKit

final class InputUserDataCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var inputTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(inputType: UserDataInputType) {
        titleLabel.text = inputType.title
        inputTextField.placeholder = inputType.placeholder
    }
}
