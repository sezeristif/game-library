//
//  FavoritesViewModel.swift
//  game-library
//
//  Created by Sezer Istif on 21.01.2023.
//

import Foundation
import UIKit
import CoreData

class FavoritesViewModel {
    let model = FavoriteModel()
    var delegate: FavoritesViewModelDelegate?
    let notificationCenter = NotificationCenter.default
    
    init() {
        notificationCenter.addObserver(self, selector: #selector(self.favoritesChanged), name: Notification.Name("FavoritesChanged"), object: nil)
        model.delegate = self
    }
    
    func fetchFavorites() {
        model.fetchGamesFromCoreData()
    }
    
    @objc func favoritesChanged(){
        fetchFavorites()
    }
}

extension FavoritesViewModel: FavoriteModelDelegate {
    func favoritesFetched(favorites: [Game]) {
        delegate?.setFavorites(favorites: favorites)
    }
}



extension FavoritesViewModel: GamesTableViewCellViewModel {
    func favorite(game: Game) {}
    
    func unFavorite(id: Int) {}
}

protocol FavoritesViewModelDelegate {
    func setFavorites(favorites: [Game])
}
