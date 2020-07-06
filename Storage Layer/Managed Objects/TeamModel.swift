//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import CoreData

public class TeamModel: NSManagedObject {
    
    //MARK: Internal Properties
    
    @NSManaged public var id: String?
    @NSManaged public var city: String?
    @NSManaged public var name: String?
    @NSManaged public var abbreviation: String?
    @NSManaged public var player: NSSet?
}
