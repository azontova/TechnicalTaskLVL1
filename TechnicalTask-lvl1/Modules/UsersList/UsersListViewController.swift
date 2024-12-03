//
//  UsersListViewController.swift
//  TechnicalTask-lvl1
//
//  Created by Sasha Zontova on 25.11.24.
//

import Combine
import UIKit

final class UsersListViewController: UIViewController {
    
    enum Constants {
        static let title = "Users"
        static let addImageTitle = "plus.square"
        static let deleteImageTitle = "trash.fill"
        static let nibName = "UserCell"
    }
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noConnectionView: UIView!
    @IBOutlet private weak var loadingIndicatorView: UIActivityIndicatorView!
    
    private var viewModel: UsersListViewModel?
    private var users: [User] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let addButtonSubject = PassthroughSubject<Void, Never>()
    private let refreshDataSubject = PassthroughSubject<Void, Never>()
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
        tableView.register(UINib(nibName: Constants.nibName, bundle: nil),
                           forCellReuseIdentifier: UserCell.identifier)
        tableView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 10, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func setupNavigationBar() {
        navigationItem.title = Constants.title
        let addButton = UIBarButtonItem(image: UIImage(systemName: Constants.addImageTitle),
                                        style: .plain,
                                        target: self,
                                        action: #selector(tappedAddButton))
        addButton.tintColor = .white
        navigationItem.rightBarButtonItem = addButton
    }
}

// MARK: Binding

private extension UsersListViewController {
    
    func bind() {
        guard let viewModel else { return }
        let output = viewModel.transform(input: .init(isConnectionAvailable: isConnectionAvailable,
                                                      refreshData: refreshDataSubject.eraseToAnyPublisher(),
                                                      addTapped: addButtonSubject.eraseToAnyPublisher(),
                                                      deleteTapped: deleteUserSubject.eraseToAnyPublisher()))
        output.users
            .sink { [weak self] users in
                guard let self else { return }
                self.users = users
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.showNoConnection
            .sink { [weak self] isConnectionAvailable in
                guard let self else { return }
                self.noConnectionView.isHidden = isConnectionAvailable
            }
            .store(in: &cancellables)
        
        output.isLoading
            .sink { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.loadingIndicatorView.isHidden = false
                    self.loadingIndicatorView.startAnimating()
                } else {
                    self.loadingIndicatorView.isHidden = true
                    self.loadingIndicatorView.stopAnimating()
                    self.tableView.refreshControl?.endRefreshing()
                }
            }
            .store(in: &cancellables)
        
        output.navigateToCreateUser.sink{}.store(in: &cancellables)
    }
}

// MARK: Private

private extension UsersListViewController {

    @objc private func tappedAddButton() {
        addButtonSubject.send()
    }
    
    @objc private func refreshData() {
        refreshDataSubject.send()
    }
}

// MARK: UITableViewDataSource

extension UsersListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else { return UITableViewCell() }
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
        
        deleteAction.image = UIImage(systemName: Constants.deleteImageTitle)
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}
