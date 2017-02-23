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
        
        // Hide separator line
        RankTableView.separatorColor = UIColor.clear
        
        let rank = RankInformation(ID: PlayerAccountID.AccountID)
        rank.getRankInformation { rank in
            DispatchQueue.main.async {
                self.rankInfo = rank
                self.RankTableView.reloadData()
            }
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
        
        cell.battlesLabel.text = rankInfo[indexPath.row][RankInformation.RankDataIndex.battles]
        cell.damageLabel.text = rankInfo[indexPath.row][RankInformation.RankDataIndex.damage]
        cell.winRateLabel.text = rankInfo[indexPath.row][RankInformation.RankDataIndex.winRate]
        
        let currentRank = rankInfo[indexPath.row][RankInformation.RankDataIndex.currentRank]
        let maxRank = rankInfo[indexPath.row][RankInformation.RankDataIndex.maxRank]
        cell.rankLabel.text = currentRank + " (\(maxRank))"
        
        cell.seasonLabel.text = NSLocalizedString("SEASON", comment: "Season label") + " \(rankInfo[indexPath.row][RankInformation.RankDataIndex.season])"
        
        // Set up a border colour
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.layer.borderColor = UIColor(red: CGFloat(85)/255, green: CGFloat(163)/255, blue: CGFloat(255)/255, alpha: 1.0).cgColor
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        
        return cell
        
    }

}
