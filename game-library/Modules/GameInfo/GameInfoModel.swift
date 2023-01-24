//
//  GameInfoModel.swift
//  game-library
//
//  Created by Sezer Istif on 23.01.2023.
//

import Foundation
import UIKit
import CoreData

protocol GameInfoModelDelegate: AnyObject {
    func commentsFetched(comments: [Comment])
    
}

class GameInfoModel {
    weak var delegate: GameInfoModelDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveCommentToCoreData(header: String, text: String, gameID: Int) {
        let context = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "GameCommentEntity", in: context) {
            let comment = NSManagedObject(entity: entity, insertInto: context)
            comment.setValue(header, forKey: "header")
            comment.setValue(text, forKey: "text")
            comment.setValue(gameID, forKey: "gameID")
            
            do {
                try context.save()
                fetchCommentsFromCoreData(gameID: gameID)
            } catch {
                print("ERROR while saving data to CoreData")
            }
        }
    }
    
    func fetchCommentsFromCoreData(gameID: Int) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<GameCommentEntity>
        fetchRequest = GameCommentEntity.fetchRequest()

        
        do {
            let results = try context.fetch(fetchRequest)
            let filteredResults = results.filter{ Int($0.gameID) == gameID }
            let comments = filteredResults.map{ Comment.init(header: $0.header ?? "", text: $0.text ?? "", gameID: Int($0.gameID)) }
            
            if (comments.count > 0) {
                delegate?.commentsFetched(comments: comments)
            }
        } catch {
            print("Error while fetching from core data")
        }
        
    }
}

struct Comment {
    let header: String
    let text: String
    let gameID: Int
}
