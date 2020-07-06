//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

struct PlayerSeasonData {
    
    //MARK: Internal Properties
    
    let ppg: String
    let rpg: String
    let apg: String
    let spg: String
    let bpg: String
    let seasonYear: Int
    
    //MARK: Init
    
    init(from decoder: Decoder) throws {
        let playerSeasonDataContainer = try decoder.container(keyedBy: PlayerCodingKeys.self)
        ppg = try playerSeasonDataContainer.decode(String.self, forKey: .ppg)
        rpg = try playerSeasonDataContainer.decode(String.self, forKey: .rpg)
        apg = try playerSeasonDataContainer.decode(String.self, forKey: .apg)
        spg = try playerSeasonDataContainer.decode(String.self, forKey: .spg)
        bpg = try playerSeasonDataContainer.decode(String.self, forKey: .bpg)
        seasonYear = try playerSeasonDataContainer.decode(Int.self, forKey: .seasonYear)
    }
}

extension PlayerSeasonData: Decodable {
    
    //MARK: Coding Keys
    
    enum PlayerCodingKeys: String, CodingKey {
        case ppg = "ppg"
        case rpg = "rpg"
        case apg = "apg"
        case spg = "spg"
        case bpg = "bpg"
        case seasonYear = "seasonYear"
    }
}

struct PlayerSeasonDataApiResponse {
    
    //MARK: Internal Properties
    
    var playerSeasonData: PlayerSeasonData
}

extension PlayerSeasonDataApiResponse {
    
    //MARK: Init
    
    init?(json: [String:Any]) {
        guard let leagueDictionary = json["league"] as? JSONDictionary  else {
            return nil
        }
        
        guard let standardDictionary = leagueDictionary["standard"] as? JSONDictionary else {
            return nil
        }
        
        guard let statsDictionary = standardDictionary["stats"] as? JSONDictionary else {
            return nil
        }
        
        guard let latestDictionary = statsDictionary["latest"] as? JSONDictionary else {
            return nil
        }
        
        guard let jsonPlayerData = try? JSONSerialization.data(withJSONObject: latestDictionary, options: []) else {
            return nil
        }
            
        do {
            let playerSeasonData = try JSONDecoder().decode(PlayerSeasonData.self, from: jsonPlayerData)
            self.playerSeasonData = playerSeasonData
        } catch {
            return nil
        }
    }
}
