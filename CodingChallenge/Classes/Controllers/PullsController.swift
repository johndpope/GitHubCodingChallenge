//
//  PullsController.swift
//  CodingChallenge
//
//  Created by Kevin McKee on 10/11/17.
//  Copyright © 2017 Procore. All rights reserved.
//

import GitHub

class PullsController: UITableViewController {
    
    let cellIdentifier = "Cell"
    var repo: GitHubRepo?
    var pulls = [GitHubPullRequest]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard !pulls.isEmpty else {
            return
        }
        
        if let controller = segue.destination as? DiffController,
            let selectedIndexPath = tableView.indexPathForSelectedRow {
            controller.pullRequest = pulls[selectedIndexPath.row]
        }
    }

    fileprivate func prepareData() {
        
        guard let repo = repo else {
            return
        }
        
        GitHubClient.pulls(repo) { (pulls, error) in
            guard let pulls = pulls else {
                return
            }
            self.pulls = pulls
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        guard !pulls.isEmpty else {
            return 0
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !pulls.isEmpty else {
            return 0
        }
        return pulls.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        guard !pulls.isEmpty else {
            return cell
        }
        
        let pr = pulls[indexPath.row]
        cell.textLabel?.text = pr.title
        cell.detailTextLabel?.text = pr.diffUrl
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

