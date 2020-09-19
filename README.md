# BBallPlayerStats

This GitHub page will serve as both the product page for the BBall Players Stats App as well as provide technical information about how the app was built.

## Product Information

iPhone app that retrieves all current players from the NBA, sorts players alphabetically by last name and by team and displays a player detail view.

Each player stats detail view presents a pic of the player, jersey and position, demographics and season statistics. Select the favorite button to tag your favorite players and selecting the star button on the players list will show only your favorite players.

I built this app for a few reasons. I love the NBA and have been a fan for over three decades. I wanted to increase my Swift knowledge and I learn quicker when working on a real project as opposed to book learning. 

I do have a few additional feature ideas for this app and may end up implementing those in a subsequent release.

## Privacy Policy

The BBall Players Stats App collects no personal information at all. Zip. Nada.
 
[![Available on the App Store](http://cl.ly/WouG/Download_on_the_App_Store_Badge_US-UK_135x40.svg)](https://apps.apple.com/app/id1522364788)

## What is under the hood

* 100% Swift
* MVVM+C mostly - a little MVP as well
* Simple network layer using Decodable for JSON processing
* Dispatch Queues for handling simultaneous API calls
* NBA API calls for player and team data and a call to ESPN for NBA logos
* Core Data storage layer 
* NSFetchedResultsController
* UIResultSearchController
* NSAttributedString
* Image Caching
* Auto Layout in Xib and code
* Centralized error handling
* Object Association
* Resources enum defines resources utilized throughout app
* Zero dependencies

## Data Flow Diagram

![Data Flow Diagram](https://i.imgur.com/QRFFBkH.png)

1. The App Delegate initializes the App Coordinator.
2. The App Coordinator initializes the Tab Coorindator.
3. The Tab Coordinator performs the following:   
    - Initializes PlayerViewModels that makes request to the NBA API for player data.
     - PlayerViewModel data saved in Core Data.
    - Initializes TeamViewModels that makes request to the NBA API for team data.
     - TeamViewModel data saved in Core Data.
     - TeamViewModels initializes TeamImageViewModels that makes request to ESPN logo page and saves to png to image cache.
    - Initializes PlayerTableViewController that fetches PlayerModel data from Core Data and Team images from the Image Cache.
    - Initializes TeamTableViewController that fetches TeamModel data from Core Data and Team images from the Image Cache.
4. Selecting a player row in the PlayersTableViewController performs the following:
    - Initializes PlayerDetailViewModel by passing in the selected PlayerModel.
     - PlayerDetailViewModel makes request to NBA API for player stats data and initializes  PlayerImageViewModel.
     - PlayerDetailViewModel makes request to NBA API for player image and initializes PlayerSeasonViewModel.
    - Initializes PlayerDetailViewController with PlayerDetailsViewModel, PlayerSeasonViewModel and PlayerImageViewModel.
5. Selecting a team row in the TeamsTableViewController performs the following:    
    - Initializes TeamPlayersTableViewController with selected TeamModel.
     - TeamPlayersTableViewController performs fetch of player data for team from Core Data.
6. Selecting a player row in the TeamPlayersTableViewController performs the following: 
    - Initializes PlayerDetailViewModel by passing in the selected PlayerModel.
     - PlayerDetailViewModel makes request to NBA API for player stats data and initializes  PlayerImageViewModel.
     - PlayerDetailViewModel makes request to NBA API for player image and initializes PlayerSeasonViewModel.
    - Initializes PlayerDetailViewController with PlayerDetailsViewModel, PlayerSeasonViewModel and PlayerImageViewModel.
7. Selecting the Favorite button on the PlayerDetailViewController performs the following:
    - Saves the favorite stats to the FavoriteModel entity.
    - FetchedResultsControllers on PlayersTableViewController and TeamPlayersTableViewController refresh the player data to display the updated favorite status.
    
## Notes

* I grab team images from ESPN because the NBA uses .svg image files and I didn't want to add a library for image conversion. If this were a real project and I didn't have that flexibility, I certainly would have added a library to my project. I prefer as few dependencies as possible.
* A refresh of the NBA Player data will truncate the PlayerModel and TeamModel entities. This performs the following:
    - Ensures updated rosters are presented to the user.
    - Ensures up to date stats are presented to the user.
* FavoriteModel is not truncated with a refresh. If a player is not active, the player will not show in the app. If the player becomes active again, the player will show and present an accurate favorite status. The NBA ID used for the player does not change.
* The View Models are responsible for the each of their respective network calls. No network calls exist in the View Controllers.
* Coordinators are used for navigation within the app. No segue logic exists in the View Controllers.
* Both the network and storage layers are accessed via abstractions using the Adapter pattern.
* I am pretty happy with the number of lines in each of the View Controllers. The PlayersTableViewController has the most lines at 270 and the rest come in at 87, 106, and 131.
