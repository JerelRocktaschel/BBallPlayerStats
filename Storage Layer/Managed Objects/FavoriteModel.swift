//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import CoreData

public class FavoriteModel: NSManagedObject {
    
    //MARK: Internal Properties
    
    @NSManaged public var id: String?
    @NSManaged public var player: PlayerModel?
}
