//
//  APISessionManager.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import Alamofire

class APISessionManager {
    
    static func arrayRequest<T: ArrayInitializable> (request: APIRouter, requestCompletion: @escaping (_ result: Result<[T], GenericFailureReason>) -> ()) {
        AF.request(request.urlString, method: request.method).responseJSON { response in
            switch response.result {
            case .success(let data):
                let initializationResult = T.arrayInitialize(data: data)
                
                switch initializationResult {
                case let .success(object):
                    if let objects = object as? [T] {
                        requestCompletion(.success(objects))
                    } else {
                        requestCompletion(.failure(.unknown))
                    }
                case let .failure(failureReason):
                    requestCompletion(.failure(failureReason))
                }
            case .failure(_):
                requestCompletion(.failure(.unknown))
            }
        }
    }

}
