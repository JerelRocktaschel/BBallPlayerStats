//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit
import CoreData

final class TeamPlayersTableViewController: UITableViewController {
    
    //MARK: Internal Properties
    
    weak var coordinator: TeamsTableViewCoordinator?
    private let teamPlayersDataInterface : TeamPlayersDataInterface
    private let playerTableViewCellName = String.init(describing: PlayerTableViewCell.self)
    lazy private var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        let fetchRequest = teamPlayersDataInterface.buildTeamPlayersFetchRequest(teamId: coordinator?.selectedTeam.id ?? "")
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    //MARK: Init
    
    init(with teamsTableViewCoordinator: TeamsTableViewCoordinator, teamPlayersDataInterface: TeamPlayersDataInterface ) {
        self.coordinator = teamsTableViewCoordinator
        self.teamPlayersDataInterface = teamPlayersDataInterface
        super.init(nibName: nil, bundle: nil)
        fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        registerTableViewCell()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let selectedIndexes = tableView.indexPathsForSelectedRows {
            for selectedIndex in selectedIndexes {
                tableView.deselectRow(at: selectedIndex, animated: true)
            }
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
   //MARK: Private Functions
    
    private func registerTableViewCell() {
        let playersCell = UINib(nibName: playerTableViewCellName, bundle: nil)
          tableView.register(playersCell, forCellReuseIdentifier: playerTableViewCellName)
    }
    
    private func fetchData() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch  {
            ErrorHandler.shared.handle(CoreDataError.fetchTeamsError, with: self)
        }
    }
}

// MARK: - Table view data source delegate

extension TeamPlayersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = fetchedResultsController.fetchedObjects?.count else {
            return 0
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: playerTableViewCellName, for: indexPath) as! PlayerTableViewCell
        
        if let player = fetchedResultsController.object(at: indexPath) as? PlayerModel {
            let playerCellViewDataModel = PlayerTableCellViewModel(with: player)
            cell.configureCell(with: playerCellViewDataModel)
        }
           return cell
       }
}

//MARK: Table View Delegate

extension TeamPlayersTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return Resources.float.tableCellView.defaultHeight
      }
      
      override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
          return UITableView.automaticDimension
      }
          
      override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          guard let player = fetchedResultsController.object(at: indexPath) as? PlayerModel else {
              return
          }
          coordinator?.showPlayerDetail(for: player)
      }
}

//MARK: FetchedResultsController Delegate

extension TeamPlayersTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         fetchData()
    }
}
