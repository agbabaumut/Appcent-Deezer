//
//  ArtistCell.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import UIKit

class ArtistCell: UICollectionViewCell {
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.clipsToBounds = true
        label.numberOfLines = 2
        label.textColor = .red// add this line
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(artistImageView)
        contentView.addSubview(artistNameLabel)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    
    private func configureConstraints() {
        artistImageView.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistImageView.heightAnchor.constraint(equalToConstant: 120),

            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor, constant: 5),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),  // change this line
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),  // and this line
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)  // adjust this if needed
        ])
    }




    
    func configure(with artist: Artist) {
        // Configure the cell with artist data
        artistNameLabel.text = artist.name
        let imageUrlString = artist.picture_xl
        if let imageUrl = URL(string: imageUrlString) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        self.artistImageView.image = image
                    }
                }
            }
        } else {
            artistImageView.image = nil
        }
    }
}
