//
//  APIRouter.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import Alamofire

enum APIRouter {
    
    //MARK: - Requests
    case getFeed
    
    //MARK: - HttpMethod
    var method: HTTPMethod {
        switch self {
        case .getFeed:
            return .get
        }
    }

    //MARK: - Path
    var urlString: String {
        var urlComponents: URLComponents = URLComponents(string: baseURLString + relativePath)!
        urlComponents.queryItems = queryItems
        
        return urlComponents.url!.absoluteString
    }
    
    //MARK: - Body
    var body: [String:Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    //MARK: - Query Parameters
    var queryItems: [URLQueryItem] {
        switch self {
        case .getFeed:
            return [
                URLQueryItem(name: "query", value: "ios")
            ]
        }
    }
    
    //MARK: - Base URL
    var baseURLString: String {
        switch self {
        default:
            return "http://hn.algolia.com"
        }
    }
    
    //MARK: - Relative URL
    var relativePath: String {
        switch self {
        case .getFeed:
            return "/api/v1/search_by_date"
        }
    }
    
}
