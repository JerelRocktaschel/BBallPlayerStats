//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation

//MARK: Typealias

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
}

public enum HTTPMethod : String {
    case get = "GET"
}

enum PlayersApi {
    case playerList(season:String)
    case teamList(season:String)
    case teamImage(team:String)
    case playerImage(player:String)
    case playerCurrentSeasonData(year: String, player:String)
}

extension PlayersApi: EndPointType {
    
    //MARK: Internal Properties
    
    var environmentBaseURL : String {
        switch self {
        case .playerList: return Resources.string.baseURL.playerList
        case .teamList: return Resources.string.baseURL.teamList
        case .teamImage: return Resources.string.baseURL.teamImage
        case .playerImage: return Resources.string.baseURL.playerImage
        case .playerCurrentSeasonData: return Resources.string.baseURL.playerCurrentSeasonData
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else {
            fatalError("Base URL could not be configured.")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .playerList(let season):
            return season + Resources.string.path.playerList
        case .teamList(let season):
            return season + Resources.string.path.teamList
        case .teamImage(let team):
            return team + Resources.string.path.teamImage
        case .playerImage(let player):
            return player + Resources.string.path.playerImage
        case .playerCurrentSeasonData(let year, let player):
            return year + Resources.string.path.playerCurrentSeasonData + player +
                Resources.string.path.playerCurrentSeasonJson
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .playerList:
            return .request
        case .teamList:
            return .request
        case .teamImage:
            return .request
        case .playerImage:
            return .request
        case .playerCurrentSeasonData:
            return .request
        }
    }
}
