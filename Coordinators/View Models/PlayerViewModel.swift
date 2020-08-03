//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

struct PlayerViewModel {
    
    //MARK: Internal Properties
    
    let id: String
    let firstName: String
    let lastName: String
    let teamID: String
    let jersey: String
    let position: String
    let feet: String
    let inches: String
    let pounds: String
    let dateOfBirth: String
    let age: String
    private static var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Resources.string.dateFormat.dobDateFormat
        return formatter
    }()
    
    //MARK: Init

    init(with player: Player) {
        id = player.id
        let firstAndLastName = PlayerViewModel.formatFirstLastName(for: player)
        firstName = firstAndLastName.firstName
        lastName = firstAndLastName.lastName
        teamID = player.teamID
        jersey = player.jersey
        ///some players have multiple positions - display main position
        position = String(player.position.prefix(1))
        feet = player.feet
        inches = player.inches
        pounds = player.pounds
        let ageAndDOB = PlayerViewModel.calculateAgeAndFormatDOB(with: player.dateOfBirth)
        dateOfBirth = ageAndDOB.dateOfBirth
        age = ageAndDOB.age
    }

    //MARK: Private functions
    
    private static func formatFirstLastName(for player: Player) -> (firstName: String, lastName: String) {
        ///nene rule
        ///if player has one name, NBA stores it in first name
        ///move to last name for sorting
        if player.lastName.count == 0 {
            return("", player.firstName)
        } else {
            return(player.firstName, player.lastName)
        }
    }
    
    private static func calculateAgeAndFormatDOB(with dateOfBirth: String) -> (dateOfBirth: String, age: String) {
        let birthdayDate = dateFormatter.date(from: dateOfBirth)
        var formatredDateOfBirth: String
        var age: String
        if let playerBirthdayDate = birthdayDate {
            formatredDateOfBirth = format(dateOfBirth)
            age = calculateAge(for: playerBirthdayDate)
        } else {
            ///some newer players will have a blank birthday temporarily
            ///set to N/A
            formatredDateOfBirth = "N/A"
            age = "N/A"
        }
        return(formatredDateOfBirth, age)
    }
    
    private static func format(_ dateOfBirth: String) -> String {
        let year = dateOfBirth.prefix(4)
        let dayIndex = dateOfBirth.index(
            dateOfBirth.endIndex,
            offsetBy: -2
        )
        let day = dateOfBirth.suffix(from: dayIndex)
        let monthStart = dateOfBirth.index(
            dateOfBirth.startIndex,
            offsetBy: 5
        )
        let monthEnd = dateOfBirth.index(
            dateOfBirth.endIndex,
            offsetBy: -3
        )
        let monthRange = monthStart..<monthEnd
        let month = dateOfBirth[monthRange]
        let formattedDate = month + "/" + day + "/" + year
        return formattedDate
    }
    
    private static func calculateAge(for playerBirthdayDate: Date) -> String {
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year,
                                          from: playerBirthdayDate,
                                          to: now, options: []
        )
        guard let age = calcAge.year else {
            return "N/A"
        }
        return String(age)
    }
}

struct PlayerListViewModel {
    
    //MARK: Typealias
    
    typealias GetPlayerListViewModelCompletion = (_ playerViewModels: [PlayerViewModel]?, _ error: LocalizedError?)->()
    
    //MARK: Internal Properties
    
    let networkService: PlayersNetworkService
    
    //MARK: Init
    
    init(networkService: PlayersNetworkService) {
        self.networkService = networkService
    }
    
    //MARK: Public functions
    
    func getData(completion: @escaping GetPlayerListViewModelCompletion) {
      //  NetworkManager.shared.getPlayers{ players, error in
        networkService.getPlayers{ players, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
    
            guard let playersList = players else {
                completion(nil, PlayerListViewModelError.noPlayersReturned)
                return
            }

            let playerViewModels = (playersList.compactMap(PlayerViewModel.init))
            completion(playerViewModels, nil)
        }
    }
}

//MARK: Error conditions

enum PlayerListViewModelError: Error {
    case noPlayersReturned
}

extension PlayerListViewModelError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPlayersReturned:
            return Resources.string.errorDescription.noPlayersReturned
        }
    }
}


