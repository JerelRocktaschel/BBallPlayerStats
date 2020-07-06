//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

//MARK: Typealias

typealias TeamTableViewCellPresentable = TeamImagePresentable & TeamNamePresentable

protocol TeamNamePresentable {
    var teamModel: TeamModel { get set }
}

extension TeamNamePresentable {
    func getTeamName(from teamModel: TeamModel) -> String? {
        guard let city = teamModel.city, let name = teamModel.name else {
            return nil
        }
        return city + " " + name
    }
}

struct TeamTableCellViewModel: TeamTableViewCellPresentable {
    
    //MARK: Internal Properties
    
    var teamModel: TeamModel
    
    //MARK: Init
    
    init(with teamModel: TeamModel) {
        self.teamModel = teamModel
    }
}
