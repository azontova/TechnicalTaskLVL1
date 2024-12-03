//

import Combine
import UIKit

final class CreateUserViewController: UIViewController {
    
    enum Constants {
        static let title = "Create User"
        static let backImageTitle = "arrow.backward"
    }
    
    @IBOutlet private weak var scrollView: UIScrollView!
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Setup

private extension CreateUserViewController {
    
    func setup() {
        setupNavigationBar()
        setupTextFieldViews()
        setupNotifications()
    }
    
    func setupNavigationBar() {
        navigationItem.title = Constants.title
        let backButton = UIBarButtonItem(image: UIImage(systemName: Constants.backImageTitle),
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
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
    }
}

// MARK: Private

private extension CreateUserViewController {

    @objc func tappedBackButton() {
        self.backButtonSubject.send()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            var contentInset = scrollView.contentInset
            contentInset.bottom = keyboardHeight
            scrollView.contentInset = contentInset
            scrollView.scrollIndicatorInsets = contentInset
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
}
