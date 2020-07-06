//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

class PlayerSeasonDataViewModel: NSObject {
    
    //MARK: Internal Properties
    
    var ppg = String()
    var rpg = String()
    var apg = String()
    var spg = String()
    var bpg = String()
    var seasonYear = Int()
    var setPlayerValues: (()->())?
    private let playerID: String
    
    //MARK: Init
    
    init(with playerID: String) {
        self.playerID = playerID
    }
    
    //MARK: Public functions
    
    func getData() {
        NetworkManager.shared.getPlayerSeasonData (playerID: playerID) { [unowned self] playerData, error in
            guard error == nil,
                let playerData = playerData else {
                    self.ppg = Resources.string.seasonNotAvailable.na
                    self.rpg = Resources.string.seasonNotAvailable.na
                    self.apg = Resources.string.seasonNotAvailable.na
                    self.bpg = Resources.string.seasonNotAvailable.na
                    self.spg = Resources.string.seasonNotAvailable.na
                    self.setPlayerValues?()
                    return
            }
            self.ppg = playerData.ppg.addTrailingZero()
            self.rpg = playerData.rpg.addTrailingZero()
            self.apg = playerData.apg.addTrailingZero()
            self.spg = playerData.spg.addTrailingZero()
            self.bpg = playerData.bpg.addTrailingZero()
            self.seasonYear = playerData.seasonYear
            self.setPlayerValues?()
        }
    }
}
