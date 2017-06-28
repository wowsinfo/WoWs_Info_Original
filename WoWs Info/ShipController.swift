//
//  ShipController.swift
//  WoWs Info
//
//  Created by Henry Quan on 17/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import AudioToolbox

class ShipController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var shipCountLabel: UILabel!
    @IBOutlet weak var avgRatingLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ShipTableView: UITableView!
    @IBOutlet weak var filterTextField: UITextField!
    var targetShips = [[String]]()
    let tierSymbol = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update theme colour
        self.tabBarController?.tabBar.tintColor = Theme.getCurrTheme()
        
        // Setup tableview
        ShipTableView.delegate = self
        ShipTableView.dataSource = self
        ShipTableView.separatorColor = UIColor.clear
        
        filterTextField.delegate = self
        
        // Get recent info
        RecentData(account: PlayerAccount.AccountID).getRecentData()
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
        
        DispatchQueue.main.async {
            self.targetShips = PlayerShip.playerShipInfo
            self.ShipTableView.reloadData()
            self.loadingIndicator.isHidden = true
            self.loadingView.isHidden = true
            self.calAvgShipRating()
            
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                // Find ship with name
                if ship[PlayerShip.PlayerShipDataIndex.name].lowercased().contains(filterText.lowercased()) {
                    targetShips.append(ship)
                }
            }
        }
        
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
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
            
            destination.ratingIndex = Int(targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.rating].components(separatedBy: "|")[1])!
            destination.shipName = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.name]
            destination.shipID = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.id]
            destination.shipType = targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.type]
            print(targetShips[sender as! Int][PlayerShip.PlayerShipDataIndex.id])
        }
        
    }
    
    func calAvgShipRating() {
        
        var actualDmg = 0.0
        var actualWins = 0.0
        var actualFrags = 0.0
        
        var expectedDmg = 0.0
        var expectedWins = 0.0
        var expectedFrags = 0.0
        
        var rating = 0.0
        
        for ship in targetShips {
            actualDmg += Double(ship[PlayerShip.PlayerShipDataIndex.totalDamage])!
            actualWins += Double(ship[PlayerShip.PlayerShipDataIndex.totalWins])!
            actualFrags += Double(ship[PlayerShip.PlayerShipDataIndex.totalFrags])!
            
            expectedDmg += Double(ShipRating.shipExpected["data"][ship[PlayerShip.PlayerShipDataIndex.id]]["average_damage_dealt"].doubleValue) * Double(ship[PlayerShip.PlayerShipDataIndex.battles])!
            expectedWins += Double(ShipRating.shipExpected["data"][ship[PlayerShip.PlayerShipDataIndex.id]]["win_rate"].doubleValue) * Double(ship[PlayerShip.PlayerShipDataIndex.battles])! / 100
            expectedFrags += Double(ShipRating.shipExpected["data"][ship[PlayerShip.PlayerShipDataIndex.id]]["average_frags"].doubleValue) * Double(ship[PlayerShip.PlayerShipDataIndex.battles])!
        }
        
        print(actualDmg,expectedDmg,"\n",actualWins,expectedWins,"\n", actualFrags,expectedFrags)
        
        let rDmg = actualDmg / expectedDmg
        let rFrags = actualFrags / expectedFrags
        let rWins = actualWins / expectedWins
        
        let nDmg = max(0.0, (rDmg - 0.4) / (1.0 - 0.4))
        let nFrags = max(0.0, (rFrags - 0.1) / (1.0 - 0.1))
        let nWins = max(0.0, (rWins - 0.7) / (1.0 - 0.7))
        
        rating = 700 * nDmg + 300 * nFrags + 150 * nWins
        print("Rating: \(rating)")
        
        let index = PersonalRating.getPersonalRatingIndex(PR: rating)
        avgRatingLabel.text = PersonalRating.Comment[index]
        avgRatingLabel.textColor = PersonalRating.ColorGroup[index]
        
        shipCountLabel.text = "\(targetShips.count)"
    }
    
    // MARK: Btn Pressed
    @IBAction func sortBtnPressed(_ sender: Any) {
        let sortOption = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        sortOption.addAction(UIAlertAction(title: "SORT_BY_BATTLE".localised(), style: .default, handler: { _ in
            // Sort by battle
            let battle = PlayerShip.PlayerShipDataIndex.battles
            self.targetShips.sort(by: {Int($0[battle])! > Int($1[battle])!})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        sortOption.addAction(UIAlertAction(title: "SORT_BY_WINRATE".localised(), style: .default, handler: { _ in
            // Sort by win rate
            let winrate = PlayerShip.PlayerShipDataIndex.winRate
            self.targetShips.sort(by: {(Double($0[winrate].replacingOccurrences(of: "%", with: ""))! > Double($1[winrate].replacingOccurrences(of: "%", with: ""))!)})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        sortOption.addAction(UIAlertAction(title: "SORT_BY_EXP".localised(), style: .default, handler: { _ in
            // Sort by exp
            let exp = PlayerShip.PlayerShipDataIndex.averageExp
            self.targetShips.sort(by: {Int($0[exp])! > Int($1[exp])!})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        sortOption.addAction(UIAlertAction(title: "SORT_BY_DAMAGE".localised(), style: .default, handler: { _ in
            // Sort by damage
            let damage = PlayerShip.PlayerShipDataIndex.averageDamage
            self.targetShips.sort(by: {Int($0[damage])! > Int($1[damage])!})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        sortOption.addAction(UIAlertAction(title: "SORT_BY_KILLDEATH".localised(), style: .default, handler: { _ in
            // Sort by kill death ratio
            let killdeath = PlayerShip.PlayerShipDataIndex.killDeathRatio
            self.targetShips.sort(by: {(Double($0[killdeath].replacingOccurrences(of: "%", with: ""))! > Double($1[killdeath].replacingOccurrences(of: "%", with: ""))!)})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        sortOption.addAction(UIAlertAction(title: "SORT_BY_HITRATIO".localised(), style: .default, handler: { _ in
            // Sort by hit ratio
            let hitRatio = PlayerShip.PlayerShipDataIndex.hitRatio
            self.targetShips.sort(by: {(Double($0[hitRatio].replacingOccurrences(of: "%", with: ""))! > Double($1[hitRatio].replacingOccurrences(of: "%", with: ""))!)})
            // Reload data
            self.ShipTableView.reloadData()
        }))
        // Cancel button
        sortOption.addAction(UIAlertAction(title: "SHARE_CANCEL".localised(), style: .cancel, handler: nil))
        self.present(sortOption, animated: true)
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func ddBtnPressed(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        // Clean it
        targetShips = [[String]]()
        for ship in PlayerShip.playerShipInfo {
            if ship[PlayerShip.PlayerShipDataIndex.type] == "Destroyer" {
                targetShips.append(ship)
            }
        }
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
        }
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        // Empty
        targetShips = PlayerShip.playerShipInfo
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
        }
        
        filterTextField.text = ""
        filterTextField.becomeFirstResponder()
    }
    
    @IBAction func caBtnPressed(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        // Clean it
        targetShips = [[String]]()
        for ship in PlayerShip.playerShipInfo {
            if ship[PlayerShip.PlayerShipDataIndex.type] == "Cruiser" {
                targetShips.append(ship)
            }
        }
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
        }
    }
    
    @IBAction func bbBtnPressed(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        // Clean it
        targetShips = [[String]]()
        for ship in PlayerShip.playerShipInfo {
            if ship[PlayerShip.PlayerShipDataIndex.type] == "Battleship" {
                targetShips.append(ship)
            }
        }
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
        }
    }
    
    @IBAction func cvBtnPressed(_ sender: Any) {
        AudioServicesPlaySystemSound(1520)
        // Clean it
        targetShips = [[String]]()
        for ship in PlayerShip.playerShipInfo {
            if ship[PlayerShip.PlayerShipDataIndex.type] == "AirCarrier" {
                targetShips.append(ship)
            }
        }
        // Update table now
        DispatchQueue.main.async {
            self.ShipTableView.reloadData()
            self.calAvgShipRating()
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoShipDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(indexPath.row)
        let cell = self.ShipTableView.dequeueReusableCell(withIdentifier: "ShipCell", for: indexPath) as! ShipTableCell
        cell.battlesLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.battles]
        cell.battlesLabel.textColor = Theme.getCurrTheme()
        cell.damageLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.averageDamage]
        cell.damageLabel.textColor = Theme.getCurrTheme()
        cell.winRateLabel.text = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.winRate]
        cell.winRateLabel.textColor = Theme.getCurrTheme()
        
        // Setup tier name and type
        let name = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.name]
        let tier = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.tier]
        let type = targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.type]
        
        cell.shipTypeImage.image = Shipinformation.getImageWithType(type: type)
        let tierName = NSLocalizedString("TIER", comment: "Tier label") + " \(tierSymbol[Int(tier)! - 1]) " + name
        cell.TierNameLabel.text = tierName
        
        let index = Int(targetShips[indexPath.row][PlayerShip.PlayerShipDataIndex.rating].components(separatedBy: "|")[1])!
        
        // Set up a border colour
        cell.contentView.layer.borderWidth = 1.25
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        cell.contentView.layer.borderColor = PersonalRating.ColorGroup[index].cgColor
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targetShips.count
    }
    
}
