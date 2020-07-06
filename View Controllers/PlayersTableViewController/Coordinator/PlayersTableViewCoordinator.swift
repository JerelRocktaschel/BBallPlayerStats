//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayersTableViewCoordinator: NSObject {
    
    //MARK: Internal Properties
    
    let navigationController = PlayersNavigationController()
    var playersTableViewController: PlayersTableViewController!
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

extension PlayersTableViewCoordinator: Coordinator {
    func start() {
        playersTableViewController = PlayersTableViewController(with: self)
        playersTableViewController.navigationItem.title = Resources.string.navigationTitle.players
        navigationController.pushViewController(self.playersTableViewController, animated: false)
    }
}

//MARK: PlayerDetailShowable protocol

extension PlayersTableViewCoordinator: PlayerDetailShowable {
    func showPlayerDetail(for player: PlayerModel) {
        guard let playerDetailViewModel = PlayerDetailViewModel(using: player) else {
            //error
            return
        }
  
        if let abbreviation = player.team?.abbreviation {
            let teamForegroundColor = TeamColors.retrieveTeamColor(for: abbreviation, in: .foreground)
            navigationController.navigationBar.barTintColor = teamForegroundColor
        }
        
        let detailViewController = PlayerDetailViewController(with: playerDetailViewModel)
        navigationController.navigationBar.isTranslucent = false
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
