//
//  FirstViewController.swift
//  Appcent-Deezer
//
//  Created by Umut Ağbaba on 12.05.2023.
//

import UIKit

class FirstViewController: UIViewController {
    
    private var genres: [Genre] = []
    var selectedGenre: String?
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (view.frame.width - 30) / 2, height: (view.frame.width - 30) / 2 + 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.reuseIdentifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenres()
        
        navigationController?.navigationBar.barTintColor = .red
        navigationController?.navigationBar.isTranslucent = true
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }
    
    
    
    func fetchGenres() {
        guard let url = URL(string: "https://api.deezer.com/genre") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching genres: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let genres = try JSONDecoder().decode(GenreResponse.self, from: data)
                DispatchQueue.main.async {
                    self.genres = genres.data
                    self.collectionView.reloadData()
                }
            } catch let jsonError {
                print("Failed to decode JSON:", jsonError)
            }
        }
        
        task.resume()
    }
}

extension FirstViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.reuseIdentifier, for: indexPath) as! GenreCell
        let genre = genres[indexPath.item]
        cell.configure(with: genre)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width + 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedGenre = genres[indexPath.item]
        fetchArtists(for: selectedGenre.id, with: selectedGenre.name)
    }
    
    func fetchArtists(for genreId: Int, with genreName: String) {
        guard let url = URL(string: "https://api.deezer.com/genre/\(genreId)/artists") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching artists: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data returned")
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ArtistResponse.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    let artistViewController = ArtistViewController()
                    artistViewController.genreId = genreId
                    artistViewController.artists = response.data
                    artistViewController.genreName = genreName
                    DispatchQueue.main.async {
                        if let navigationController = self?.navigationController {
                            navigationController.pushViewController(artistViewController, animated: true)
                        } else {
                            print("Navigation controller is nil.")
                        }
                    }
                }
                
            } catch {
                print("Error decoding artists: \(error)")
            }
        }
        
        task.resume()
    }
    
}
