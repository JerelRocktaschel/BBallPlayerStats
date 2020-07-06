//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

//MARK: Result

enum Result<T>{
    case success(T?)
    case failure(LocalizedError)
}

struct NetworkManager {
    
    //MARK: Shared
    
    static let shared = NetworkManager()
    static let imageCache = NSCache<NSString, UIImage>()
    
    //MARK: Internal Properties
    
    let router = Router<PlayersApi>()
    private static var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Resources.string.dateFormat.urlDateformat
        return formatter
    }()
    
    //MARK: Public functions
    
    func getPlayers(completion: @escaping (_ players: [Player]?, _ error: LocalizedError?)->()){
        let year = getURLYear()
        router.request(.playerList(season: year)) { data, response, error in
            guard error == nil else {
                completion(nil, NetworkManagerError.networkConnectivityError)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse  (response)
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
    
    func getTeams(completion: @escaping (_ teams: [Team]?, _ error: LocalizedError?)->()) {
        let year = getURLYear()
        router.request(.teamList(season: year))  { data, response, error in
            guard error == nil else {
                completion(nil, NetworkManagerError.networkConnectivityError)
                return
            }
              
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse  (response)
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
    
    func getTeamImage(team: String, completion: @escaping (_ teamImage: TeamImage)->()){
        let abbreviation = convertTeamAbbreviation(for: team)
        router.request(.teamImage(team: abbreviation))  { data, response, error in
            let teamImage: TeamImage
            guard error == nil, let imageData = data else {
                teamImage = TeamImage(with: Resources.image.missingImage.nbaLogo, and: team)
                completion(teamImage)
                return
            }
            
            if let image = UIImage(data: imageData)  {
                teamImage = TeamImage(with: image, and: team)
            } else {
                teamImage = TeamImage(with: Resources.image.missingImage.nbaLogo, and: team)
            }
            completion(teamImage)
        }
    }
    
    func getPlayerSeasonData(playerID: String, completion: @escaping (_ data: PlayerSeasonData?, _ error: LocalizedError?)->()){
        let year = getURLYear()
        router.request(.playerCurrentSeasonData(year: year, player: playerID)) { data, response, error in
            guard error == nil else {
                completion(nil, NetworkManagerError.networkConnectivityError)
                  return
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
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
    
    func getPlayerImage(playerid: String, teamid: String, completion: @escaping (_ image: PlayerImage)->()){
        router.request(.playerImage(player: playerid))  { data, response, error in
            let playerImage: PlayerImage
            guard error == nil,
                let imageData = data,
                let image = UIImage(data: imageData) else {
                    playerImage = PlayerImage(image: Resources.image.missingImage.nbaLogo)
                completion(playerImage)
                return
            }
            playerImage = PlayerImage(image: image)
            completion(playerImage)
        }
    }

    //MARK: Private Functions
    
    private func convertTeamAbbreviation(for abbreviation: String) -> String {
        ///conversion between NBA and ESPN abbreviations
        let convertedAbbreviation: String
        switch abbreviation {
        case Resources.string.teamConversion.NOP:
            convertedAbbreviation = Resources.string.teamConversion.NO
        case Resources.string.teamConversion.UTA:
            convertedAbbreviation = Resources.string.teamConversion.UTAH
        default:
            convertedAbbreviation = abbreviation
        }
        return convertedAbbreviation
    }
    

    private func getURLYear() -> String {
        ///nba uses beginning season year in url
        ///if current date > new season start date - use current year
        ///if current date < new season start date - use last year
        let date = Date()
        var year = String(Calendar.current.component(.year, from: Date()))
        let newSeasonDateString = Resources.string.seasonStart.value + year
        if let newSeasonDate = NetworkManager.dateFormatter.date(from: newSeasonDateString),
            let yearInt = Int(year),
            date < newSeasonDate {
                year = String(yearInt - 1)
        }
        return year
    }
    
    private func handleNetworkResponse  (_ response: HTTPURLResponse) -> Result<LocalizedError>{
        switch response.statusCode {
        case 200...299: return .success(nil)
        case 401...500: return .failure(NetworkManagerError.authenticationError)
        case 501...599: return .failure(NetworkManagerError.badRequestError)
        case 600: return .failure(NetworkManagerError.outdatedRequestError)
        default: return .failure(NetworkManagerError.failedRequestError)
        }
    }
}

//MARK: Error conditions

enum NetworkManagerError: Error {
    case networkConnectivityError
    case noDataError
    case unableToDecodeError
    case authenticationError
    case badRequestError
    case outdatedRequestError
    case failedRequestError
    case encodingError
}

extension NetworkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkConnectivityError:
            return Resources.string.errorDescription.networkConnectivityError
        case .noDataError:
            return Resources.string.errorDescription.noDataError
        case .unableToDecodeError:
            return Resources.string.errorDescription.unableToDecodeError
        case .authenticationError:
            return Resources.string.errorDescription.authenticationError
        case .badRequestError:
            return Resources.string.errorDescription.badRequestError
        case .outdatedRequestError:
            return Resources.string.errorDescription.outdatedRequestError
        case .failedRequestError:
            return Resources.string.errorDescription.failedRequestError
        case .encodingError:
            return Resources.string.errorDescription.encodingError
        }
    }
}
