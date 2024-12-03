//
//  InputTextFieldView.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 29.11.24.
//

import Combine
import UIKit

final class InputTextFieldView: UIView {
    
    private let textSubject = CurrentValueSubject<String, Never>("")
    
    var inputText: AnyPublisher<String, Never> {
        textSubject.eraseToAnyPublisher()
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = AppConstants.Colors.nightBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = AppConstants.Colors.nightBlue
        textField.font = .systemFont(ofSize: 16, weight: .light)
        textField.autocorrectionType = .no
        textField.tintColor = AppConstants.Colors.nightBlue
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = AppConstants.Colors.lightRed
        label.numberOfLines = 1
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        view.layer.borderColor = UIColor.clear.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func configure(inputType: DataInputType) {
        titleLabel.text = inputType.title
        inputTextField.placeholder = inputType.placeholder
        if inputType == .email {
            inputTextField.autocapitalizationType = .none
        }
    }
}

// MARK: Setup

private extension InputTextFieldView {
    
    func setup() {
        backgroundColor = .clear
        inputTextField.delegate = self
        
        backgroundView.addSubview(inputTextField)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(backgroundView)
        addSubview(stackView)
        addSubview(errorLabel)

        setBackgroundViewConstraints()
        setInputTextFieldConstraints()
        setStackViewConstraints()
        setErrorLabelConstraints()
    }
    
    func setStackViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func setBackgroundViewConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 45.0)
        ])
    }
    
    func setInputTextFieldConstraints() {
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10.0),
            inputTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10.0),
            inputTextField.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)

        ])
    }
    
    func setErrorLabelConstraints() {
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 2),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: UITextFieldDelegate

extension InputTextFieldView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let inputText = (text as NSString).replacingCharacters(in: range, with: string)
        textSubject.send(inputText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
