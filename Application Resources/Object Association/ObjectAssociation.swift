//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

///this is some dark arts sh*t
///source: https://stackoverflow.com/questions/25426780/how-to-have-stored-properties-in-swift-the-same-way-i-had-on-objective-c
///also: http://blog.girappe.com/?swiftStoredProtocols/
final class ObjectAssociation<T: AnyObject> {
    
    //MARK: Internal Properties

    private let policy: objc_AssociationPolicy

    //MARK: Init
    
    ///Parameter policy: An association policy that will be used when linking objects.
    init(policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) {
        self.policy = policy
    }

    //MARK: Public subscripts
    
    ///Accesses associated object.
    ///Parameter index: An object whose associated object is to be accessed.
    subscript(index: AnyObject) -> T? {
        get { return objc_getAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque()) as! T? }
        set { objc_setAssociatedObject(index, Unmanaged.passUnretained(self).toOpaque(), newValue, policy) }
    }
}
