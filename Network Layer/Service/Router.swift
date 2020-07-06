//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import Foundation

//MARK: Typealias

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

//MARK: Protocols

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

final class Router<EndPoint: EndPointType> {
    
    //MARK: Internal Properties
    
    private var task: URLSessionTask?
    
    //MARK: Private Functions
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: Resources.double.timeoutInterval)
        request.httpMethod = route.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

//MARK: Network Router Protocol

extension Router: NetworkRouter {
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
