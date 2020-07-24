//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

final class CoreDataManager {
    
    //MARK: Shared instance
    
    static let shared = CoreDataManager()
    
    //MARK: Internal Properties - Core Data Stack
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator =  persistentStoreCoordinator
        managedObjectContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.overwriteMergePolicyType)
        return managedObjectContext
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: Resources.string.coreData.bundleResource, withExtension: "momd")
        else {
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
    
    //MARK: Public functions
    
    func buildFetchRequest(with predicate: NSPredicate? = nil,
                               sortDescriptors: [NSSortDescriptor]? = nil,
                               fetchLimit: Int? = nil,
                               entity: Resources.string.entityName) -> NSFetchRequest<NSFetchRequestResult> {
        let entityName = entity.rawValue
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        return fetchRequest
    }
    
    func processData(with playerViewModels: [PlayerViewModel],
                     and teamViewModels: [TeamViewModel]) throws {
        let favoriteIds = try fetchFavoriteIds()
        try delete(in: Resources.string.entityName.TeamModel)
        try delete(in: Resources.string.entityName.PlayerModel)
        try saveTeams(teamViewModels)
        try savePlayers(playerViewModels, with: favoriteIds)
    }
    
    func saveFavoriteRelationship(for playerModel: PlayerModel) throws  {
        if let favorite = playerModel.favorite {
            managedObjectContext.delete(favorite)
        } else {
            configureFavoriteRelationship(for: playerModel)
        }
        try saveContext()
    }
    
    //MARK: Private Functions
    
    private func fetch(from entity: Resources.string.entityName) throws -> [NSFetchRequestResult]? {
        let entityName = entity.rawValue
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let fetchedResult = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        return fetchedResult
    }
    
    private func fetch(from entity: Resources.string.entityName,
                           limitedto properties: String... ) throws -> [NSFetchRequestResult]? {
        let entityName = entity.rawValue
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.propertiesToFetch = properties
        let fetchedResult = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        return fetchedResult
    }
    
    private func fetchFavoriteIds() throws -> Set<String> {
        var favoritePlayersIds = Set<String>()
        if let favorites = try fetch(
            from: Resources.string.entityName.FavoriteModel,
            limitedto: "id"
            ) as? [FavoriteModel] {
            for favorite in favorites {
                if let playerId = favorite.id {
                    favoritePlayersIds.insert(playerId)
                }
            }
        }
        return favoritePlayersIds
    }
    
    private func configureFavoriteRelationship(for playerModel: PlayerModel) {
        let favoriteModel = FavoriteModel(context: managedObjectContext)
        favoriteModel.id = playerModel.id
        favoriteModel.player = playerModel
    }
    
    private func savePlayers(_ players: [PlayerViewModel],
                              with favoriteIds: Set<String>) throws {
        let teams = try fetch(from: Resources.string.entityName.TeamModel) as? [TeamModel]
        for player in players {
            let playerModel = PlayerModel(context: managedObjectContext)
            playerModel.id = player.id
            playerModel.firstName = player.firstName
            playerModel.lastName = player.lastName
            playerModel.jersey = player.jersey
            playerModel.feet = player.feet
            playerModel.inches = player.inches
            playerModel.pounds = player.pounds
            playerModel.age = player.age
            playerModel.dateOfBirth = player.dateOfBirth
            
            ///some players have multiple positions - display main position
            //TODO this code should be in player model String(player.position.prefix(1))
            playerModel.position = String(player.position.prefix(1))
            if let team = teams?.first(where:{$0.id == player.teamID}) {
                playerModel.team = team
            }
            
            if favoriteIds.contains(player.id) {
                  configureFavoriteRelationship(for: playerModel)
            }
        }
        try saveContext()
    }
    
    private func saveTeams(_ teams: [TeamViewModel]) throws {
        for team in teams {
            let teamManagedObject = TeamModel(context: managedObjectContext)
            teamManagedObject.id = team.id
            teamManagedObject.name = team.name
            teamManagedObject.city = team.city
            teamManagedObject.abbreviation = team.abbreviation
        }
        try saveContext()
    }

    private func delete(in entity: Resources.string.entityName) throws {
        let entityName = entity.rawValue
        let context = managedObjectContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        try context.execute(deleteRequest)
        try saveContext()
    }
    
    private func saveContext() throws {
        let context = managedObjectContext
        if context.hasChanges {
            try context.save()
        }
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
