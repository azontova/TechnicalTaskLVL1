//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 25.11.24.
//

import Combine
import UIKit

final class UsersListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var viewModel: UsersListViewModel?
    private let addButtonSubject = PassthroughSubject<Void, Never>()
    private var users: [User] = []
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func configure(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: Setup

private extension UsersListViewController {
    
    func setup() {
        navigationItem.title = "Users"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.app"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(tappedAddButton))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil),
                           forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
    }
}

// MARK: Private

private extension UsersListViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: .init(addTapped: addButtonSubject.eraseToAnyPublisher()))
        output.users
            .sink { [weak self] users in
                self?.users = users
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    @objc private func tappedAddButton() {
        self.addButtonSubject.send()
    }
}

// MARK: UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else { return UITableViewCell() }
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}
