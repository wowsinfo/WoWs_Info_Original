//
//  RankController.swift
//  WoWs Info
//
//  Created by Henry Quan on 16/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class RankController: UITableViewController {
    
    @IBOutlet var RankTableView: UITableView!
    var rankInfo = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RankTableView.delegate = self
        RankTableView.dataSource = self
        self.title = "WEB_LOADING".localised()
        
        // Hide separator line
        RankTableView.separatorColor = UIColor.clear
        
        self.rankInfo = RankInformation.RankData
        // Remove message and reload data
        if self.rankInfo.count > 0 {
            self.title = ""
            self.RankTableView.reloadData()
        } else {
            self.title = ">_<"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rankInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.RankTableView.dequeueReusableCell(withIdentifier: "RankCell", for: indexPath) as! RankTableCell
        let theme = Theme.getCurrTheme()
        
        cell.battlesLabel.text = rankInfo[indexPath.row][RankInformation.RankDataIndex.battles]
        cell.battlesLabel.textColor = theme
        cell.winRateLabel.text = rankInfo[indexPath.row][RankInformation.RankDataIndex.winRate]
        cell.winRateLabel.textColor = theme
        
        let currentRank = rankInfo[indexPath.row][RankInformation.RankDataIndex.currentRank]
        let maxRank = rankInfo[indexPath.row][RankInformation.RankDataIndex.maxRank]
        cell.rankLabel.text = currentRank + " (\(maxRank))"
        cell.rankLabel.textColor = theme
        
        cell.seasonLabel.text = NSLocalizedString("SEASON", comment: "Season label") + " \(rankInfo[indexPath.row][RankInformation.RankDataIndex.season])"
        
        // Set up a border colour
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderColor = theme.cgColor
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        
        return cell
        
    }

}
