//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

//MARK: Protocol

protocol PlayerImageNetworkService {
    func getPlayerImage(playerid: String, teamid: String, completion: @escaping (_ image: PlayerImage)->())
}

struct PlayerImageService {
}

//MARK: PlayerImageNetworkService

extension PlayerImageService : PlayerImageNetworkService {
    func getPlayerImage(playerid: String, teamid: String, completion: @escaping (_ image: PlayerImage)->()){
        let router = Router<PlayersApi>()
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
}
