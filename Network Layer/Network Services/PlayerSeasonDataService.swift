//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation

//MARK: Protocol

protocol PlayerSeasonDataNetworkService {
    func getPlayerSeasonData(playerID: String, completion: @escaping (_ data: PlayerSeasonData?, _ error: LocalizedError?)->())
}

struct PlayerSeasonDataService {
}

//MARK: PlayerSeasonDataNetworkService

extension PlayerSeasonDataService : PlayerSeasonDataNetworkService {
    func getPlayerSeasonData(playerID: String, completion: @escaping (_ data: PlayerSeasonData?, _ error: LocalizedError?)->()){
        let year = SeasonYearFormatter.getCurrentSeasonYear()
        let router = Router<PlayersApi>()
        router.request(.playerCurrentSeasonData(year: year, player: playerID)) { data, response, error in
            guard error == nil else {
                completion(nil, NetworkManagerError.networkConnectivityError)
                  return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = NetworkResponseHandler.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkManagerError.noDataError)
                        return
                    }
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
                        
                        guard let apiResponse = PlayerSeasonDataApiResponse(json: json!) else {
                            completion(nil, NetworkManagerError.unableToDecodeError)
                            return
                        }
                        completion(apiResponse.playerSeasonData, nil)
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
