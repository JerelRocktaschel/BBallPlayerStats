//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    //MARK: Internal Properties
    
    ///for setting status bar for vc embedded in nav controller
    ///https://stackoverflow.com/questions/47837959/updating-the-status-bar-style-between-view-controllers/47838649#47838649
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}
