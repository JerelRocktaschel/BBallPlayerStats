//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder  {
    
    //MARK: Internal Properties
    
    private var coordinator: ApplicationCoordinator?
}

//MARK: UIApplicationDelegate Protocol

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = Resources.color.navigationBar.barTintColor
        let window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = ApplicationCoordinator(window: window)
        coordinator?.start()
        return true
    }
}
