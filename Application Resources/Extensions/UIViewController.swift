//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: Internal Properties
    
    ///to display and remove network inidicator via object association
    private static let association = ObjectAssociation<UIActivityIndicatorView>()
    private var indicator: UIActivityIndicatorView {
        set { UIViewController.association[self] = newValue }
        get {
            if let indicator = UIViewController.association[self] {
                return indicator
            } else {
                  UIViewController.association[self] = UIActivityIndicatorView.customIndicator(at: view.center)
                return UIViewController.association[self]!
            }
        }
    }
    
    //MARK: Public functions

    func startIndicatingActivity() {
        DispatchQueue.main.async { [unowned self] in
            self.view.window?.addSubview(self.indicator)
            self.indicator.startAnimating()
        }
    }

    func stopIndicatingActivity() {
        DispatchQueue.main.async { [unowned self] in
            self.indicator.stopAnimating()
        }
    }
}
