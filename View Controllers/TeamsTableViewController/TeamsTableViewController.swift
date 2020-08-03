//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit
import CoreData

final class TeamsTableViewController: UITableViewController {

    //MARK: Properties
    
    weak var coordinator: TeamsTableViewCoordinator?
    private let teamsDataInterface : TeamsDataInterface
    let teamsTableCellName = String.init(describing: TeamTableViewCell.self)
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = teamsDataInterface.buildTeamsFetchRequest()
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        return frc
    }()
    
    //MARK: Init
    
    init(with teamsCoordinator: TeamsTableViewCoordinator, teamsDataInterface: TeamsDataInterface) {
        self.coordinator = teamsCoordinator
        self.teamsDataInterface = teamsDataInterface
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View life cycle
    
    override func viewDidLoad() {
        registerTableViewCell()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        coordinator?.navigationController.setDefaultBarTintColor()
        
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
        let teamLogoWithDataCell = UINib(nibName: teamsTableCellName, bundle: nil)
        tableView.register(teamLogoWithDataCell, forCellReuseIdentifier: teamsTableCellName)
    }
}

//MARK: Table View data source delegate

extension TeamsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = fetchedResultsController.fetchedObjects?.count else {
            return 0
        }
        return count
     }
     
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teamsTableCellName, for: indexPath) as! TeamTableViewCell
        if let team = fetchedResultsController.object(at: indexPath) as? TeamModel {
            let teamTableCellViewModel = TeamTableCellViewModel(with: team)
            cell.configureCell(with: teamTableCellViewModel)
        }
        return cell
    }
}

//MARK: Table View delegate

extension TeamsTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let team = fetchedResultsController.object(at: indexPath) as? TeamModel else {
            return
        }
        coordinator?.showPlayers(for: team)
    }
       
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Resources.float.tableCellView.defaultHeight
    }
       
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
