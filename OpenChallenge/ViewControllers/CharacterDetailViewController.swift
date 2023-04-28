//
//  CharacterDetailViewController.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    private let characterDetailView = CharacterDetailView()
    private let viewModel: CharacterDetailViewModel
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    init(viewModel: CharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = characterDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the activity indicator view
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        
        // Set the title of the navigation bar to the character's name
        title = viewModel.character?.name
        
        // Configure labels and image view with the viewModel
        if let character = viewModel.character {
            configure(with: character)
        } else {
            getCharacterDetail()
        }
    }
    
    private func getCharacterDetail() {
        // Show the activity indicator view
        activityIndicatorView.isHidden = false
        
        viewModel.getCharacterDetail { [weak self] result in
            guard let self = self else { return }
            
            // Hide the activity indicator view
            self.activityIndicatorView.isHidden = true
            
            switch result {
            case .success(let character):
                self.configure(with: character)
            case .failure(let error):
                // Display error message
                print(error.localizedDescription)
            }
        }
    }
    
    private func configure(with character: Character) {
        characterDetailView.nameLabel.text = character.name
        characterDetailView.descriptionLabel.text = character.description
        
        if let url = viewModel.thumbnailURL {
            ImageFromURL.loadImageFromURL(url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.characterDetailView.imageView.image = image
                }
            }
        }
    }
}
