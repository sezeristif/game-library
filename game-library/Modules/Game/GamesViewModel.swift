//
//  GamesViewModel.swift
//  game-library
//
//  Created by Sezer Istif on 15.01.2023.
//

import Foundation
import UserNotifications


class GamesViewModel {
    
    private let model = GameModel()
    let notificationCenter = NotificationCenter.default
    
    var onError: ((String) -> ())?
    var refreshItems: (([Game]) -> ())?
    var setFavorites: (([Game]) -> ())?
    var reloadTable: (() -> ())?
    
    init() {
        model.delegate = self
    }
    
    func didViewLoad() {
        model.fetchData(searchQuery: nil, page: 1)
        model.fetchCoreData()
    }
    
    func fetchData(searchText: String, page: Int, genres: String? = nil) {
        model.fetchData(searchQuery: searchText, page: page, genres: genres)
    }
    
    func fetchCoreData() {
        model.fetchCoreData()
    }
}

extension GamesViewModel: GameModelDelegate {
    func didLiveDataFetch() {
        let cellModels: [Game] = model.data.map{ .init(id: $0.id ?? 0, name: $0.name ?? "", imageURL: $0.backgroundImage ?? "", rating: $0.rating ?? 0) }
        refreshItems?(cellModels)
    }
    
    func didDataCouldntFetch() {
        onError?("Please try again later !")
    }
    
    func coreDataFetch(favorites: [Game]) {
        setFavorites?(favorites)
        notificationCenter.post(name: Notification.Name("FavoritesChanged"), object: nil)
    }
    
    func favoritesChanged(favorites: [Game]) {
        setFavorites?(favorites)
        notificationCenter.post(name: Notification.Name("FavoritesChanged"), object: nil)
    }
}

extension GamesViewModel: GamesTableViewCellViewModel {
    func favorite(game: Game) {
        model.saveGameToCoreData(game: game)
    }
    
    func unFavorite(id: Int) {
        model.removeGameFromCoreData(id: id)
    }
}
