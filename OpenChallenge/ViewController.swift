//
//  ViewController.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let publicKey = APISecret.retrieveAPIKey(),
              let privateKey = APISecret.retrievePrivateKey() else {
            fatalError("API keys not found")
        }

        let apiManager = APIManager(publicKey: publicKey, privateKey: privateKey)
        let viewModel = CharacterListViewModel(apiManager: apiManager)
        let characterListViewController = CharacterListViewController(viewModel: viewModel)


        // If using a UINavigationController
        self.navigationController?.pushViewController(characterListViewController, animated: true)

    }


}

