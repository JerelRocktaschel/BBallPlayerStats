//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

//MARK: Protocol

protocol FavoriteDataInterface {
    func saveFavoriteRelationship(for playerModel: PlayerModel) throws
    func fetchFavorites() throws -> [FavoriteModel]?
}

struct FavoriteDataService {
    
    //MARK: Properties
    
    private let dataService = CoreDataService<FavoriteModel>()
    
    //MARK: Helper
    
    func configureFavoriteRelationship(for playerModel: PlayerModel) {
        let favoriteModel = FavoriteModel(context: CoreDataManager.shared.managedObjectContext)
        favoriteModel.id = playerModel.id
        favoriteModel.player = playerModel
    }
}

//MARK: FavoriteDataInterface

extension FavoriteDataService : FavoriteDataInterface {
    func saveFavoriteRelationship(for playerModel: PlayerModel) throws {
        let context = CoreDataManager.shared.managedObjectContext
        if let favorite = playerModel.favorite {
            context.delete(favorite)
        } else {
            configureFavoriteRelationship(for: playerModel)
        }
        try dataService.save(context: context)
    }
    
    func fetchFavorites() throws -> [FavoriteModel]? {
        let favorites = try dataService.fetchEntity(predicate: nil,
                                                    sortDescriptors: nil,
                                                    propertiesToFetch: "id")
        return favorites
     }
}
