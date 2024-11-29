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
    @IBOutlet private weak var noConnectionView: UIView!
    
    private var viewModel: UsersListViewModel?
    private var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let addButtonSubject = PassthroughSubject<Void, Never>()
    private let deleteUserSubject = PassthroughSubject<User, Never>()
    
    private var isConnectionAvailable : AnyPublisher<Bool, Never> {
        return NetworkMonitor.shared.connectionStatus
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        bind()
    }
    
    func configure(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
    }
    
    deinit {
        NetworkMonitor.shared.stopMonitoring()
    }
}

// MARK: Setup

private extension UsersListViewController {
    
    func setup() {
        NetworkMonitor.shared.startMonitoring()
        setupNavigationBar()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "UserCell", bundle: nil),
                           forCellReuseIdentifier: "UserCell")
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 10, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setupNavigationBar() {
        navigationItem.title = "Users"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus.square"),
                                        style: .plain,
                                        target: self,
                                        action: #selector(tappedAddButton))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
}

// MARK: Private

private extension UsersListViewController {
    
    func bind() {
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: .init(isConnectionAvailable: isConnectionAvailable,
                                                      addTapped: addButtonSubject.eraseToAnyPublisher(),
                                                      deleteTapped: deleteUserSubject.eraseToAnyPublisher()))
        output.users
            .sink { [weak self] users in
                self?.users = users
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.showNoConnection
            .sink { [weak self] isConnectionAvailable in
                self?.noConnectionView.isHidden = isConnectionAvailable
            }
            .store(in: &cancellables)
        
        output.navigateToCreateUser.sink{}.store(in: &cancellables)
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
