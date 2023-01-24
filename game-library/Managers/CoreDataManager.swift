//
//  CoreDataManager.swift
//  game-library
//
//  Created by Sezer Istif on 24.01.2023.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func fetchData<T: NSManagedObject>(object: T) -> [T] {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: type(of: object)))
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch let error as NSError {
            print("Could not fetch. \(error)")
            return []
        }
    }
    
    func insertData<T: NSManagedObject>(object: T) {
        let context = appDelegate.persistentContainer.viewContext
        let newObject = NSEntityDescription.insertNewObject(forEntityName: String(describing: type(of: object)), into: context)
        for (key, _) in object.entity.attributesByName {
            newObject.setValue(object.value(forKey: key), forKey: key)
        }
        
    }
    
    func removeObject<T: NSManagedObject>(object: T, id: Int) {
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<GameEntity>
        fetchRequest = GameEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "id = %ld", id
        )
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("Could not remove object. \(error)")
        }
    }
}

