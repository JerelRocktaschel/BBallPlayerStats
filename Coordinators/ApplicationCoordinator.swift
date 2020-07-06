//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

//MARK: Protocols

protocol Coordinator: class {
    func start ()
}

final class ApplicationCoordinator {
    
    //MARK: Internal properties
    
    private let window: UIWindow
    private let tabCoordinator: TabCoordinator
    
    //MARK: Init
    
    init(window: UIWindow) {
        self.window = window
        let tabController = UITabBarController()
        tabCoordinator = TabCoordinator(with: tabController)
    }
}

//MARK: Coordinator protocol

extension ApplicationCoordinator: Coordinator {
    func start() {
        tabCoordinator.start()
        window.rootViewController = tabCoordinator.tabController
        window.makeKeyAndVisible()
    }
}
