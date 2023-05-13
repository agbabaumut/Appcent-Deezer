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
        
        title = artist?.name
    }
    private func configureViews() {
        
        artistImageView.contentMode = .scaleAspectFit
        
        albumsListView.dataSource = self
        albumsListView.delegate = self
        albumsListView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
    }
    private func setupViews() {
        artistImageView = UIImageView()
        albumsListView = UITableView()
        
        view.addSubview(artistImageView)
        view.addSubview(albumsListView)
        view.backgroundColor = .orange
    }
    
    private func fetchArtistData() {
        guard let artist = artist else {
            return
        }
        
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
            }
        }.resume()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let margin: CGFloat = 15
        let imageViewWidth = view.bounds.width - 2 * margin // This will make the image narrower
        let imageViewHeight = imageViewWidth * 0.6 // Adjust the aspect ratio to make it smaller
        let tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0

        // Position the image view in the center of X and with the new size
        artistImageView.frame = CGRect(
            x: (view.bounds.width - imageViewWidth) / 2, // Center the image view
            y: tabBarHeight + margin,
            width: imageViewWidth,
            height: imageViewHeight
        )
        
        albumsListView.frame = CGRect(
            x: 0,
            y: artistImageView.frame.maxY + margin,
            width: view.bounds.width,
            height: view.bounds.height - artistImageView.frame.maxY - margin
        )
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


