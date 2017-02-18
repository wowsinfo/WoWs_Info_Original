//
//  ShipController.swift
//  WoWs Info
//
//  Created by Henry Quan on 17/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ShipController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ShipTableView: UITableView!
    var allShips = [[String]]()
    var targetShips = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShipTableView.delegate = self
        ShipTableView.dataSource = self
        
        PlayerShip(account: PlayerAccountID.AccountID).getPlayerShipInfo(success: { data in
            DispatchQueue.main.async {
                self.targetShips = data
                self.ShipTableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        let cell = self.ShipTableView.dequeueReusableCell(withIdentifier: "ShipCell", for: indexPath) as! ShipTableCell
        cell.battlesLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.battles]
        cell.damageLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.averageDamage]
        cell.xpLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.averageExp]
        cell.hitRatioLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.hitRatio]
        cell.killDeathLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.killDeathRatio]
        cell.winRateLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.winRate]
        
        // Setup tier name and type
        let name = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.name]
        let tier = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.tier]
        let type = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.type]
        
        cell.shipTypeImage.image = Shipinformation.getImageWithType(type: type)
        var tierName = "Tier \(tier) " + name
        if tier == "" { tierName = name }
        cell.TierNameLabel.text = tierName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetShips.count
    }
}
