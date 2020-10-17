//
//  API.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import Alamofire

protocol ArrayInitializable {
    static func arrayInitialize(data: Any) -> Swift.Result<[ArrayInitializable], GenericFailureReason>
}

enum GenericFailureReason: Int, Error {
    case badRequest = 400
    case sessionExpired = 401
    case noRights = 403
    case notFound = 404
    case unknown = -1
    case noConnection = -1009
}

class API {
    
    static let shared = API()
    
    var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func arrayRequest<T: ArrayInitializable>(request: APIRouter, requestCompletion: @escaping (_ result: Swift.Result<[T], GenericFailureReason>) -> ()) {
        return APISessionManager.arrayRequest(request: request, requestCompletion: requestCompletion)
    }

}
