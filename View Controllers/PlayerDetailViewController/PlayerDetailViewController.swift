//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerDetailViewController: UIViewController {
    
    //MARK: Internal Properties
    
    private var playerDetailViewModel: PlayerDetailViewModel
    private let controllerStackView = UIStackView()
    private var playerTeamImageStackView: PlayerTeamImageStackView!
    private var playerNameAndFavoriteDetailView: PlayerNameAndFavoriteView!
    private var playerStatisticsView: PlayerPersonalStatisticsView!
    private var playerSeasonStatisticsView: PlayerSeasonStatisticsView!
    
    //MARK: Init
    
    init(with playerDetailViewModel: PlayerDetailViewModel) {
        self.playerDetailViewModel = playerDetailViewModel
        super.init(nibName: nil, bundle: nil)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Init UI
    
    private func initUI() {
        view.backgroundColor = .white
        controllerStackView.axis = .vertical
        controllerStackView.distribution = .fillEqually
        controllerStackView.translatesAutoresizingMaskIntoConstraints = false
        controllerStackView.spacing = 0
        self.view.addSubview(controllerStackView)
        let guide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            controllerStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 0.0),
            controllerStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 0.0),
            controllerStackView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 0.0),
            controllerStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 0.0)
        ])
        
        playerTeamImageStackView = PlayerTeamImageStackView(with: self.playerDetailViewModel)
        controllerStackView.insertArrangedSubview(playerTeamImageStackView,
                                               at: Resources.int.detailViewController.playerTeamImageIndex)
        
        playerNameAndFavoriteDetailView = PlayerNameAndFavoriteView(with: self.playerDetailViewModel)
        controllerStackView.insertArrangedSubview(playerNameAndFavoriteDetailView,
                                               at: Resources.int.detailViewController.playerNameAndFavoriteDetailIndex)
        playerNameAndFavoriteDetailView.handle = { [unowned self](error) in
                ErrorHandler.shared.handle(error, with: self)
        }
        
        playerStatisticsView = PlayerPersonalStatisticsView(with: self.playerDetailViewModel)
        controllerStackView.insertArrangedSubview(playerStatisticsView,
                                               at: Resources.int.detailViewController.playerStatisticsIndex)
        
        playerSeasonStatisticsView = PlayerSeasonStatisticsView(with: self.playerDetailViewModel)
        controllerStackView.insertArrangedSubview(playerSeasonStatisticsView,
                                               at: Resources.int.detailViewController.playerSeasonStatisticsIndex)
        initPlayerDetailViewModel()
    }
    
    //MARK: Private Functions
    
    private func initPlayerDetailViewModel() {
        self.startIndicatingActivity()
        self.playerDetailViewModel.setPlayerDetails = { [unowned self] () in
            DispatchQueue.main.async {
                self.playerTeamImageStackView.playerDetailViewModel = self.playerDetailViewModel
                self.playerTeamImageStackView.setPlayerImage()
                self.playerSeasonStatisticsView.playerDetailViewModel = self.playerDetailViewModel
                self.playerSeasonStatisticsView.setStatValues()
                self.stopIndicatingActivity()
            }
        }
        self.playerDetailViewModel.getData()
    }
 
    //MARK: View Controller functions

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
