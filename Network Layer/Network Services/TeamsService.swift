//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation

//MARK: Protocol

protocol TeamsNetworkService {
    func getTeams(completion: @escaping (_ teams: [Team]?, _ error: LocalizedError?)->())
}

struct TeamsService {
}

//MARK: TeamsNetworkService

extension TeamsService : TeamsNetworkService {
    func getTeams(completion: @escaping (_ teams: [Team]?, _ error: LocalizedError?)->()) {
        let year = SeasonYearFormatter.getCurrentSeasonYear()
        let router = Router<PlayersApi>()
        router.request(.teamList(season: year))  { data, response, error in
            guard error == nil else {
                completion(nil, NetworkManagerError.networkConnectivityError)
                return
            }
              
            if let response = response as? HTTPURLResponse {
                let result = NetworkResponseHandler.handleNetworkResponse (response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkManagerError.noDataError)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        guard let apiResponse = TeamApiResponse(json: json!) else {
                            completion(nil, NetworkManagerError.unableToDecodeError)
                            return
                    }
                        completion(apiResponse.teams, nil)
                    } catch {
                        completion(nil, NetworkManagerError.unableToDecodeError)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}
