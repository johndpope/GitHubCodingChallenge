//
//  DiffController.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import GitHub

class DiffController: UITableViewController {
    
    let cellIdentifier = "Cell"
    var pullRequest: GitHubPullRequest?
    var files = [GitHubPullRequestFile]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        view.layoutIfNeeded()
        prepareData()
    }
    
    fileprivate func prepareData() {
        
        guard let pullRequest = pullRequest else {
            return
        }
        
        GitHubClient.files(pullRequest) { (files, error) in
            guard let files = files else {
                return
            }
            self.files = files
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard !files.isEmpty else {
            return 0
        }
        return files.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let file = files[section]
        return "\(file.name) +\(file.additions) -\(file.deletions)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !files.isEmpty else {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard !files.isEmpty else {
            return cell
        }
        
        let file = files[indexPath.section]
        cell.textLabel?.text = file.patch
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}