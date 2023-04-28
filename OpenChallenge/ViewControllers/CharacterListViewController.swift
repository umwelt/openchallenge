//
//  CharacterListViewController.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

class CharacterListViewController: UIViewController {
    var viewModel: CharacterListViewModel = CharacterListViewModel()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CharacterTableViewCell.self, forCellReuseIdentifier: "CharacterCell")
        
        return tableView
    }()

    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setKeys() {
        guard let publicKey = APISecret.retrieveAPIKey(),
              let privateKey = APISecret.retrievePrivateKey() else {
            fatalError("API keys not found")
        }

        let apiManager = APIManager(publicKey: publicKey, privateKey: privateKey)
        viewModel.setApiManager(apiManager: apiManager)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        setKeys()
        setupNavigationBar()
        setupTableView()

        viewModel.fetchCharacters { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {
                // Handle the error case, e.g. show an error message
            }
        }
    }

    private func setupNavigationBar() {
        navigationItem.title = "Characters"
    }

    private func setupTableView() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath) as! CharacterTableViewCell
        let character = viewModel.characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
}

extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let character = viewModel.characters[indexPath.row]
        guard let characterId = character.id else { return }
        
        let characterDetailViewModel = CharacterDetailViewModel(apiManager: viewModel.apiManager, characterId: characterId)
        let detailViewController = CharacterDetailViewController(viewModel: characterDetailViewModel)
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
