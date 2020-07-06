//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

struct TeamViewModel {
    
    //MARK: Internal Properties
    
    let id: String
    let city: String
    let name: String
    let abbreviation: String
    
    //MARK: Init
    
    init(team: Team) {
        id = team.id
        city = team.city
        name = team.name
        abbreviation = team.abbreviation
    }
}

class TeamListViewModel: NSObject {
    
    //MARK: Typealias
    
    typealias GetTeamsListViewModelCompletion = (_ teamViewModels: [TeamViewModel]?, _ error: LocalizedError?)->()
    
    //MARK: Public functions
    
    func getData(completion: @escaping GetTeamsListViewModelCompletion) {
        NetworkManager.shared.getTeams{ teams, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
                  
            guard let teamsList = teams else {
                completion(nil, TeamListViewModelError.noTeamsReturned)
                return
            }

            let teamViewModels = (teamsList.compactMap(TeamViewModel.init))
            completion(teamViewModels, nil)
        }
    }
}

//MARK: Error conditions

enum TeamListViewModelError: Error {
    case noTeamsReturned
}

extension TeamListViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noTeamsReturned:
            return Resources.string.errorDescription.noTeamsReturned
        }
    }
}
