//
//  CharacterTableViewCell.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let thumbnailImageView = UIImageView()
    private let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {

        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(thumbnailImageView)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.numberOfLines = 0 // Update to allow for multiple lines
        descriptionLabel.textColor = .gray // Update to be gray
        descriptionLabel.text = "No description available" // Set placeholder text

        contentView.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),

            nameLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with character: Character) {
        nameLabel.text = character.name

        if let thumbnail = character.thumbnail,
           let path = thumbnail.path,
           let fileExtension = thumbnail.fileExtension,
           let url = URL(string: "\(path).\(fileExtension)") {
            ImageFromURL.loadImageFromURL(url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.thumbnailImageView.image = image
                }
            }
        }

        if let description = character.description, !description.isEmpty {
            descriptionLabel.text = description.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            descriptionLabel.text = "No description available"
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        thumbnailImageView.image = nil
        descriptionLabel.text = nil
    }

}
