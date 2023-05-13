//
//  AlbumDetailViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import UIKit
import AVFoundation

class AlbumDetailViewController: UIViewController {
    private var albumId: Int!
    private var albumName: String?
    private var tracks: [Track] = []
    private var currentlyPlayingIndex: Int?
    
    //private var titleLabel: UILabel!
    private var tracksListView: UITableView!
    
    required init(albumId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.albumId = albumId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        fetchAlbumData()
        
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = true
        
    }
    
    private func setupViews() {
        
        tracksListView = UITableView()
        
        
        view.addSubview(tracksListView)
        
        // Set up table view delegate and data source
        tracksListView.dataSource = self
        tracksListView.delegate = self
        tracksListView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
    }
    
    private func fetchAlbumData() {
        guard let albumId = albumId else {
            return
        }
        
        let urlString = "https://api.deezer.com/album/\(albumId)"
        
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                // Handle error case
                return
            }

            do {
                let response = try JSONDecoder().decode(Tracks.self, from: data)
                let trackData = response.tracks.data
                self?.tracks =  trackData
                DispatchQueue.main.async {
                    self?.configureViews()
                    self?.tracksListView.reloadData()
                    self?.title = trackData.first?.album.title
                }
            } catch {
                // Handle parsing error
                print("Error decoding album details: \(error)")
            }
        }.resume()
    }
    
    private func configureViews() {
        // Set up table view appearance
        tracksListView.rowHeight = UITableView.automaticDimension
        tracksListView.estimatedRowHeight = 10
        tracksListView.separatorStyle = .none
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let margin: CGFloat = 16
        let safeArea = view.safeAreaLayoutGuide

        tracksListView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tracksListView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: margin),
            tracksListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tracksListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tracksListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

extension AlbumDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
            return UITableViewCell()
        }
        
        let track = tracks[indexPath.row]
        cell.configure(with: track)
        
        return cell
    }
}

extension AlbumDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrack = tracks[indexPath.row]
        print("Selected track: \(selectedTrack.title)")
        
        if let currentlyPlayingIndex = currentlyPlayingIndex, currentlyPlayingIndex != indexPath.row {
            // Stop the currently playing track if there is one
            let previousIndexPath = IndexPath(row: currentlyPlayingIndex, section: indexPath.section)
            if let previousCell = tableView.cellForRow(at: previousIndexPath) as? TrackCell {
                previousCell.stopPreview()
            }
        }
        
        if let cell = tableView.cellForRow(at: indexPath) as? TrackCell {
            if cell.isPlaying {
                // Stop the player if the selected cell is already playing
                cell.stopPreview()
                currentlyPlayingIndex = nil
            } else {
                // Play the preview of the selected track
                cell.playPreview()
                currentlyPlayingIndex = indexPath.row
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



