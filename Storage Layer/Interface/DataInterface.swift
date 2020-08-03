//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import CoreData

protocol DataInterface {
    associatedtype Entity
    
    func fetchEntity(predicate: NSPredicate?,
                     sortDescriptors: [NSSortDescriptor]?,
                     propertiesToFetch: String...) throws -> [Entity]?
    func save(context: NSManagedObjectContext) throws
    func delete(context: NSManagedObjectContext) throws
}
