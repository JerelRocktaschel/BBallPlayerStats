//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import CoreData

public class PlayerModel: NSManagedObject {
    
    //MARK: Internal Properties
    
    @NSManaged public var id: String?
    @NSManaged public var age: String?
    @NSManaged public var firstName: String?
    @NSManaged public var teamID: String?
    @NSManaged public var lastName: String?
    @NSManaged public var jersey: String?
    @NSManaged public var position: String?
    @NSManaged public var feet: String?
    @NSManaged public var inches: String?
    @NSManaged public var pounds: String?
    @NSManaged public var dateOfBirth: String?
    @NSManaged public var favorite: FavoriteModel?
    @NSManaged public var team: TeamModel?
}
