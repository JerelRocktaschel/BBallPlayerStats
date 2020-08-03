//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

//MARK: Protocol

protocol TeamPlayersDataInterface {
    func buildTeamPlayersFetchRequest(teamId: String) -> NSFetchRequest<NSFetchRequestResult>
}

struct TeamPlayersDataService {
    
    //MARK: Properties
    
    private let dataService = CoreDataService()
    let sortDescriptors = [NSSortDescriptor(key: Resources.string.sortDescriptors.teams.city, ascending: true)]
}

//MARK: TeamPlayersDataInterface

extension TeamPlayersDataService : TeamPlayersDataInterface {
    func buildTeamPlayersFetchRequest(teamId: String) -> NSFetchRequest<NSFetchRequestResult> {
        let predicate = NSPredicate(format: Resources.string.predicate.teamPlayers.format, teamId)
        let sortDescriptors =  [NSSortDescriptor(key: Resources.string.sortDescriptors.teamPlayers.lastName, ascending: true),
                                NSSortDescriptor(key: Resources.string.sortDescriptors.teamPlayers.firstName, ascending: true)]
        let teamsFetchRequest = dataService.buildFetchRequest(predicate: predicate,
                                                              sortDescriptors: sortDescriptors,
                                                              entity: Resources.string.entityName.PlayerModel)
        return teamsFetchRequest
    }
}
