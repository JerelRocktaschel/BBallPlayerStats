//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

//MARK: Protocol

protocol TeamsDataInterface {
    func buildTeamsFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    func save(teams: [TeamViewModel]) throws
    func fetchTeams(predicate: NSPredicate?,
                    sortDescriptors: [NSSortDescriptor]?,
                    propertiesToFetch: String...) throws -> [TeamModel]?
    func deleteTeams() throws
}

struct TeamsDataService {
    
    //MARK: Properties
    
    private let dataService = CoreDataService<TeamModel>()
    let sortDescriptors = [NSSortDescriptor(key: Resources.string.sortDescriptors.teams.city, ascending: true)]
}

//MARK: TeamsDataInterface

extension TeamsDataService : TeamsDataInterface {
    func buildTeamsFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let teamsFetchRequest = dataService.buildFetchRequest(sortDescriptors: sortDescriptors,
                                                                entity: Resources.string.entityName.TeamModel)
        return teamsFetchRequest
    }
    
    func fetchTeams(predicate: NSPredicate?,
                    sortDescriptors: [NSSortDescriptor]?,
                    propertiesToFetch: String...) throws -> [TeamModel]? {
        let teamModels = try dataService.fetchEntity(predicate: nil,
                                                     sortDescriptors: nil)
        return teamModels
    }
    
    func save(teams: [TeamViewModel]) throws {
        let context = CoreDataManager.shared.managedObjectContext
        for team in teams {
            let teamManagedObject = TeamModel(context: context)
            teamManagedObject.id = team.id
            teamManagedObject.name = team.name
            teamManagedObject.city = team.city
            teamManagedObject.abbreviation = team.abbreviation
        }
        try dataService.save(context: context)
    }
    
    func deleteTeams() throws {
        let context = CoreDataManager.shared.managedObjectContext
        try dataService.delete(context: context)
    }
}
