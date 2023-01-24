//
//  FavoritesTableViewController.swift
//  game-library
//
//  Created by Sezer Istif on 21.01.2023.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
    private let cellIdentifier = "GamesTableViewCell"
    private let viewModel = FavoritesViewModel()
    var favorites: [Game] = []
    @IBOutlet weak var noFavoritesText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.register(.init(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView?.backgroundColor = .systemGray3
        viewModel.delegate = self
        viewModel.fetchFavorites()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! GamesTableViewCell
        let games = favorites.map{ Game.init(id: $0.id, name: $0.name, imageURL: $0.imageURL, rating: $0.rating) }
        cell.configure(with: games[indexPath.row], favorites: favorites.map{ $0.id })
        cell.viewModel = viewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}


extension FavoritesTableViewController: FavoritesViewModelDelegate {
    func setFavorites(favorites: [Game]) {
        self.favorites = favorites
        noFavoritesText.isHidden = favorites.count != 0
        tableView.reloadData()
    }
    
}
