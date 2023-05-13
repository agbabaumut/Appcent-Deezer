//
//  TrackCell.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import UIKit
import AVFoundation

class TrackCell: UITableViewCell {
    private var coverImageView: UIImageView!
    private var titleLabel: UILabel!
    private var durationLabel: UILabel!
    private var audioPlayer: AVPlayer?
    private var heartButton: UIButton!
    public var isPlaying: Bool = false


    
    var track: Track?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        coverImageView = UIImageView()
        titleLabel = UILabel()
        durationLabel = UILabel()
        heartButton = UIButton()
        
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(heartButton)
        
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)

    }
    
    private func configureViews() {
        // Set up cover image view
        coverImageView.contentMode = .scaleAspectFit
        
        // Set up title label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        
        // Set up duration label
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        heartButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        heartButton.tintColor = .systemPink
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin: CGFloat = 16
        let imageSize: CGFloat = 56
        let buttonSize: CGFloat = 24
        let labelHeight: CGFloat = 20
        
        coverImageView.frame = CGRect(x: margin, y: (bounds.height - imageSize) / 2, width: imageSize, height: imageSize)
        titleLabel.frame = CGRect(x: coverImageView.frame.maxX + margin, y: margin / 2, width: bounds.width - coverImageView.frame.maxX - margin * 2, height: labelHeight * 2)
        durationLabel.frame = CGRect(x: coverImageView.frame.maxX + margin, y: titleLabel.frame.maxY, width: bounds.width - coverImageView.frame.maxX - margin * 2, height: labelHeight)
        heartButton.frame = CGRect(x: bounds.width - margin - buttonSize, y: (bounds.height - buttonSize) / 2, width: buttonSize, height: buttonSize)
    }
    
    func configure(with track: Track) {
        self.track = track
        
        titleLabel.text = track.title
        
        if let durationSeconds = track.duration {
            let minutes = durationSeconds / 60
            let seconds = durationSeconds % 60
            let formattedDuration = String(format: "%d:%02d", minutes, seconds)
            durationLabel.text = formattedDuration
        }
        
        // Set the track's image using the track's album.cover property and handle image loading asynchronously
        guard let url = URL(string: track.album.cover_xl) else {
            coverImageView.image = nil
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.coverImageView.image = image
                }
            }
        }
    }
    
    func playPreview() {
        guard let previewURLString = track?.preview, let previewURL = URL(string: previewURLString) else {
            return
        }
        
        let playerItem = AVPlayerItem(url: previewURL)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stopPreview() {
        audioPlayer?.pause()
        audioPlayer = nil
        isPlaying = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPreview()
    }
    
    @objc private func heartButtonTapped() {
        heartButton.isSelected.toggle()

        
    }
}

