//
//  InputTextFieldView.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 29.11.24.
//

import UIKit

final class InputTextFieldView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .init(rgb: 0x1C1D38)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = .init(rgb: 0x1C1D38)
        textField.font = .systemFont(ofSize: 16, weight: .light)
        textField.tintColor = .init(rgb: 0x1C1D38)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
   
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required  init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func configure(inputType: DataInputType) {
        titleLabel.text = inputType.title
        inputTextField.placeholder = inputType.placeholder
    }
}

// MARK: Setup
private extension InputTextFieldView {
    
    func setup() {
        backgroundColor = .clear
        backgroundView.addSubview(inputTextField)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(backgroundView)
        addSubview(stackView)

        setBackgroundViewConstraints()
        setInputTextFieldConstraints()
        setStackViewConstraints()
    }
    
    func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }
    
    func setBackgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func setInputTextFieldConstraints() {
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            inputTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            inputTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)

        ])
    }
}
