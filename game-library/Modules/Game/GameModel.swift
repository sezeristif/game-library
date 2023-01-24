//
//  GameModel.swift
//  game-library
//
//  Created by Sezer Istif on 15.01.2023.
//

import Foundation
import Alamofire
import CoreData

protocol GameModelDelegate: AnyObject {
    func didLiveDataFetch()
    func didDataCouldntFetch()
    func coreDataFetch(favorites: [Game])
    func favoritesChanged(favorites: [Game])
}

struct Game {
    let id: Int
    let name: String
    let imageURL: String
    let rating: Double
}

class GameModel {
    private(set) var data: [Result] = []
    private(set) var favoriteGameIds: [Int] = []
    private let url = "https://api.rawg.io/api/games"
    weak var delegate: GameModelDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var lastFetchedPage = 1
    
    func fetchData(searchQuery: String?, page: Int?, genres: String? = nil) {
        var parameters: Parameters = [
            "key": Bundle.main.infoDictionary?["RAWG_API_KEY"] as? String ?? ""
        ]
        
        parameters["page_size"] = 10
        parameters["page"] = page ?? 1
        parameters["genres"] = genres
        
        if searchQuery != nil {
            parameters["search"] = searchQuery
        }
        
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: GameData.self) { (res) in
            guard
                let response = res.value
            else {
                self.delegate?.didDataCouldntFetch()
                return
            }
            
            let newData = self.lastFetchedPage == page! ? response.results : self.data + (response.results ?? [])
            self.data = newData ?? []
            self.delegate?.didLiveDataFetch()
        }
    }
    
    func saveGameToCoreData(game: Game) {
        let favorites = CoreDataManager.shared.fetchData(object: GameEntity())
        
        if (favorites.map{ Int($0.id) }.contains(Int(game.id))) {
            // Return if already favorited
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
            
        
        if let entity = NSEntityDescription.entity(forEntityName: "GameEntity", in: context) {
            let gameEntity = NSManagedObject(entity: entity, insertInto: context)
            gameEntity.setValue(game.id, forKey: "id")
            gameEntity.setValue(game.name, forKey: "name")
            gameEntity.setValue(game.imageURL, forKey: "imageURL")
            gameEntity.setValue(game.rating, forKey: "rating")
            
            CoreDataManager.shared.insertData(object: gameEntity)
            
            let result = CoreDataManager.shared.fetchData(object: GameEntity())
            let newFavorites = result.map{ Game.init(id: Int($0.id), name: $0.name ?? "", imageURL: $0.imageURL ?? "", rating: $0.rating) }
            delegate?.favoritesChanged(favorites: newFavorites)
        }
    }
    
    func fetchCoreData() {
        let result = CoreDataManager.shared.fetchData(object: GameEntity())
        let favorites = result.map{ Game.init(id: Int($0.id), name: $0.name ?? "", imageURL: $0.imageURL ?? "", rating: $0.rating) }
        
        delegate?.coreDataFetch(favorites: favorites)
    }
    
    func removeGameFromCoreData(id: Int) {
        CoreDataManager.shared.removeObject(object: GameEntity(), id: id)
        fetchCoreData()
    }
}

