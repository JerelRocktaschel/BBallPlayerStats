//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation
import UIKit

struct ErrorHandler {
    
    //MARK: Shared instance
    
    static let shared = ErrorHandler()
    
    //MARK: Internal Properties
    
    private let defaultDescription = Resources.string.errorDescription.defaultDescription
    
    //MARK: Public functions
    
    func handle(_ error: LocalizedError, with presenter: UIViewController) {
        if let errorDescription = error.errorDescription {
            present(errorDescription: errorDescription, with: presenter)
        } else {
            present(errorDescription: defaultDescription, with: presenter)
        }
    }
    
    //MARK: Private functions
    
    private func present(errorDescription: String, with presenter: UIViewController) {
        let alertController = UIAlertController(
            title: Resources.string.errorAlert.title,
            message: errorDescription,
            preferredStyle: .alert
        )
        alertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default)
        )
       presenter.present(alertController, animated: true, completion: nil)
    }
}
