//
//  FavoriteModel.swift
//  game-library
//
//  Created by Sezer Istif on 21.01.2023.
//

import Foundation
import UIKit
import CoreData

class FavoriteModel {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var delegate: FavoriteModelDelegate?
    
    func fetchGamesFromCoreData() {
        let result = CoreDataManager.shared.fetchData(object: GameEntity())
        let favorites = result.map{ Game.init(id: Int($0.id), name: $0.name ?? "", imageURL: $0.imageURL ?? "", rating: $0.rating) }
        
        delegate?.favoritesFetched(favorites: favorites)
    }
    
}

protocol FavoriteModelDelegate {
    func favoritesFetched(favorites: [Game])
}
