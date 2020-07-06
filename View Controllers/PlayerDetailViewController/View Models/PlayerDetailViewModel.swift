//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerDetailViewModel {
    
    //MARK: Internal Properties
    
    let playerModel: PlayerModel
    let id: String
    let firstName: String
    let lastName: String
    let jersey: String
    let position: String
    let dateOfBirth: String
    let abbreviation: String
    var foregroundViewColor: UIColor
    var backgroundViewColor: UIColor
    var ppg = String()
    var apg = String()
    var rpg = String()
    var spg = String()
    var bpg = String()
    var seasonYear = Int()
    let pounds: NSMutableAttributedString
    let age: NSMutableAttributedString
    let height: NSMutableAttributedString
    lazy var playerImage = UIImage()
    lazy var teamLogoImage = UIImage()
    private var playerSeasonDataViewModel: PlayerSeasonDataViewModel!
    private var playerImageViewModel: PlayerImageViewModel!
    private let playerDetailStringAttributes:  [NSAttributedString.Key : Any]
    private let playerDetailLabelStringAttributes: [NSAttributedString.Key : Any]
    private let dispatchGroup = DispatchGroup()
    var setPlayerDetails: (()->())?
   
    //MARK: Init
    
    init?(using playerModel: PlayerModel) {
        guard let id = playerModel.id,
            let firstName = playerModel.firstName,
            let lastName = playerModel.lastName,
            let jersey = playerModel.jersey,
            let position = playerModel.position,
            let dateOfBirth = playerModel.dateOfBirth,
            let pounds = playerModel.pounds,
            let age = playerModel.age,
            let feet = playerModel.feet,
            let inches = playerModel.inches,
            let abbreviation = playerModel.team?.abbreviation
        else {
            return nil
        }
        
        self.playerModel = playerModel
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.jersey = "#" + jersey + " | " + position
        self.position = position
        self.dateOfBirth = dateOfBirth
        self.abbreviation = abbreviation
        foregroundViewColor = TeamColors.retrieveTeamColor(for: abbreviation, in: .foreground)
        backgroundViewColor = TeamColors.retrieveTeamColor(for: abbreviation, in: .background)
        playerDetailStringAttributes = [NSAttributedString.Key.font: Resources.font.boldLabel, NSAttributedString.Key.foregroundColor:foregroundViewColor]
        playerDetailLabelStringAttributes = [NSAttributedString.Key.font: Resources.font.regularLabel, NSAttributedString.Key.foregroundColor:UIColor.black]
        self.pounds = NSMutableAttributedString(string: pounds, attributes:playerDetailStringAttributes)
        self.pounds.append(NSMutableAttributedString(string: Resources.string.playerDetailLabels.pounds, attributes:self.playerDetailLabelStringAttributes))
        self.age = NSMutableAttributedString(string: age, attributes:playerDetailStringAttributes)
        self.age.append(NSMutableAttributedString(string: Resources.string.playerDetailLabels.years, attributes:self.playerDetailLabelStringAttributes))
        self.height = NSMutableAttributedString(string: feet, attributes:playerDetailStringAttributes)
        self.height.append(NSMutableAttributedString(string: Resources.string.playerDetailLabels.feet, attributes:self.playerDetailLabelStringAttributes))
        self.height.append(NSMutableAttributedString(string: inches, attributes:playerDetailStringAttributes))
        self.height.append(NSMutableAttributedString(string: Resources.string.playerDetailLabels.inches, attributes:self.playerDetailLabelStringAttributes))
        teamLogoImage = (NetworkManager.imageCache.object(forKey: self.abbreviation as NSString) ?? Resources.image.tabBar.basketball)
    }
    
    //MARK: Public functions
    
    func getData() {
        dispatchGroup.enter()
        dispatchGroup.enter()
        playerSeasonDataViewModel = PlayerSeasonDataViewModel(with: self.id)
        initPlayerSeasonDataViewModel()
        
        if let playerID = playerModel.id, let teamID = playerModel.team?.id {
            playerImageViewModel = PlayerImageViewModel(with: playerID, and: teamID)
            initPlayerImageViewModel()
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            self.setPlayerDetails?()
        }
    }
    
    //MARK: Private Functions
    
    private func initPlayerSeasonDataViewModel() {
        playerSeasonDataViewModel.setPlayerValues = { [unowned self] () in
            DispatchQueue.main.async {
                self.apg = self.setStatDefault(for: self.playerSeasonDataViewModel.apg)
                self.ppg = self.setStatDefault(for: self.playerSeasonDataViewModel.ppg)
                self.rpg = self.setStatDefault(for: self.playerSeasonDataViewModel.rpg)
                self.spg = self.setStatDefault(for: self.playerSeasonDataViewModel.spg)
                self.bpg = self.setStatDefault(for: self.playerSeasonDataViewModel.bpg)
                self.seasonYear = self.playerSeasonDataViewModel.seasonYear
            }
            self.dispatchGroup.leave()
        }
        self.playerSeasonDataViewModel.getData()
    }
        
    private func initPlayerImageViewModel() {
        self.playerImageViewModel.getData() { [unowned self] playerImage in
            DispatchQueue.main.async {
                 self.playerImage = playerImage!
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func setStatDefault(for stat: String) -> String {
        ///NBA will set stats to "-1.0" if player has no stats
        return stat == "-1.0" ? "0.0" : stat
    }
}
