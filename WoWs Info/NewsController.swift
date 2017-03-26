//
//  NewsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class NewsController: UITableViewController {

    var newsData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("WEB_LOADING", comment: "Loading news")
        
        self.tableView.estimatedRowHeight = 67
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if newsData.count == 0 {
            newsData = News().getNews()
            if newsData.count > 0 {
                self.title = NSLocalizedString("NEWS", comment: "News label")
            } else {
                self.title = ">_<"
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsData.count > 0 {
            return newsData.count
        } else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        cell.dateLabel.text = newsData[indexPath.row][News.dataIndex.time]
        cell.titleLabel.numberOfLines = 0
        cell.titleLabel.sizeToFit()
        cell.titleLabel.text = newsData[indexPath.row][News.dataIndex.title]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "gotoWebView", sender: newsData[indexPath.row][News.dataIndex.link])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back button")
        navigationItem.backBarButtonItem = backItem
        
        // Go to WebView
        if segue.identifier == "gotoWebView" {
            let destination = segue.destination as! WebViewController
            destination.url = sender as! String
        }
    }

}
