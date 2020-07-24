//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

//MARK: Image Cache

struct TeamImageCache {
    static let imageCache = NSCache<NSString, UIImage>()
}

//MARK: Protocol

protocol TeamImageNetworkService {
    func getTeamImage(team: String, completion: @escaping (_ teamImage: TeamImage)->())
}

struct TeamImageService {
    
    //MARK: Helper 
    
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
}

//MARK: TeamImageNetworkService

extension TeamImageService : TeamImageNetworkService {
    func getTeamImage(team: String, completion: @escaping (_ teamImage: TeamImage)->()){
        let abbreviation = convertTeamAbbreviation(for: team)
        let router = Router<PlayersApi>()
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
}
