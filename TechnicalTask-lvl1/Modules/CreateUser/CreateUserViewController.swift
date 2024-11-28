//

import Combine
import UIKit

final class CreateUserViewController: UIViewController {
    
    private var viewModel: CreateUserViewModel?
    private let backButtonSubject = PassthroughSubject<Void, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configure(viewModel: CreateUserViewModel) {
        self.viewModel = viewModel
        
        setup()
    }
}

// MARK: Setup

private extension CreateUserViewController {
    
    func setup() {
        setupNavigationBar()
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
}

// MARK: Private

private extension CreateUserViewController {
    
    @objc private func tappedBackButton() {
        self.backButtonSubject.send()
    }
}
