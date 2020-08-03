//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

//MARK: Protocol

protocol ProcessDataInterface {
    mutating func processData(playerViewModels: [PlayerViewModel],
                              teamViewModels: [TeamViewModel]) throws
}

struct ProcessDataService {
    
    //MARK: Properties
    
    private lazy var playersDataService = PlayersDataService()
    private lazy var teamsDataService = TeamsDataService()
    private lazy var favoriteDataService = FavoriteDataService()
}

//MARK: ProcessDataInterface

extension ProcessDataService : ProcessDataInterface {
    mutating func processData(playerViewModels: [PlayerViewModel],
                     teamViewModels: [TeamViewModel]) throws {
        let favoriteModels = try favoriteDataService.fetchFavorites()
        try teamsDataService.deleteTeams()
        try playersDataService.deletePlayers()
        try teamsDataService.save(teams: teamViewModels)
        let teamModels = try teamsDataService.fetchTeams(predicate: nil,
                                                         sortDescriptors: nil)
        try playersDataService.save(players: playerViewModels,
                                    with: favoriteModels,
                                    and: teamModels)
    }
}
