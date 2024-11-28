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
    private var users: [User] = []
    private let addButtonSubject = PassthroughSubject<Void, Never>()
    private let deleteUserSubject = PassthroughSubject<User, Never>()
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
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(tappedAddButton))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
        
        tableView.register(UINib(nibName: "UserCell", bundle: nil),
                           forCellReuseIdentifier: "UserCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: Private

private extension UsersListViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: .init(addTapped: addButtonSubject.eraseToAnyPublisher(),
                                                      deleteTapped: deleteUserSubject.eraseToAnyPublisher()))
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

// MARK: UITableViewDelegate

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            deleteUserSubject.send(users[indexPath.row])
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
