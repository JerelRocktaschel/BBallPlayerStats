//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit
import CoreData

final class PlayersTableViewController: UITableViewController {
    
    //MARK: Properties
    
    weak var coordinator: PlayersTableViewCoordinator?
    private let playersDataInterface : PlayersDataInterface
    private let defaultTableSeparatorColor = Resources.color.PlayerTableViewCell.defaultColor
    private var hideTableIndex: Bool = false
    private let teamLogoWithDataCellName = String.init(describing: PlayerTableViewCell.self)
    private lazy var resultSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.searchBar.sizeToFit()
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.tintColor = Resources.color.searchBar.tint
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: Resources.string.searchBar.textFieldPlaceholder, attributes: [NSAttributedString.Key.foregroundColor: Resources.color.searchBar.textAttributedFieldForeground])
        navigationItem.hidesSearchBarWhenScrolling = false
        controller.searchBar.searchBarStyle = UISearchBar.Style.minimal
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = convertToNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: Resources.color.searchBar.textDefaultFieldForeground])
        self.definesPresentationContext = true
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = playersDataInterface.buildPlayersFetchRequest()
        let managedObjectContext = CoreDataManager.shared.managedObjectContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: managedObjectContext,
                                             sectionNameKeyPath: Resources.string.frc.players.keyPath,
                                             cacheName: Resources.string.frc.players.cacheName)
        frc.delegate = self
        return frc
    }()
    
    private lazy var favoriteButton: UIButton = { [unowned self] in
        let button = UIButton()
        button.setImage(Resources.image.playersTableView.unfavoritedStar, for: .normal)
        button.setImage(Resources.image.playersTableView.favoritedStar, for: .selected)
        button.addTarget(self, action: #selector(selectFavoriteButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var noResultsLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: Resources.float.noResultsLabel.width,
                                          height: Resources.float.noResultsLabel.height))
        label.textAlignment = .center
        label.text = Resources.string.searchBar.noPlayersFound
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    //MARK: Init
    
    init(with playersCoordinator: PlayersTableViewCoordinator, playersDataInterface: PlayersDataInterface) {
        self.coordinator = playersCoordinator
        self.playersDataInterface = playersDataInterface
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Init UI
    
    private func initUI() {
        ///after entering search text and selecting one of the search results
        ///navigating back would place first rows of table view under search bar
        ///https://www.hackingwithswift.com/forums/ios/uitableview-scroll-position-wonky-when-combined-with-a-uisearchcontroller-and-uinavigationbar/475
        extendedLayoutIncludesOpaqueBars = true
        ///prevents last row from going behind tab bar
        ///https://stackoverflow.com/questions/20884381/tableview-showing-behind-tab-bar
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0,
                                                               left: 0,
                                                               bottom: (coordinator?.tabCoordinator?.tabController.tabBar.frame.height)!,
                                                               right: 0)
        tableView.contentInset = adjustForTabbarInsets
        tableView.scrollIndicatorInsets = adjustForTabbarInsets
        setNeedsStatusBarAppearanceUpdate()
        navigationItem.searchController = resultSearchController
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                           target: self,
                                                           action: #selector(refreshPlayerData))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
    
    //MARK: Private Functions
    
    private func registerTableViewCell() {
        let teamLogoWithDataCell = UINib(nibName: teamLogoWithDataCellName, bundle: nil)
        tableView.register(teamLogoWithDataCell, forCellReuseIdentifier: teamLogoWithDataCellName)
     }

    private func fetchData() {
        do {
            try fetchedResultsController.performFetch()
            tableView.reloadData()
        } catch  {
            ErrorHandler.shared.handle(CoreDataError.fetchPlayersError, with: self)
        }
    }
    
    private func setCustomPredicate() {
        let searchText = self.resultSearchController.searchBar.text!
        if !favoriteButton.isSelected && searchText.count == 0 {
            hideTableIndex = false
            NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: Resources.string.frc.players.cacheName)
            fetchedResultsController.fetchRequest.predicate = NSPredicate(value: true)
            fetchData()
            return
        }
     
        var subpredicates = [NSPredicate]()
        hideTableIndex = true
        if favoriteButton.isSelected {
            let favoritePredicate = NSPredicate(format: Resources.string.predicate.players.favorite)
            subpredicates.append(favoritePredicate)
        }
        
        if searchText.count > 0 {
            //search for text string in first or last name
            let firstNamePredicate = NSPredicate(format: Resources.string.predicate.players.firstName, searchText)
            let lastNamePredicate = NSPredicate(format: Resources.string.predicate.players.lastName, searchText)
            let searchPredicateCompound = NSCompoundPredicate.init(type: .or,
                                                                   subpredicates: [lastNamePredicate,firstNamePredicate])
            subpredicates.append(searchPredicateCompound)
        }
        
        NSFetchedResultsController<NSFetchRequestResult>.deleteCache(withName: Resources.string.frc.players.cacheName)
        let predicateCompound = NSCompoundPredicate.init(type: .and, subpredicates:subpredicates)
        fetchedResultsController.fetchRequest.predicate = predicateCompound
        fetchData()
    }
    
    private func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
    
    @objc private func refreshPlayerData() {
        coordinator?.tabCoordinator?.fetchPlayerData()
    }
    
    //MARK: View lifecycle
       
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCell()
        initUI()
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
    
    //MARK: IBActions
    
    @objc func selectFavoriteButton(_ button: UIButton) {
        favoriteButton.isSelected = !favoriteButton.isSelected
        setCustomPredicate()
    }
}

//MARK: UISearchResultsUpdating Delegate

extension PlayersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        setCustomPredicate()
    }
}

//MARK:  Table View Delegate

extension PlayersTableViewController {
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

//MARK:  Table View Data Source Delegate

extension PlayersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let count = self.fetchedResultsController.sections?.count {
            return count
        } else {
            return 1
        }
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let fetchedCount = self.fetchedResultsController.fetchedObjects?.count {
            if fetchedCount == 0 {
                tableView.backgroundView = noResultsLabel
                tableView.separatorColor = .clear
            } else {
                tableView.backgroundView = nil
                tableView.separatorColor = defaultTableSeparatorColor
            }
        }
        
        if self.hideTableIndex {
            return nil
        }
        return fetchedResultsController.sectionIndexTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return fetchedResultsController.section(forSectionIndexTitle: title, at: index)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: teamLogoWithDataCellName, for: indexPath) as! PlayerTableViewCell
        if let player = fetchedResultsController.object(at: indexPath) as? PlayerModel {
            let playerCellViewDataModel = PlayerTableCellViewModel(with: player)
            cell.configureCell(with: playerCellViewDataModel)
        }
        return cell
    }
}

//MARK: NSFetchedResultsController Delegate

extension PlayersTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
         self.fetchData()
    }
}
