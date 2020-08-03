//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

//MARK: Protocols

protocol PlayerDetailShowable {
    func showPlayerDetail(for player: PlayerModel)
}

protocol PlayersShowable {
    func showPlayers(for team: TeamModel)
}

//MARK: Typealias

typealias TeamsTableShowable = PlayerDetailShowable & PlayersShowable

final class TeamsTableViewCoordinator: NSObject {
    
    //MARK: Internal Properties
    
    let navigationController = PlayersNavigationController()
    var teamsTableViewController: TeamsTableViewController!
    var selectedTeam: TeamModel!
    weak var tabCoordinator: TabCoordinator?
    var rootViewController: UIViewController? {
        return navigationController
    }
    
    //MARK: Init
    
    init(with tabCoordinator: TabCoordinator) {
        self.tabCoordinator = tabCoordinator
        super.init()
    }
}

//MARK: Coordinator protocol

extension TeamsTableViewCoordinator: Coordinator {
    public func start() {
        let teamsDataInterface = TeamsDataService()
        teamsTableViewController = TeamsTableViewController(with: self, teamsDataInterface: teamsDataInterface)
        navigationController.pushViewController(teamsTableViewController, animated: false)
        teamsTableViewController.navigationItem.title = Resources.string.navigationTitle.teams
    }
}

//MARK: TeamsTableShowable protocol

extension TeamsTableViewCoordinator: TeamsTableShowable {
    public func showPlayers(for team: TeamModel) {
        selectedTeam = team
        let teamPlayersDataInterface = TeamPlayersDataService()
        let teamPlayersViewController = TeamPlayersTableViewController(with: self,
                                                                       teamPlayersDataInterface: teamPlayersDataInterface)
        teamPlayersViewController.navigationItem.title = selectedTeam.name
        
        if let abbreviation = self.selectedTeam.abbreviation {
            let teamForegroundColor = TeamColors.retrieveTeamColor(for: abbreviation, in: .foreground)
            navigationController.navigationBar.barTintColor = teamForegroundColor
        }
        
        navigationController.navigationBar.isTranslucent = false
        navigationController.pushViewController(teamPlayersViewController, animated: true)
    }
    
    public func showPlayerDetail(for player: PlayerModel) {
        guard let playerDetailViewModel = PlayerDetailViewModel(using: player) else {
            return
        }
        let detailViewController = PlayerDetailViewController(with: playerDetailViewModel)
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
