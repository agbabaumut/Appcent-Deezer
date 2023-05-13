//
//  AlbumCell.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import UIKit

class AlbumCell: UITableViewCell {
    private var albumImageView: UIImageView!
    private var albumNameLabel: UILabel!
    private var releaseDateLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        albumImageView = UIImageView()
        albumNameLabel = UILabel()
        releaseDateLabel = UILabel()
        
        contentView.addSubview(albumImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(releaseDateLabel)
    }
    
    private func configureViews() {
        albumImageView.contentMode = .scaleAspectFit
        
        albumNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        albumNameLabel.numberOfLines = 2
        
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .gray
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 16
        let imageSize: CGFloat = contentView.bounds.height - 2 * margin
        
        albumImageView.frame = CGRect(x: margin, y: margin, width: imageSize, height: imageSize)
        albumNameLabel.frame = CGRect(x: albumImageView.frame.maxX + margin, y: margin, width: contentView.bounds.width - albumImageView.frame.maxX - 2 * margin, height: 40)
        releaseDateLabel.frame = CGRect(x: albumImageView.frame.maxX + margin, y: albumNameLabel.frame.maxY , width: contentView.bounds.width - albumImageView.frame.maxX - 2 * margin, height: 20)
    }
    
    func configure(with album: Album) {
        albumNameLabel.text = album.title
        releaseDateLabel.text = "Release Date: \(album.releaseDate)"
        
        // Set the album image using the album.cover property and handle image loading asynchronously
        DispatchQueue.global().async { [weak self] in
            guard let coverURL = URL(string: album.cover),
                  let imageData = try? Data(contentsOf: coverURL),
                  let coverImage = UIImage(data: imageData) else {
                return
            }
            
            DispatchQueue.main.async {
                self?.albumImageView.image = coverImage
            }
        }
    }

}

