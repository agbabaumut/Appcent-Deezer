//
//  AlbumDetailViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

//import UIKit
//
//class AlbumDetailViewController: UIViewController {
//    private var albumId: Int!
//    private var albumName: String?
//    private var tracks: [Track] = []
//
//    private var titleLabel: UILabel!
//    private var tracksListView: UITableView!
//
//    required init(albumId: Int) {
//            super.init(nibName: nil, bundle: nil)
//            self.albumId = albumId
//        }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        fetchAlbumData()
//    }
//
//    private func setupViews() {
//        titleLabel = UILabel()
//        tracksListView = UITableView()
//
//        view.addSubview(titleLabel)
//        view.addSubview(tracksListView)
//
//        // Set up table view delegate and data source
//        tracksListView.dataSource = self
//        tracksListView.delegate = self
//        tracksListView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
//    }
//
//    private func fetchAlbumData() {
//        guard let albumId = albumId else {
//            return
//        }
//
//        let urlString = "https://api.deezer.com/album/\(albumId)"
//
//        guard let url = URL(string: urlString) else {
//            // Handle invalid URL
//            return
//        }
//
//        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//            guard let data = data, error == nil else {
//                // Handle error case
//                return
//            }
//
//            do {
//                let response = try JSONDecoder().decode(Tracks.self, from: data)
//                let trackData = response.tracks.data
//                self?.albumName = trackData.first?.album.title
//                self?.tracks =  trackData
//                DispatchQueue.main.async {
//                    self?.configureViews()
//                    self?.titleLabel.text = trackData.first?.title
//                    self?.tracksListView.reloadData()
//                }
//            } catch {
//                // Handle parsing error
//                print("Error decoding album details: \(error)")
//                print("yoğgkbe knk")
//            }
//        }.resume()
//    }
//
//    private func configureViews() {
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//
//        // Set up table view appearance
//        tracksListView.rowHeight = UITableView.automaticDimension
//        tracksListView.estimatedRowHeight = 60
//        tracksListView.separatorStyle = .none
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        // Update the frames of the views based on the layout
//        let margin: CGFloat = 16
//        let titleLabelHeight: CGFloat = 30
//
//        titleLabel.frame = CGRect(x: margin, y: margin, width: view.bounds.width - margin * 2, height: titleLabelHeight)
//        tracksListView.frame = CGRect(x: 0, y: titleLabel.frame.maxY + margin, width: view.bounds.width, height: view.bounds.height - titleLabel.frame.maxY - margin)
//    }
//}
//
//extension AlbumDetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tracks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
//            return UITableViewCell()
//        }
//
//        let track = tracks[indexPath.row]
//        cell.configure(with: track)
//        cell.likeButton.tag = indexPath.row
//        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
//
//        return cell
//    }
//
//    @objc private func likeButtonTapped(_ sender: UIButton) {
//        let track = tracks[sender.tag]
//        // Handle like button tapped for the track
//        // Update the UI to show the track as liked
//        sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
//    }
//}
//
//extension AlbumDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTrack = tracks[indexPath.row]
//        print("Selected track: \(selectedTrack.title)")
//
//        if let selectedCell = tableView.cellForRow(at: indexPath) as? TrackCell {
//            if let currentlyPlayingIndex = currentlyPlayingIndex, currentlyPlayingIndex != indexPath.row {
//                // Stop the previous preview if it's playing
//                let oldIndexPath = IndexPath(row: currentlyPlayingIndex, section: 0)
//                if let oldCell = tableView.cellForRow(at: oldIndexPath) as? TrackCell {
//                    oldCell.stopPreview()
//                }
//            }
//
//            if currentlyPlayingIndex == indexPath.row {
//                // Tapped on the currently playing cell, stop the preview
//                currentlyPlayingIndex = nil
//                selectedCell.stopPreview()
//            } else {
//                // Tapped on a different cell, play the preview
//                currentlyPlayingIndex = indexPath.row
//                selectedCell.playPreview()
//            }
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
// -----------
import UIKit
import AVFoundation

class AlbumDetailViewController: UIViewController {
    private var albumId: Int!
    private var albumName: String?
    private var tracks: [Track] = []
    private var currentlyPlayingIndex: Int?
    
