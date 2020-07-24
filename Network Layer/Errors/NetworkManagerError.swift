//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

//MARK: Error conditions

enum NetworkManagerError: Error {
    case networkConnectivityError
    case noDataError
    case unableToDecodeError
    case authenticationError
    case badRequestError
    case outdatedRequestError
    case failedRequestError
    case encodingError
}

extension NetworkManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkConnectivityError:
            return Resources.string.errorDescription.networkConnectivityError
        case .noDataError:
            return Resources.string.errorDescription.noDataError
        case .unableToDecodeError:
            return Resources.string.errorDescription.unableToDecodeError
        case .authenticationError:
            return Resources.string.errorDescription.authenticationError
        case .badRequestError:
            return Resources.string.errorDescription.badRequestError
        case .outdatedRequestError:
            return Resources.string.errorDescription.outdatedRequestError
        case .failedRequestError:
            return Resources.string.errorDescription.failedRequestError
        case .encodingError:
            return Resources.string.errorDescription.encodingError
        }
    }
}
