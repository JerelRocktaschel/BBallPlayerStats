//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension UIStackView {
    
    //MARK: Public functions
    
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
