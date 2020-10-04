//
//  StorageManager.swift
//  DataCoreApp
//
//  Created by ddyack on 02.10.2020.
//

import Foundation
import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataCoreApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context: NSManagedObjectContext {
        StorageManager.shared.persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
    
    func saveTaskWithContext() -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return nil }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return nil }
        
        return task
    }
    
    func deleteTaskWithContext(task: NSManagedObject) {
        context.delete(task)
        saveContext()
    }
    
    func editTaskWithContext(indexPath: Int, editValue: String){
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest) as? [NSManagedObject]
            
            if tasks?.count != 0 {
                tasks?[indexPath].setValue(editValue, forKey: "name")
            }
        } catch let error {
            print(error)
        }
        
        saveContext()
    }
    
    func fetchTasks() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        var tasks: [Task] = []
        
        do {
            tasks = try self.context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        return tasks
    }
    
}
