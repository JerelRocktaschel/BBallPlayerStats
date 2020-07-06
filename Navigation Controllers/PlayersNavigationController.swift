//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayersNavigationController: UINavigationController {

    //MARK: Init UI
    
    private func initUI() {
        navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize:Resources.float.navigationBar.titleFontSize),
            NSAttributedString.Key.foregroundColor : Resources.color.navigationBar.titleTextColor]
        setDefaultBarTintColor()
        navigationBar.tintColor = Resources.color.navigationBar.tintColor
        navigationController?.navigationBar.isTranslucent = false
    }
    
    //MARK: Public functions
    
    func setDefaultBarTintColor() {
        navigationBar.barTintColor = Resources.color.navigationBar.barTintColor
    }
    
    //MARK: View Controller functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
}
