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
        
        cell.seasonLabel.text = "Season \(rankInfo[indexPath.row][RankInformation.RankDataIndex.season])"
        
        return cell
        
    }

}
