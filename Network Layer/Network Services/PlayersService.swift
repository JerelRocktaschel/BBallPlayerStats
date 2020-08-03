//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation

//MARK: Result

enum Result<T>{
    case success(T?)
    case failure(LocalizedError)
}

//MARK: Protocol

protocol PlayersNetworkService {
    func getPlayers(completion: @escaping (_ players: [Player]?, _ error: LocalizedError?)->())
}

struct PlayersService {
}

//MARK: PlayersNetworkService

extension PlayersService: PlayersNetworkService {
    func getPlayers(completion: @escaping (_ players: [Player]?, _ error: LocalizedError?)->()){
        let year = SeasonYearFormatter.getCurrentSeasonYear()
        let router = Router<PlayersApi>()
        router.request(.playerList(season: year)) { data, response, error in
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
                        guard let apiResponse = PlayerApiResponse(json: json!) else {
                            completion(nil, NetworkManagerError.unableToDecodeError)
                            return
                        }
                        completion(apiResponse.players, nil)
                    } catch {
                        print(error)
                        completion(nil, NetworkManagerError.unableToDecodeError)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
                }
            }
        }
    }
}

struct SeasonYearFormatter {
    
    //MARK: Helper
    
    static func getCurrentSeasonYear() -> String {
        ///nba uses beginning season year in url
        ///if current date > new season start date - use current year
        ///if current date < new season start date - use last year
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Resources.string.dateFormat.urlDateformat
        var year = String(Calendar.current.component(.year, from: currentDate))
        let newSeasonDateString = Resources.string.seasonStart.value + year
        if let newSeasonDate = dateFormatter.date(from: newSeasonDateString),
            let yearInt = Int(year),
            currentDate < newSeasonDate {
                year = String(yearInt - 1)
        }
        return year
    }
}


