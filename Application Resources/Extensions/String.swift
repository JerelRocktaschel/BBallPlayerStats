//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension String {
    
    //MARK: Public functions
    
    ///adds a trailing zero if stat is a whole number (4 becomes 4.0)
    public func addTrailingZero() -> String {
        guard contains(".") else {
            return self + ".0"
        }
        return self
    }
}
