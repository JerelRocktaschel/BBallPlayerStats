//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

//MARK: Typealias

typealias JSONDictionary = [String:Any]

struct Player {
    
    //MARK: Internal Properties
    
    let id: String
    let firstName: String
    let lastName: String
    let teamID: String
    let jersey: String
    let position: String
    let feet: String
    let inches: String
    let pounds: String
    let dateOfBirth: String
    
    //MARK: Init
    
    init(from decoder: Decoder) throws {
        let playerContainer = try decoder.container(keyedBy: PlayerCodingKeys.self)
        id = try playerContainer.decode(String.self, forKey: .id)
        firstName = try playerContainer.decode(String.self, forKey: .firstName)
        lastName = try playerContainer.decode(String.self, forKey: .lastName)
        teamID = try playerContainer.decode(String.self, forKey: .teamId)
        jersey = try playerContainer.decode(String.self, forKey: .jersey)
        position = try playerContainer.decode(String.self, forKey: .position)
        feet = try playerContainer.decode(String.self, forKey: .feet)
        inches = try playerContainer.decode(String.self, forKey: .inches)
        pounds = try playerContainer.decode(String.self, forKey: .pounds)
        dateOfBirth = try playerContainer.decode(String.self, forKey: .dateOfBirth)
    }
}

extension Player: Decodable {
    
    //MARK: Coding Keys
    
    enum PlayerCodingKeys: String, CodingKey {
        case id = "personId"
        case firstName = "firstName"
        case lastName = "lastName"
        case jersey = "jersey"
        case position = "pos"
        case feet = "heightFeet"
        case inches = "heightInches"
        case pounds = "weightPounds"
        case dateOfBirth = "dateOfBirthUTC"
        case teamId = "teamId"
    }
}

enum PlayerJSONKeys {
    case resultsSets
    case commonallplayers
    case headers
    case rowset
}

struct PlayerApiResponse {
    
    //MARK: Internal Properties
    
    var players: [Player]
}

extension PlayerApiResponse {
    
    //MARK: Init
    
    init?(json: [String:Any]) {
        guard let leagueDictionary = json["league"] as? JSONDictionary  else {
            return nil
        }
        
        guard let standardDictionary = leagueDictionary["standard"] as? [JSONDictionary] else {
            return nil
        }
        
        self.players = [Player]()
        for playerDictionary in standardDictionary {
            guard let isActive = playerDictionary["isActive"] as? Bool else {
                return nil
            }
            
            ///inactive players exist
            guard isActive == true else {
                continue
            }
            
            guard let jsonPlayerData = try? JSONSerialization.data(withJSONObject: playerDictionary, options: []) else {
                return nil
            }
            
            do {
                let player = try JSONDecoder().decode(Player.self, from: jsonPlayerData)
                self.players.append(player)
            } catch {
                return nil
            }
        }
    }
}
