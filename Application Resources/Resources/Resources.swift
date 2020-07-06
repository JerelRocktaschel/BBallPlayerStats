//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

public enum Resources {
    
    public enum string {
        public enum navigationTitle {
            public static var players: String { return "Players" }
            public static var teams: String { return "Teams" }
        }
               
        public enum tabName {
            public static var players: String { return "Players" }
            public static var teams: String { return "Teams" }
        }
               
        public enum searchBar {
            public static var textFieldPlaceholder: String { return "Search for Players" }
            public static var noPlayersFound: String { return "No Players Found" }
        }
        
        public enum dateFormat {
            ///player dob format from NBA
            public static var dobDateFormat: String { return "YYYY-MM-dd" }
            ///used to compare date on API to current date - determines season year
            public static var urlDateformat: String { return "MM/dd/yyyy" }
        }
        
        ///new season supposed to start on 12/1 - may change
        public enum seasonStart {
            public static var value: String { return "12/01/" }
        }
        
        ///default stats text if player stats not available
        public enum seasonNotAvailable {
               public static var na: String { return "N/A" }
        }
        
        ///default title text if player stats not available
        enum statsNotAvailable {
            public static var na: String {"STATS ARE UNAVAILABLE"}
        }
        
        public enum playerDetailLabels {
            public static var pounds: String { return " lbs" }
            public static var years: String { return " yrs" }
            public static var feet: String { return " ft " }
            public static var inches: String { return " in" }
        }
        
        public enum playerStatsLabel {
            public static var heightCategory: String { return "Height" }
            public static var weightCategory: String { return "Weight" }
            public static var dateOfBirthCategory: String { return "Date of Birth" }
            public static var ageCategory: String { return "Age" }
            public static var ppgCategory: String { return "PPG" }
            public static var apgCategory: String { return "APG" }
            public static var rpgCategory: String { return "RPG" }
            public static var spgCategory: String { return "SPG" }
            public static var bpgCategory: String { return "BPG" }
        }
        
        ///used to convert team abbreviations between NBA and ESPN
        public enum teamConversion {
            public static var UTAH: String { return "UTAH" }
            public static var UTA: String { return "UTA" }
            public static var NO: String { return "NO" }
            public static var NOP: String { return "NOP" }
        }
        
        public enum coreData {
            public static var bundleResource: String { return "Player" }
            public static var storeName: String { return "PlayerStore.sqlite" }
        }
        
        public enum entityName: String {
            case PlayerModel
            case TeamModel
            case FavoriteModel
        }
        
        public enum predicate {
            public enum teamPlayers {
                public static var format: String { return "team.id CONTAINS[c] %@" }
            }
            
            public enum players {
                public static var favorite: String { return "( favorite != nil )" }
                public static var firstName: String { return "( firstName CONTAINS[c] %@ )" }
                public static var lastName: String { return "( lastName CONTAINS[c] %@ )" }
            }
        }
        
        public enum sortDescriptors {
            public enum teamPlayers {
                public static var lastName: String { return "lastName" }
                public static var firstName: String { return "firstName" }
            }
            
            public enum teams {
                public static var city: String { return "city" }
            }
            
            public enum players {
                public static var lastName: String { return "lastName" }
                public static var firstName: String { return "firstName" }
            }
        }
        
        public enum frc {
            public enum players {
                public static var cacheName: String { return "Root" }
                public static var keyPath: String { return "lastName" }
            }
        }
        
        public enum baseURL {
            public static var playerList: String { return "https://data.nba.net/data/5s/prod/v2/" }
            public static var teamList: String { return "https://data.nba.net/data/5s/prod/v2/" }
            public static var teamImage: String { return "https://a.espncdn.com/i/teamlogos/nba/500/" }
            public static var playerImage: String { return "https://ak-static.cms.nba.com/wp-content/uploads/headshots/nba/latest/260x190/" }
            public static var playerCurrentSeasonData: String { return "https://data.nba.com/prod/v1/" }
        }
        
        public enum path {
            public static var playerList: String { return "/players.json" }
            public static var teamList: String { return "/teams.json" }
            public static var teamImage: String { return ".png" }
            public static var playerImage: String { return ".png" }
            public static var playerCurrentSeasonData: String { return "/players/" }
            public static var playerCurrentSeasonJson: String { return "_profile.json" }
        }
        
        public enum errorAlert {
            public static var title: String { return "TECHNICAL FOUL!" }
        }
        
