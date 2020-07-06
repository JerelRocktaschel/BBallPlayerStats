//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension UIImage : NSDiscardableContent {
    
    //MARK: Public functions
    
    ///prevents image cache from clearing when app is in background
    public func beginContentAccess() -> Bool {
        return false
    }

    public func endContentAccess() {
        print("End content access")
    }

    public func discardContentIfPossible() {
        print("Discarding")
    }

    public func isContentDiscarded() -> Bool {
        return false
    }
}
