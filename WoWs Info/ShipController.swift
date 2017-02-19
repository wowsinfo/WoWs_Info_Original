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
    @IBOutlet weak var filterTextField: UITextField!
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
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        
        filterTextField.resignFirstResponder()
        
        let filterText = filterTextField.text!
        
        if filterText == "" {
            // Empty
            targetShips = PlayerShip.playerShipInfo
            DispatchQueue.main.async {
                self.ShipTableView.reloadData()
            }
            return
        }
        
        // Clean it
        targetShips = [[String]]()
        
        if let tier = Int(filterText) {
            // Tier
            if tier > 0 && tier <= 10 {
                for ship in PlayerShip.playerShipInfo {
                    if Int(ship[PlayerShip.PlayerShipDataIndex.tier]) == tier {
                        targetShips.append(ship)
                    }
                }
            } else if tier > 10 {
                // Filter with battles
                for ship in PlayerShip.playerShipInfo {
                    if Int(ship[PlayerShip.PlayerShipDataIndex.battles])! >= tier {
                        targetShips.append(ship)
                    }
                }
            }
        } else {
            for ship in PlayerShip.playerShipInfo {
                switch filterText {
                case "dd":
                    if ship[PlayerShip.PlayerShipDataIndex.type] == "Destroyer" {
                        targetShips.append(ship)
                    }
                case "bb":
                    if ship[PlayerShip.PlayerShipDataIndex.type] == "Battleship" {
                        targetShips.append(ship)
                    }
                case "ca":
                    if ship[PlayerShip.PlayerShipDataIndex.type] == "Cruiser" {
                        targetShips.append(ship)
                    }
                case "cv":
                    if ship[PlayerShip.PlayerShipDataIndex.type] == "AirCarrier" {
                        targetShips.append(ship)
                    }
                default:
                    // Find ship with name
                    if ship[PlayerShip.PlayerShipDataIndex.name].lowercased().contains(filterText.lowercased()) {
                        targetShips.append(ship)
                    }
                }
            }
        }
        
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
        }
        
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
        
        let index = Int(targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.rating])!
        cell.shipRating.text = PersonalRating.Comment[index]
        cell.shipRating.textColor = PersonalRating.ColorGroup[index]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetShips.count
    }
}
