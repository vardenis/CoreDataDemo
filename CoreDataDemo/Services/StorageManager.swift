//
//  StorageManager.swift
//  CoreDataDemo
//
//  Created by Денис on 26.05.2022.
//

import Foundation
import CoreData


class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    let viewContext: NSManagedObjectContext
    
    
    
    
    private init () {
        viewContext = persistentContainer.viewContext
    }
    
    
    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveTask(taskName: String, completion: (Task) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: viewContext) else { return }
        guard let task = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Task else { return }
        task.title = taskName
        completion(task)
        
        saveContext()
    }
    
    func editTask(task: Task, name: String) {
        task.title = name
        saveContext()
    }
    
    func deleteTask(task: Task) {
        viewContext.delete(task)
        saveContext()
    }
    
    
    func fetchData(completion: (Result<[Task], Error>) -> Void) {
        let fetchRequest = Task.fetchRequest()
        
        do {
            let taskList = try viewContext.fetch(fetchRequest)
            completion(.success(taskList))
        } catch let error {
            completion(.failure(error))
        }
    }
}
