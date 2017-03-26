//
//  ShipController.swift
//  WoWs Info
//
//  Created by Henry Quan on 17/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ShipController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ShipTableView: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    var targetShips = [[String]]()
    let tierSymbol = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ShipTableView.delegate = self
        ShipTableView.dataSource = self
        ShipTableView.separatorColor = UIColor.clear
        
        filterTextField.delegate = self
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        PlayerShip(account: PlayerAccount.AccountID).getPlayerShipInfo(success: { data in
            DispatchQueue.main.async {
                self.targetShips = data
                self.ShipTableView.reloadData()
                
                self.loadingIndicator.isHidden = true
                self.loadingView.isHidden = true
                
                self.tabBarController?.tabBar.isUserInteractionEnabled = true
            }
        })
        
        // Get recent info
        RecentData(account: PlayerAccount.AccountID).getRecentData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func screenshotPressed(_ sender: UITapGestureRecognizer) {
        print("Hello")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Remove keyboard
        print("Return")
        self.view.endEditing(true)
        // Filter ship
        filterShip()
        // If ther are 4 rows, we have to scroll it to top
        if targetShips.count > 3 {
            DispatchQueue.main.async {
                self.ShipTableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
        
        return true
        
    }
    
    // In order to make it clean and tidy
    func filterShip() {
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "gotoShipDetail" {
            let destination = segue.destination as! ShipScreenshotController
            destination.battle = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.battles]
            destination.winrate = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.winRate]
            destination.damage = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.averageDamage]
            destination.killdeathRatio = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.killDeathRatio]
            destination.xp = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.averageExp]
            destination.hitratio = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.hitRatio]
            
            destination.ratingIndex = Int(targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.rating])!
            destination.shipName = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.name]
        }
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoShipDetail", sender: indexPath.row)
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
        let tierName = NSLocalizedString("TIER", comment: "Tier label") + " \(tierSymbol[Int(tier)! - 1]) " + name
        cell.TierNameLabel.text = tierName
        
        let index = Int(targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.rating])!
        cell.shipRating.text = PersonalRating.Comment[index]
        cell.shipRating.textColor = PersonalRating.ColorGroup[index]
        
        // Set up a border colour
        cell.contentView.layer.borderWidth = 1
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        cell.contentView.layer.borderColor = UIColor(red: CGFloat(85)/255, green: CGFloat(163)/255, blue: CGFloat(255)/255, alpha: 1.0).cgColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetShips.count
    }
}
