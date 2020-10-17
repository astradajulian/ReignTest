//
//  FeedViewModel.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import RealmSwift

class FeedViewModel {
    
    /// Get the posts, checks in Database if there is no internet connection
    func getFeed(completion: @escaping (_ result: Result<[Post], GenericFailureReason>) -> Void) {
        if API.shared.isConnectedToInternet {
            API.shared.arrayRequest(request: .getFeed, requestCompletion: completion)
        } else {
            let realm = try? Realm()
            
            let postsCached = realm?.objects(Post.self).sorted(by: { (post1, post2) -> Bool in
                return post1.date > post2.date
            })
            
            switch postsCached {
            case .some(let results):
                completion(.success(Array(results)))
            default:
                completion(.failure(.noConnection))
            }
        }
    }
    
    /// Saves the deleted ID in the Database
    func deletePost(id: Int) {
        let post = DeletedPost(id: id)
        
        let realm = try? Realm()
        realm?.beginWrite()
        realm?.add(post)
        try? realm?.commitWrite()
    }
    
    /// Gets all the deleted ID in the Database
    func getDeletedPosts() -> [DeletedPost] {
        let realm = try? Realm()
        
        if let deletedPosts = realm?.objects(DeletedPost.self) {
            return Array(deletedPosts)
        } else {
            return []
        }
    }

}
