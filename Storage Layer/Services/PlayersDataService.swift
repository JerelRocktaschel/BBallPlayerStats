//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

//MARK: Protocol

protocol PlayersDataInterface {
    func buildPlayersFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    func save(players: [PlayerViewModel],
              with favorites: [FavoriteModel]?,
              and teams: [TeamModel]?) throws
    func deletePlayers() throws
}

struct PlayersDataService {
    
    //MARK: Properties
    
    private let dataService = CoreDataService<PlayerModel>()
    private let sortDescriptors = [
        NSSortDescriptor(key: Resources.string.sortDescriptors.players.lastName, ascending: true),
        NSSortDescriptor(key: Resources.string.sortDescriptors.players.firstName, ascending: true)]
    
    //MARK: Helper
    
    private func configureFavorite(for player: PlayerModel, favorites: [FavoriteModel]?) {
        let filteredFavorites = favorites?.filter() { $0.id == player.id }
        let filteredFavoritesCount = filteredFavorites?.count ?? 0
        if filteredFavoritesCount > 0 {
            let favoriteDataService = FavoriteDataService()
            favoriteDataService.configureFavoriteRelationship(for: player)
        }
    }
       
    private func configureTeam(for playerModel: PlayerModel,
                                  with teams: [TeamModel]?,
                                  and playerViewModel: PlayerViewModel)  {
        if let team = teams?.first(where:{$0.id == playerViewModel.teamID}) {
               playerModel.team = team
        }
    }
}

//MARK: PlayersDataInterface

extension PlayersDataService : PlayersDataInterface {
    func buildPlayersFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let playersFetchRequest = dataService.buildFetchRequest(sortDescriptors: sortDescriptors,
                                                                entity: Resources.string.entityName.PlayerModel)
        return playersFetchRequest
    }
    
    func save(players: [PlayerViewModel],
              with favorites: [FavoriteModel]?,
              and teams: [TeamModel]?) throws {
        let context = CoreDataManager.shared.managedObjectContext
        for player in players {
            let playerModel = PlayerModel(context: context)
            playerModel.id = player.id
            playerModel.firstName = player.firstName
            playerModel.lastName = player.lastName
            playerModel.jersey = player.jersey
            playerModel.feet = player.feet
            playerModel.inches = player.inches
            playerModel.pounds = player.pounds
            playerModel.age = player.age
            playerModel.dateOfBirth = player.dateOfBirth
            playerModel.position = player.position
            configureTeam(for: playerModel, with: teams, and: player)
            configureFavorite(for: playerModel, favorites: favorites)
        }
        try dataService.save(context: context)
    }
    
    func deletePlayers() throws {
        let context = CoreDataManager.shared.managedObjectContext
        try dataService.delete(context: context)
    }
}
