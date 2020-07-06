//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    
    //MARK: Public functions
    
    static func customIndicator(at center: CGPoint) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: Resources.float.activityIndicatorView.width,
                height: Resources.float.activityIndicatorView.height
            )
        )
        indicator.layer.cornerRadius = Resources.float.activityIndicatorView.cornerRadius
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.style = .large
        indicator.color = Resources.color.activityIndicatorView.color
        indicator.backgroundColor = Resources.color.activityIndicatorView.backgroundColor
        return indicator
    }
}
