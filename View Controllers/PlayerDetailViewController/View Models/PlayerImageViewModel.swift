//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

class PlayerImageViewModel {
    
    //MARK: Typealias
    
    typealias GetPlayerImageViewModelCompletion = (_ playerImage: UIImage?)->()
    
    //MARK: Internal Properties
    
    lazy var playerImage: UIImage = UIImage()
    let playerID: String
    let teamID: String
    
    //MARK: Init
    
    init(with playerID: String, and teamID: String) {
        self.playerID = playerID
        self.teamID = teamID
    }
       
    //MARK: Public functions
    
    func getData(completion: @escaping GetPlayerImageViewModelCompletion) {
        NetworkManager.shared.getPlayerImage(playerid: playerID, teamid: teamID) { [unowned self] playerImage in
            self.playerImage = playerImage.image
            completion(self.playerImage)
        }
    }
}
