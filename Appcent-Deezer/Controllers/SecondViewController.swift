//
//  SecondViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//
//
import UIKit

class SecondViewController: UIViewController {
    private var tableView: UITableView!
    private var likedSongs: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()


        setupViews()
        configureViews()
        fetchLikedSongs()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchLikedSongs()
    }

    private func setupViews() {
        tableView = UITableView()

        view.addSubview(tableView)
    }

    private func configureViews() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
    }

    private func fetchLikedSongs() {
        likedSongs = LikedSongsManager.shared.getLikedSongs()
        tableView.reloadData()
        print(likedSongs)
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if likedSongs.isEmpty {
            // Return 1 to display the empty list view cell
            return 1
        } else {
            // Return the count of likedSongs to display the actual cells
            return likedSongs.count

        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if likedSongs.isEmpty {
            // Create and configure an empty list view cell
            let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            emptyCell.textLabel?.text = "No liked songs yet"
            emptyCell.textLabel?.textAlignment = .center
            return emptyCell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
                return UITableViewCell()
            }

            let track = likedSongs[indexPath.row]
                        cell.configure(with: track)
                        cell.delegate = self
            return cell

        }
    }
}


extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrack = likedSongs[indexPath.row]
        // Handle the selection of the track
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}

extension SecondViewController: TrackCellDelegate {
    func trackCell(_ cell: TrackCell, didChangeLikedState isLiked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let track = likedSongs[indexPath.row]

        if isLiked {
            LikedSongsManager.shared.addTrack(track)
        } else {
            LikedSongsManager.shared.removeTrack(track)
        }
    }
}

//import UIKit
//
//class SecondViewController: UIViewController {
//    private var tableView: UITableView!
//    private var likedSongs: [Track] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        configureViews()
//        fetchLikedSongs()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        tableView.frame = view.bounds
//    }
//
//    private func setupViews() {
//        tableView = UITableView()
//
//        view.addSubview(tableView)
//    }
//
//    private func configureViews() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
//    }
//
//    private func fetchLikedSongs() {
//        likedSongs = LikedSongsManager.shared.getLikedSongs()
//        tableView.reloadData()
//        print(likedSongs)
//    }
//}
//
//extension SecondViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if likedSongs.isEmpty {
//            // Return 1 to display the empty list view cell
//            return 1
//        } else {
//            // Return the count of likedSongs to display the actual cells
//            return likedSongs.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if likedSongs.isEmpty {
//            // Create and configure an empty list view cell
//            let emptyCell = UITableViewCell(style: .default, reuseIdentifier: nil)
//            emptyCell.textLabel?.text = "No liked songs yet"
//            emptyCell.textLabel?.textAlignment = .center
//            return emptyCell
//        } else {
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
//                return UITableViewCell()
//            }
//
//            let track = likedSongs[indexPath.row]
//            cell.configure(with: track)
//            cell.delegate = self
//            cell.isLiked = LikedSongsManager.shared.getLikedSongs().contains { $0 == track }
//
//
//            return cell
//        }
//    }
//}
//
//extension SecondViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedTrack = likedSongs[indexPath.row]
//        // Handle the selection of the track
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
//}
//
//extension SecondViewController: TrackCellDelegate {
//    func trackCell(_ cell: TrackCell, didChangeLikedState isLiked: Bool) {
//        guard let indexPath = tableView.indexPath(for: cell) else {
//            return
//        }
//
//        let track = likedSongs[indexPath.row]
//
//        if isLiked {
//            LikedSongsManager.shared.addTrack(track)
//        } else {
//            LikedSongsManager.shared.removeTrack(track)
//        }
//    }
//}
//
