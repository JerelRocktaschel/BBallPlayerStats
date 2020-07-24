//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

struct NetworkResponseHandler {
    static func handleNetworkResponse (_ response: HTTPURLResponse) -> Result<LocalizedError>{
        switch response.statusCode {
        case 200...299: return .success(nil)
        case 401...500: return .failure(NetworkManagerError.authenticationError)
        case 501...599: return .failure(NetworkManagerError.badRequestError)
        case 600: return .failure(NetworkManagerError.outdatedRequestError)
        default: return .failure(NetworkManagerError.failedRequestError)
        }
    }
}
