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
    let networkService: PlayerImageService
    
    //MARK: Init
    
    init(with playerID: String, and teamID: String, networkService: PlayerImageService) {
        self.playerID = playerID
        self.teamID = teamID
        self.networkService = networkService
    }
       
    //MARK: Public functions
    
    func getData(completion: @escaping GetPlayerImageViewModelCompletion) {
        networkService.getPlayerImage(playerid: playerID, teamid: teamID) { [unowned self] playerImage in
        //NetworkManager.shared.getPlayerImage(playerid: playerID, teamid: teamID) { [unowned self] playerImage in
            self.playerImage = playerImage.image
            completion(self.playerImage)
        }
    }
}
