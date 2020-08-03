//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    //MARK: Shared instance
    
    static var shared = CoreDataManager()
      
    //MARK: Internal Properties - Core Data Stack
      
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }()
      
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: Resources.string.coreData.bundleResource, withExtension: "momd") else {
            fatalError("Unable to Find Data Model")
        }
          
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Unable to Load Data Model")
        }
          
        return managedObjectModel
    }()
      
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let fileManager = FileManager.default
        let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(Resources.string.coreData.storeName)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                                configurationName: nil,
                                                                at: persistentStoreURL,
                                                                options: nil)
        } catch {
            fatalError("Unable to Load Persistent Store")
        }
        return persistentStoreCoordinator
    }()
}

struct CoreDataService<T: NSManagedObject> {
    func buildFetchRequest(predicate: NSPredicate? = nil,
                           sortDescriptors: [NSSortDescriptor]? = nil,
                           entity: Resources.string.entityName) -> NSFetchRequest<NSFetchRequestResult> {
        let entityName = entity.rawValue
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        return fetchRequest
    }
}

//MARK: DataInterface protocol

extension CoreDataService : DataInterface {
    
    typealias Entity = T
    
    func fetchEntity(predicate: NSPredicate?,
                     sortDescriptors: [NSSortDescriptor]?,
                     propertiesToFetch: String...) throws -> [Entity]? {
        let fetchRequest = Entity.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.propertiesToFetch = propertiesToFetch
        let fetchedResult = try CoreDataManager.shared.managedObjectContext.fetch(fetchRequest) as! [Entity]
        return fetchedResult
    }
    
    func save(context: NSManagedObjectContext) throws {
         if context.hasChanges {
             try context.save()
         }
     }
    
    func delete(context: NSManagedObjectContext) throws {
        let fetchRequest = Entity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        try context.execute(deleteRequest)
        try save(context: context)
    }
}

//MARK: Error conditions

enum CoreDataError: Error {
    case saveFavoriteError
    case savePlayersTeamsError
    case fetchPlayersError
    case fetchTeamsError
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .saveFavoriteError:
            return Resources.string.errorDescription.saveFavorite
        case .savePlayersTeamsError:
            return Resources.string.errorDescription.savePlayersTeamsError
        case .fetchPlayersError:
            return Resources.string.errorDescription.fetchPlayersError
        case .fetchTeamsError:
            return Resources.string.errorDescription.fetchTeamsError
        }
    }
}
