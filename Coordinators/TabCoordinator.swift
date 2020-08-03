//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class TabCoordinator: NSObject {
    
    //MARK: Internal Properties
    
    let tabController: UITabBarController
    var playersCoordinator: PlayersTableViewCoordinator!
    var teamsCoordinator: TeamsTableViewCoordinator!
    lazy private(set) var playerViewModels = [PlayerViewModel]()
    lazy private(set) var teamViewModels = [TeamViewModel]()
    private let disptachGroup: DispatchGroup = DispatchGroup()
    private var processDataService = ProcessDataService()
    private var storedError: LocalizedError?
    var rootViewController: UIViewController? {
        return tabController
    }
    
    //MARK: Init
    
    init(with tabController: UITabBarController) {
        self.tabController = tabController
        super.init()
        initUI()
    }
    
    //MARK: Public functions
    
    func fetchPlayerData() {
        enableUI(false)
        self.disptachGroup.enter()
          
        if let _ = storedError {
            self.storedError = nil
        }

        initTeamViewModels()
        disptachGroup.enter()
        initPlayerViewModels()
        disptachGroup.notify(queue: .main) { [unowned self] in
            if let error = self.storedError {
                self.displayError(error)
                return
            }

            do {
                try self.processDataService.processData(playerViewModels: self.playerViewModels,
                                                       teamViewModels: self.teamViewModels)
            } catch {
                self.displayError(CoreDataError.savePlayersTeamsError)
                return
            }
           
            do {
                try self.playersCoordinator.playersTableViewController.fetchedResultsController.performFetch()
                    self.playersCoordinator.playersTableViewController.tableView.reloadData()
            } catch {
                self.displayError(CoreDataError.fetchTeamsError)
                return
            }
               
            do {
                try self.teamsCoordinator.teamsTableViewController.fetchedResultsController.performFetch()
                self.teamsCoordinator.teamsTableViewController.tableView.reloadData()
            } catch  {
                self.displayError(CoreDataError.fetchPlayersError)
                return
            }
            self.enableUI(true)
        }
    }
    
    private func displayError(_ error: LocalizedError) {
        enableUI(true)
        ErrorHandler.shared.handle(error, with: self.tabController)
    }
    
    //MARK: Init UI
    
    private func initUI() {
        tabController.tabBar.isTranslucent = false
    }
    
    //MARK: Private Functions
    
    private func initPlayerViewModels(){
        let playersService = PlayersService()
        let playerListViewModel = PlayerListViewModel(networkService: playersService)
        playerListViewModel.getData() { [unowned self] playerViewModels, error in
            if let error = error {
                self.storedError = error
            } else if let playerViewModels = playerViewModels {
                self.playerViewModels = playerViewModels
            }
            self.disptachGroup.leave()
        }
    }
    
    private func initTeamViewModels() {
        let teamsService = TeamsService()
        let teamListViewModel = TeamListViewModel(networkService: teamsService)
        teamListViewModel.getData() { [unowned self] teamViewModels, error in
            if let error = error {
                self.storedError = error
                self.disptachGroup.leave()
            } else if let teamViewModels = teamViewModels {
                self.teamViewModels = teamViewModels
                self.initTeamImageViewModels()
            }
        }
    }

    private func initTeamImageViewModels() {
        let imageCacheGroup = DispatchGroup()
        let networkService = TeamImageService()
        for teamViewModel in self.teamViewModels {
            imageCacheGroup.enter()
            let teamViewImageModel = TeamImageViewModel(with: teamViewModel.abbreviation, and: networkService)
            teamViewImageModel.getData() { teamViewImageModel in
                TeamImageCache.imageCache.setObject(teamViewImageModel.teamImage, forKey: teamViewImageModel.abbreviation as NSString)
                imageCacheGroup.leave()
            }
        }
        imageCacheGroup.notify(queue: DispatchQueue.main) {
            self.disptachGroup.leave()
        }
    }
    
    private func enableUI(_ flag: Bool) {
        if flag {
            playersCoordinator.playersTableViewController.stopIndicatingActivity()
        } else {
            playersCoordinator.playersTableViewController.startIndicatingActivity()
        }
        tabController.tabBar.isUserInteractionEnabled = flag
        playersCoordinator.playersTableViewController.tableView.isUserInteractionEnabled = flag
        playersCoordinator.playersTableViewController.navigationItem.rightBarButtonItem?.isEnabled = flag
        playersCoordinator.playersTableViewController.navigationItem.leftBarButtonItem?.isEnabled = flag
    }
}
    
//MARK: Coordinator protocol

extension TabCoordinator: Coordinator {
    func start() {
        var controllers: [UIViewController] = []
        playersCoordinator = PlayersTableViewCoordinator(with: self)
        teamsCoordinator = TeamsTableViewCoordinator(with: self)
        if let playersViewController = playersCoordinator.rootViewController,
           let teamsViewController = teamsCoordinator.rootViewController {
            playersCoordinator.start()
            playersViewController.tabBarItem  = UITabBarItem(title: Resources.string.tabName.players,
                                                             image: Resources.image.tabBar.basketball,
                                                             tag: 1)
            controllers.append(playersViewController)
            teamsCoordinator.start()
            teamsViewController.tabBarItem  = UITabBarItem(title: Resources.string.tabName.teams,
                                                           image: Resources.image.tabBar.basket,
                                                             tag: 2)
            controllers.append(teamsViewController)
            tabController.viewControllers = controllers
            fetchPlayerData()
        }
    }
}
