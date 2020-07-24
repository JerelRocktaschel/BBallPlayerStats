//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

class TeamImageViewModel {
    
    //MARK: Typealias
    
    typealias GetTeamImageViewModelCompletion = (_ teamImageViewModel: TeamImageViewModel)->()
    
    //MARK: Internal Properties
    
    let networkService: TeamImageNetworkService
    lazy var teamImage: UIImage = UIImage()
    let abbreviation: String
    
    //MARK: Init
    
    init(with abbreviation: String, and networkService: TeamImageNetworkService) {
        ///differences between NBA and ESPN for team abbreviations
        let convertedAbbreviation: String
        switch abbreviation {
        case Resources.string.teamConversion.UTAH:
            convertedAbbreviation = Resources.string.teamConversion.UTA
        case Resources.string.teamConversion.NO:
            convertedAbbreviation = Resources.string.teamConversion.NOP
        default:
            convertedAbbreviation = abbreviation
        }
        self.abbreviation = convertedAbbreviation
        self.networkService = networkService
    }
    
    //MARK: Public functions
    
    func getData(completion: @escaping GetTeamImageViewModelCompletion) {
        networkService.getTeamImage(team: abbreviation) { teamImage in
        //NetworkManager.shared.getTeamImage(team: abbreviation) { teamImage in
            self.teamImage = teamImage.image
            completion(self)
        }
    }
}
