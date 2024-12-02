//

import Combine
import UIKit

final class CreateUserViewController: UIViewController {
    
    @IBOutlet private weak var nameInputView: InputTextFieldView!
    @IBOutlet private weak var emailInputView: InputTextFieldView!
    @IBOutlet private weak var cityInputView: InputTextFieldView!
    @IBOutlet private weak var streetInputView: InputTextFieldView!
    @IBOutlet private weak var saveButton: UIButton!
    
    private var viewModel: CreateUserViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let backButtonSubject = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func configure(viewModel: CreateUserViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: Setup

private extension CreateUserViewController {
    
    func setup() {
        setupNavigationBar()
        setupTextFieldViews()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Create User"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(tappedBackButton))
        backButton.tintColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setupTextFieldViews() {
        nameInputView.configure(inputType: .name)
        emailInputView.configure(inputType: .email)
        cityInputView.configure(inputType: .city)
        streetInputView.configure(inputType: .street)
    }
}

// MARK: Binding

private extension CreateUserViewController {
    
    func bind() {
        guard let viewModel else { return }
        let output = viewModel.transform(input: .init(saveTapped: saveButton.publisher(for: .touchUpInside)
            .map { _ in }.eraseToAnyPublisher(),
                                                      inputName: nameInputView.inputText,
                                                      inputEmail: emailInputView.inputText,
                                                      inputCity: cityInputView.inputText,
                                                      inputStreet: streetInputView.inputText,
                                                      backTapped: backButtonSubject.eraseToAnyPublisher()))
        
        output.back.sink{}.store(in: &cancellables)
        output.createUser.sink{}.store(in: &cancellables)
        output.validationError.sink { [weak self] errors in
            guard let self else { return }
            self.showValidationErrors(errors)
        }
        .store(in: &cancellables)
    }
}

// MARK: Private

private extension CreateUserViewController {
    
    @objc private func tappedBackButton() {
        self.backButtonSubject.send()
    }
    
    func showValidationErrors(_ errors: [ValidationError]) {
        let inputViews: [InputTextFieldView: ValidationError] = [
            nameInputView: errors.first { $0 == .invalidName } ?? .none,
            emailInputView: errors.first { $0 == .invalidEmail || $0 == .alreadyExistEmail } ?? .none,
            cityInputView: errors.first { $0 == .invalidCity } ?? .none,
            streetInputView: errors.first { $0 == .invalidStreet } ?? .none
        ]
        
        inputViews.forEach { inputView, error in
            inputView.showError(error)
        }
    }
}
