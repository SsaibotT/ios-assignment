//
//  ViewController.swift
//  engenious-challenge
//
//  Created by Abdullah Atkaev on 20.05.2022.
//

import UIKit
import Combine

class RepoViewController: UIViewController {
    // MARK: Properties
    private let viewModel: RepoViewModel
    private var cancelables = Set<AnyCancellable>()
    
    // MARK: Views
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Repository"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0/255.0, green: 106/255.0, blue: 183/255.0, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    // MARK: Lifecycle
    init(viewModel: RepoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewController()
        configureTableView()
        configureConstraints()
        configureBindings()
        getRepos()
    }
    
    // MARK: Configurations
    private func configureViewController() {
        view.backgroundColor = .white
        title = "\(viewModel.username)'s repos"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: RepoTableViewCell.identifier)
    }
    
    private func configureConstraints() {
        view.addSubview(headerLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            headerLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureBindings() {
        viewModel.repos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancelables)
    }

    // MARK: Functions
    private func getRepos() {
        viewModel.getRepo()
    }
}

extension RepoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repos.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier) as? RepoTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        
        let repo = viewModel.repos.value[indexPath.row]
        cell.configure(with: repo.name, subtitle: repo.description ?? "")
        return cell
    }
}

