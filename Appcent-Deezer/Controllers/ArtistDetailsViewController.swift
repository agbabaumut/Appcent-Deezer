//
//  ArtistDetailsViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 13.05.2023.
//

import UIKit

class ArtistDetailsViewController: UIViewController {
    var artist: Artist?
    private var artistImageView: UIImageView!
    private var titleLabel: UILabel!
    private var albumsListView: UITableView!
    private var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        configureViews()
        fetchArtistData()
        fetchAlbums()
    }
    
    private func setupViews() {
        artistImageView = UIImageView()
        titleLabel = UILabel()
        albumsListView = UITableView()
        
        view.addSubview(artistImageView)
        view.addSubview(titleLabel)
        view.addSubview(albumsListView)
    }
    
    private func configureViews() {
        artistImageView.contentMode = .scaleAspectFit
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        albumsListView.dataSource = self
        albumsListView.delegate = self
        albumsListView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
    }
    
    private func fetchArtistData() {
        guard let artist = artist else {
            print("yo knkk")
            return
        }
        
        titleLabel.text = artist.name
        
        let urlString = "https://api.deezer.com/artist/\(artist.id)"
        
        guard let url = URL(string: urlString) else {
            // Handle invalid URL
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                // Handle error case or use a placeholder image
                return
            }
            
            do {
                let response = try JSONDecoder().decode(Artist.self, from: data)
                let imageURL = response.picture_xl
                if let imageURL = URL(string: imageURL) {
                    let imageData = try Data(contentsOf: imageURL)
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        self?.artistImageView.image = image
                    }
                }
            } catch {
                // Handle parsing error
                print("Error decoding artist response: \(error)")
            }
        }.resume()
        
        // Fetch artist's albums using the API and populate the albums array
    }
    
    private func fetchAlbums() {
        // Fetch artist's albums using the API
        
        guard let artist = artist else {
            return
        }
        
        let urlString = "https://api.deezer.com/artist/\(artist.id)/albums"
        
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
                let response = try JSONDecoder().decode(AlbumResponse.self, from: data)
                self?.albums = response.data
                DispatchQueue.main.async {
                    self?.albumsListView.reloadData()
                }
            } catch {
                // Handle parsing error
                print("Error decoding albums: \(error)")
            print("olmadı ustağ")
            }
        }.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let margin: CGFloat = 16
        let imageViewWidth = view.bounds.width - 2 * margin
        let imageViewHeight = imageViewWidth / 2
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        artistImageView.frame = CGRect(x: margin, y: tabBarHeight + margin, width: imageViewWidth, height: imageViewHeight)
        titleLabel.frame = CGRect(x: margin, y: tabBarHeight + margin + imageViewHeight + margin, width: imageViewWidth, height: 30)
        albumsListView.frame = CGRect(x: 0, y: tabBarHeight + margin + imageViewHeight + margin + 30 + margin, width: view.bounds.width, height: view.bounds.height - tabBarHeight - margin - imageViewHeight - margin - 30 - margin)
    }
}

extension ArtistDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as? AlbumCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configure(with: album)
        
        return cell
    }
    
    
}

extension ArtistDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlbum = albums[indexPath.row]
        let albumDetailVC = AlbumDetailViewController(albumId: selectedAlbum.id)
        navigationController?.pushViewController(albumDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


