//
//  PostTableViewCell.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var post: Post!
    
    func setupCell(post: Post) {
        self.post = post
        
        titleLabel.text = post.title
        
        authorLabel.text = post.author
        
        dateLabel.text = ageDescription(postDate: post.date)
    }
    
    private func ageDescription(postDate: Date) -> String? {
        guard postDate < Date() else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd"
            
            return dateFormatter.string(from: postDate)
        }
        
        let postingAgeDateComponents = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: postDate, to: Date())
        
        let postingAge: String
        
        if let day = postingAgeDateComponents.day, day > 10 {
            postingAge = NSLocalizedString("10d+ ago", comment: "posting more than 10 days ago")
        } else if let day = postingAgeDateComponents.day, day > 2 {
            let formatted = NSLocalizedString("%dd ago",comment: "posting x days ago")
            
            postingAge = String(format: formatted, day)
        } else if let day = postingAgeDateComponents.day, day == 1 {
            postingAge = NSLocalizedString("Yesterday", comment: "Yesterday")
        } else if let hour = postingAgeDateComponents.hour, hour >= 1 {
            let formatted = NSLocalizedString("%dh ago",comment: "posting x hours ago")
            
            postingAge = String(format: formatted, hour)
        } else if let minutes = postingAgeDateComponents.minute, minutes >= 1 {
            let formatted = NSLocalizedString("%dm ago",comment: "posting x minutes ago")
            
            postingAge = String(format: formatted, minutes)
        } else if let seconds = postingAgeDateComponents.second, seconds >= 1 {
            let formatted = NSLocalizedString("%ds ago",comment: "posting x seconds ago")
            
            postingAge = String(format: formatted, seconds)
        } else {
            postingAge = NSLocalizedString("Now", comment: "Now")
        }
        
        return postingAge
    }
    
}