    private var titleLabel: UILabel!
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
    }
    
    private func setupViews() {
        titleLabel = UILabel()
        tracksListView = UITableView()
        
        view.addSubview(titleLabel)
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
                self?.albumName = trackData.first?.album.title
                self?.tracks =  trackData
                DispatchQueue.main.async {
                    self?.configureViews()
                    self?.titleLabel.text = trackData.first?.title
                    self?.tracksListView.reloadData()
                }
            } catch {
                // Handle parsing error
                print("Error decoding album details: \(error)")
                print("yoğgkbe knk")
            }
        }.resume()
    }
    
    private func configureViews() {
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        // Set up table view appearance
        tracksListView.rowHeight = UITableView.automaticDimension
        tracksListView.estimatedRowHeight = 100
        tracksListView.separatorStyle = .none
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let margin: CGFloat = 16
        let titleLabelHeight: CGFloat = 30
        
        titleLabel.frame = CGRect(x: margin, y: margin, width: view.bounds.width - margin * 2, height: titleLabelHeight)
        tracksListView.frame = CGRect(x: 0, y: titleLabel.frame.maxY + margin, width: view.bounds.width, height: view.bounds.height - titleLabel.frame.maxY - margin)
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
        
        // Play the preview of the selected track
        if let cell = tableView.cellForRow(at: indexPath) as? TrackCell {
            cell.playPreview()
            currentlyPlayingIndex = indexPath.row
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}



//  ----------
//import UIKit
//
//class AlbumDetailViewController: UIViewController {
//    private var albumId: Int!
//    private var albumName: String?
//    private var tracks: [Track] = []
//    private var titleLabel: UILabel!
//    private var tracksListView: UITableView!
//
//    required init(albumId: Int) {
//        super.init(nibName: nil, bundle: nil)
//        self.albumId = albumId
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        fetchAlbumData()
//    }
//
//    private func setupViews() {
//        titleLabel = UILabel()
//        tracksListView = UITableView()
//
//        view.addSubview(titleLabel)
//        view.addSubview(tracksListView)
//
//        tracksListView.dataSource = self
//        tracksListView.delegate = self
//        tracksListView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
//    }
//
//    private func fetchAlbumData() {
//        guard let albumId = albumId else {
//            return
//        }
//
//        let urlString = "https://api.deezer.com/album/\(albumId)"
//
//        guard let url = URL(string: urlString) else {
//            return
//        }
//
////        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
////            guard let data = data, error == nil else {
////                return
////            }
////
////            do {
////                let response = try JSONDecoder().decode(Tracks.self, from: data)
////                let trackData = response.data
////                self?.albumName = trackData.first?.title
////                self?.tracks = trackData.tracks.data
////                DispatchQueue.main.async {
////                    self?.configureViews()
////                    self?.titleLabel.text = trackData.album.title
////                    self?.tracksListView.reloadData()
////                }
////            } catch {
////                print("Error decoding album details: \(error)")
////            }
////        }.resume()
////    }
//    URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
//        guard let data = data, error == nil else {
//            // Handle error case
//            return
//        }
//
//        do {
//            let response = try JSONDecoder().decode(Tracks.self, from: data)
//            let trackData = response.tracks.data
//            self?.albumName = trackData.first?.album.title
//            self?.tracks =  trackData
//            DispatchQueue.main.async {
//                self?.configureViews()
//                self?.titleLabel.text = trackData.first?.title
//                self?.tracksListView.reloadData()
//            }
//        } catch {
//            // Handle parsing error
//            print("Error decoding album details: \(error)")
//            print("yoğgkbe knk")
//        }
//    }.resume()
//}
//
//    private func configureViews() {
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//
//        tracksListView.rowHeight = UITableView.automaticDimension
//        tracksListView.estimatedRowHeight = 60
//        tracksListView.separatorStyle = .none
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let margin: CGFloat = 16
//        let titleLabelHeight: CGFloat = 30
//
//        titleLabel.frame = CGRect(x: margin, y: margin, width: view.bounds.width - margin * 2, height: titleLabelHeight)
//        tracksListView.frame = CGRect(x: 0, y: titleLabel.frame.maxY + margin, width: view.bounds.width,height: view.bounds.height - titleLabel.frame.maxY - margin)
//    }
//}
//extension AlbumDetailViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tracks.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
//            return UITableViewCell()
//        }
//
//        let track = tracks[indexPath.row]
//        cell.configure(with: track)
//        cell.likeButton.tag = indexPath.row
//        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped(_:)), for: .touchUpInside)
//
//        return cell
//    }
//
//    @objc private func likeButtonTapped(_ sender: UIButton) {
//        let track = tracks[sender.tag]
//        sender.isSelected.toggle()
//    }
//}
//
//extension AlbumDetailViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTrack = tracks[indexPath.row]
//        print("Selected track: (selectedTrack.title)")
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//
//    private func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let currentlyPlayingIndex = currentlyPlayingIndex, currentlyPlayingIndex != indexPath.row {
//            // Stop the previous preview if it's playing
//            let oldIndexPath = IndexPath(row: currentlyPlayingIndex, section: 0)
//            if let cell = tableView.cellForRow(at: oldIndexPath) as? TrackCell {
//                cell.stopPreview()
//            }
//        }
//
//        if currentlyPlayingIndex == indexPath.row {
//            // Tapped on the currently playing cell, stop the preview
//            currentlyPlayingIndex = nil
//            if let cell = tableView.cellForRow(at: indexPath) as? TrackCell {
//                cell.stopPreview()
//            }
//        } else {
//            // Tapped on a different cell, play the preview
//            currentlyPlayingIndex = indexPath.row
//            if let cell = tableView.cellForRow(at: indexPath) as? TrackCell {
//                cell.playPreview()
//            }
//        }
//    }
//}




