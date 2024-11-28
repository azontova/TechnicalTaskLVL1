//

import Combine
import UIKit

final class CreateUserViewController: UIViewController {
    
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: CreateUserViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    private let backButtonSubject = PassthroughSubject<Void, Never>()
    private let inputTypeArray: [UserDataInputType] = [.name, .email, .city, .street]
    
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
        setupTableView()
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
    
    func setupTableView() {
        tableView.register(UINib(nibName: "InputUserDataCell", bundle: nil),
                           forCellReuseIdentifier: "InputUserDataCell")
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.dataSource = self
    }
}

// MARK: Private

private extension CreateUserViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: .init(saveTapped: saveButton.publisher(for: .touchUpInside)
            .map { _ in }.eraseToAnyPublisher(),
                                                      backTapped: backButtonSubject.eraseToAnyPublisher()))
        
        output.back.sink{}.store(in: &cancellables)
    }
    
    @objc private func tappedBackButton() {
        self.backButtonSubject.send()
    }
}

// MARK: UITableViewDataSource

extension CreateUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inputTypeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InputUserDataCell", for: indexPath) as? InputUserDataCell else { return UITableViewCell() }
        let inputType = inputTypeArray[indexPath.row]
        cell.configure(inputType: inputType)
        return cell
    }
}
