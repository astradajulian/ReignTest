//
//  ViewController.swift
//  ReignTest
//
//  Created by Julian Astrada on 17/10/2020.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl = UIRefreshControl()
    
    let viewModel = FeedViewModel()
    
    var posts: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        
        tableView.register(UINib(nibName: PostTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshContent()
    }
    
    @objc func refreshContent() {
        viewModel.getFeed(completion: {[weak self] result in
            self?.refreshControl.endRefreshing()
            
            switch result {
            case .success(let posts):
                self?.posts = posts
                
                if let deletedPosts = self?.viewModel.getDeletedPosts() {
                    for deletedPost in deletedPosts {
                        self?.posts = self?.posts.filter({ (post) -> Bool in
                            return post.id != deletedPost.id
                        }) ?? posts
                    }
                }
                
                self?.tableView.reloadData()
            case .failure(_):
                break
            }
        })
    }

}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier) as? PostTableViewCell else { return UITableViewCell() }
        
        cell.setupCell(post: posts[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell, let urlString = cell.post.url, let url = URL(string: urlString) else { return }
        
        present(SFSafariViewController(url: url), animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let postToDelete = posts[indexPath.row]
            
            viewModel.deletePost(id: postToDelete.id)
            
            posts.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

