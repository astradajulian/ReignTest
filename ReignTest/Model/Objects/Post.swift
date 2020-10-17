//
//  Post.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import RealmSwift

class Post: Object {
    
    @objc dynamic var id: Int
    @objc dynamic var title: String
    @objc dynamic var author: String
    @objc dynamic var date: Date
    @objc dynamic var url: String?
    
    init(payload: [String : Any]) {
        id = payload["story_id"] as? Int ?? 0
        title = payload["story_title"] as? String ?? "No title"
        author = payload["author"] as? String ?? "Anonymous"
        url = payload["story_url"] as? String
        
        if let dateString = payload["created_at"] as? String {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

            var date = dateFormater.date(from: dateString) ?? Date()

            let offset = TimeInterval(TimeZone.current.secondsFromGMT())

            date.addTimeInterval(offset)
            
            self.date = date
        } else {
            self.date = Date()
        }
    }
    
    required init() {
        id = 0
        title = "No title"
        author = "Anonymous"
        url = nil
        date = Date()
    }
}

class DeletedPost: Object {
    @objc dynamic var id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    required init() {
        id = 0
    }
}

extension Post: ArrayInitializable {
    
    static func arrayInitialize(data: Any) -> Swift.Result<[ArrayInitializable], GenericFailureReason> {
        guard let payload = data as? [String : Any] else { return .failure(.unknown) }
        
        guard let hits = payload["hits"] as? [[String : Any]] else { return .failure(.badRequest)}
        
        let posts = hits.map { (hitPayload) -> Post in
            return Post(payload: hitPayload)
        }
        
        let realm = try? Realm()
        
        realm?.beginWrite()
        if let alreadyCached = realm?.objects(Post.self) {
            realm?.delete(alreadyCached)
        }
        realm?.add(posts)
        try? realm?.commitWrite()
        
        return .success(posts)
    }
    
}