        public enum errorDescription {
            public static var defaultDescription: String { return "Something went wrong. Please try again." }
            public static var saveFavorite: String { return "An error occurred while selecting the favorite button. Please try again." }
            public static var savePlayersTeamsError: String { return "An error occurred while saving players and teams. Please try again." }
            public static var fetchTeamsError: String { return "An error occurred while fetching teams. Please try again." }
            public static var fetchPlayersError: String { return "An error occurred while fetching players. Please try again." }
            public static var networkConnectivityError: String { return "The network is currently unavailable. Please try again when connectivity is established." }
            public static var noDataError: String { return "No player data was returned. Please try again." }
            public static var unableToDecodeError: String { return "The source data could not be decoded. Please try again." }
            public static var authenticationError: String { return "An authentication error occurred. Please try again." }
            public static var badRequestError: String { return "A bad request was made. Please try again." }
            public static var outdatedRequestError: String { return "The request is outdated. Please try again." }
            public static var failedRequestError: String { return "The request failed. Please try again." }
            public static var noPlayersReturned: String { return "No players were returned from the request. Please try again." }
            public static var noTeamsReturned: String { return "No teams were returned from the request. Please try again." }
            public static var encodingError: String { return "The encoding failed with this request. Please try again." }
        }
    }
    
    public enum font {
        public static var boldLabel: UIFont { return UIFont(name:"Helvetica-Bold", size: 22.0)! }
        public static var regularLabel: UIFont { return UIFont(name:"Helvetica", size: 17.0)! }
        public static var jerseyPositionLabel: UIFont { return UIFont(name: "Helvetica", size: 37.0)! }
        public static var lastNameLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 43)! }
        public static var firstNameLabel: UIFont { return UIFont(name: "Helvetica", size: 40)! }
        public static var heightCategoryLabel: UIFont { return UIFont(name: "Helvetica-Oblique", size: 20)! }
        public static var weightCategoryLabel: UIFont { return UIFont(name: "Helvetica-Oblique", size: 20)! }
        public static var dateOfBirthCategoryLabel: UIFont { return UIFont(name: "Helvetica-Oblique", size: 20)! }
        public static var dateOfBirthValueLabel: UIFont { return UIFont(name:"Helvetica-Bold", size: 22.0)! }
        public static var ageCategoryLabel: UIFont { return UIFont(name: "Helvetica-Oblique", size: 20)! }
        public static var seasonValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 16)! }
        public static var ppgCategoryLabel: UIFont { return UIFont(name: "Helvetica", size: 22)! }
        public static var rpgCategoryLabel: UIFont { return UIFont(name: "Helvetica", size: 22)! }
        public static var apgCategoryLabel: UIFont { return UIFont(name: "Helvetica", size: 22)! }
        public static var spgCategoryLabel: UIFont { return UIFont(name: "Helvetica", size: 22)! }
        public static var bpgCategoryLabel: UIFont { return UIFont(name: "Helvetica", size: 22)! }
        public static var ppgValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 22)! }
        public static var rpgValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 22)! }
        public static var apgValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 22)! }
        public static var spgValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 22)! }
        public static var bpgValueLabel: UIFont { return UIFont(name: "Helvetica-Bold", size: 22)! }
    }
    
    public enum double {
        //url timeout
        public static var timeoutInterval: Double { return 10.0 }
    }
    
    public enum float {
        public enum activityIndicatorView {
            public static var height: CGFloat { return 100 }
            public static var width: CGFloat { return 100 }
            public static var cornerRadius: CGFloat { return 10 }
        }
        
        public enum navigationBar {
            public static var titleFontSize: CGFloat { return 20 }
        }
        
        public enum playerTeamImageStackView {
            public static var jerseyStackViewSpacing: CGFloat { return 10 }
        }
        
        public enum spacerView {
            //aligns team logo
            public static var width: CGFloat { return 20 }
        }
        
        public enum teamLogoView {
            public static var heightAnchor: CGFloat { return 0.6 }
        }
        
        public enum logoJerseyPositionStackView {
            public static var widthAnchor: CGFloat { return 0.35 }
        }
        
        public enum lastNameLabel {
            public static var minimumScaleFactor: CGFloat { return 0.5 }
            public static var centerYMultiplier: CGFloat { return 1.3 }
            public static var leadingAnchorConstant: CGFloat { return 10.0 }
            public static var trailingAnchorConstant: CGFloat { return -10.0 }
        }
        
        public enum firstNameLabel {
            public static var minimumScaleFactor: CGFloat { return 0.5 }
            public static var centerYMultiplier: CGFloat { return 0.7 }
        }
        
        public enum favoriteButton {
            public static var topAnchorConstant: CGFloat { return 10.0 }
            public static var trailingAnchorConstant: CGFloat { return -10.0 }
        }
        
        public enum categoryLabel {
            public static var leadingAnchorConstant: CGFloat { return 20.0 }
        }
        
        public enum heightCategoryLabel {
            public static var centerYMultiplier: CGFloat { return 0.25 }
        }
        
        public enum weightCategoryLabel {
            public static var centerYMultiplier: CGFloat { return 0.75 }
        }
        
        public enum dateOfBirthCategoryLabel {
            public static var centerYMultiplier: CGFloat { return 1.25 }
        }
        
        public enum ageCategoryLabel {
            public static var centerYMultiplier: CGFloat { return 1.75 }
        }
        
        public enum lineView {
            public static var alpha: CGFloat { return 0.5 }
            public static var leadingAnchorConstant: CGFloat { return -15.0 }
            public static var trailingAnchorConstant: CGFloat { return 15.0 }
        }
        
        public enum valueLabel {
            public static var trailingAnchorConstant: CGFloat { return -20.0 }
        }
        
        public enum seasonValueLabel {
            public static var topAnchorConstant: CGFloat { return 15.0 }
        }
        
        public enum seasonStatsCategoryLabel {
            public static var centerYMultiplier: CGFloat { return 0.5 }
        }
        
        public enum seasonStatsValueLabel {
            public static var centerYMultiplier: CGFloat { return 1.5 }
        }
        
        public enum seasonStatsCenterLineView {
            public static var heightAnchorMultiplier: CGFloat { return 0.5 }
        }
        
        public enum seasonStatsRightBorderView {
             public static var widthAnchorConstant: CGFloat { return 0.5 }
             public static var centerYMultiplier: CGFloat { return 2.0 }
        }
        
        public enum seasonStatsCategoryView {
            public static var leadingAnchorConstant: CGFloat { return 20.0 }
            public static var topAnchorConstant: CGFloat { return 45.0 }
            public static var bottomAnchorConstant: CGFloat { return -20.0 }
        }
        
        public enum bpgCategoryView {
            public static var trailingAnchorConstant: CGFloat { return -20.0 }
        }
        
        public enum noResultsLabel {
            public static var width: CGFloat { return 200 }
            public static var height: CGFloat { return 50 }
        }
        
        public enum tableCellView {
            public static var defaultHeight: CGFloat { return 44.0 }
        }
    }
    
    public enum color {
        public enum navigationBar {
            public static var barTintColor: UIColor { return UIColor(red:0.09, green:0.25, blue:0.55, alpha:1.0) }
            public static var tintColor: UIColor { return UIColor.white }
            public static var titleTextColor: UIColor { return UIColor.white }
        }
        
        public enum searchBar {
            public static var tint: UIColor { return UIColor.white }
            public static var textAttributedFieldForeground: UIColor { return UIColor.lightGray }
            public static var textDefaultFieldForeground: UIColor { return UIColor.white }
        }
        
        public enum activityIndicatorView {
            public static var backgroundColor: UIColor { return UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5) }
            public static var color: UIColor { return UIColor.white }
        }
        
        public enum PlayerTableViewCell {
            public static var defaultColor: UIColor { return UITableView().separatorColor! }
        }
    }
    
    public enum image {
        public enum favoriteButton {
            public static var favoritedStar: UIImage { return UIImage(named:"FavoritedStar")! }
            public static var unfavoritedStar: UIImage { return UIImage(named:"UnfavoritedStar")! }
        }
        
        public enum playersTableView {
            public static var favoritedStar: UIImage { return UIImage(named:"NavFavoritedStar")! }
            public static var unfavoritedStar: UIImage { return UIImage(named:"NavUnfavoritedStar")! }
            
        }
        
        public enum tabBar {
            public static var basketball: UIImage { return UIImage(named:"Basketball")! }
            public static var basket: UIImage { return UIImage(named:"Basket")! }
        }

        public enum missingImage {
            public static var nbaLogo: UIImage { return UIImage(named:"NBALogo")! }
        }
    }
    
    public enum int {
        public enum detailViewController {
            ///WARNING - indexes should be in the range 0-3
            ///0 is the top view on the detail screen - 3 is the bottom
            public static var playerTeamImageIndex: Int { return 0 }
            public static var playerNameAndFavoriteDetailIndex: Int { return 1 }
            public static var playerStatisticsIndex: Int { return 2 }
            public static var playerSeasonStatisticsIndex: Int { return 3 }
        }
    }
}
