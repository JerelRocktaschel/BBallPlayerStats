//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

//MARK: Typealias

typealias PlayerTableViewCellPresentable = PlayerNamePresentable & TeamImagePresentable & FavoriteImagePresentable

//MARK: Protocols

protocol TeamImagePresentable {
    var teamModel: TeamModel { get set }
}

extension TeamImagePresentable {
    func getTeamLogoImage(from teamModel: TeamModel) -> UIImage? {
        var teamImage = UIImage()
        if let abbreviationNS = teamModel.abbreviation {
            if let image = TeamImageCache.imageCache.object(forKey: abbreviationNS as NSString) {
                teamImage = image
            }
        } else {
            teamImage = Resources.image.tabBar.basketball
        }
        return teamImage
    }
}

protocol PlayerNamePresentable {
    var playerModel: PlayerModel { get set }
}

extension PlayerNamePresentable {
    func getPlayerName(from playerModel: PlayerModel) -> String  {
        if let firstName = playerModel.firstName {
             return playerModel.lastName! + ", " + firstName
        } else {
             return playerModel.lastName!
        }
    }
}

protocol FavoriteImagePresentable {
}

extension FavoriteImagePresentable {
    func getFavoriteImage(from playerModel: PlayerModel) -> UIImage? {
        if let _ = playerModel.favorite?.player {
            return Resources.image.favoriteButton.favoritedStar
        } else {
            return nil
        }
    }
}

struct PlayerTableCellViewModel: PlayerTableViewCellPresentable {
    
    //MARK: Internal Properties
    
    var playerModel: PlayerModel
    var teamModel: TeamModel

    //MARK: Init
    
    init(with playerModel: PlayerModel) {
        self.playerModel = playerModel
        self.teamModel = self.playerModel.team!
    }
}
