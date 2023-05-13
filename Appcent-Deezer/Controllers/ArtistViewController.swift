//
//  ArtistViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import UIKit

class ArtistViewController: UIViewController {
    public var artists: [Artist] = []
    private var collectionView: UICollectionView!
    private var genreNameLabel: UILabel!
    var genreId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupGenreNameLabel()
        setupCollectionView()
        fetchArtists()
        
        title = "Artists"
        
    }
    
    private func setupGenreNameLabel() {
        genreNameLabel = UILabel(frame: CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 30))
        genreNameLabel.textAlignment = .center
        genreNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(genreNameLabel)
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 150, width: view.bounds.width, height: view.bounds.height - 150), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ArtistCell.self, forCellWithReuseIdentifier: "ArtistCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    private func fetchArtists() {
        guard let genreId = genreId else {
            return
        }
        
        let urlString = "https://api.deezer.com/genre/\(genreId)/artists"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                // Handle error case
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ArtistResponse.self, from: data)
                self?.artists = response.data
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                // Handle parsing error
                print("Error decoding artists: \(error)")
            }
        }.resume()
    }
}

extension ArtistViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as? ArtistCell else {
            return UICollectionViewCell()
        }
        
        let artist = artists[indexPath.item]
        cell.configure(with: artist)
        
        return cell
    }
}

extension ArtistViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedArtist = artists[indexPath.item]
        let artistDetailsViewController = ArtistDetailsViewController()
                artistDetailsViewController.artist = selectedArtist
                navigationController?.pushViewController(artistDetailsViewController, animated: true)
    }
}

extension ArtistViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 40) / 2
        let itemHeight: CGFloat = 200
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
