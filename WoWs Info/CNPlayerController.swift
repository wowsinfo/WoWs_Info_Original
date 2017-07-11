//
//  CNPlayerController.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SafariServices

class CNPlayerController: UIViewController, SFSafariViewControllerDelegate {

    var playerData = [String]()
    var shipData = [[String]]()
    @IBOutlet weak var shipInfoBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var clanLabel: UILabel!
    @IBOutlet weak var battleImage: UIImageView!
    @IBOutlet weak var winrateImage: UIImageView!
    @IBOutlet weak var damageImage: UIImageView!
    @IBOutlet weak var battleLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = playerData[ChineseServer.DataIndex.id]
        // Setup labels
        setupLabels()
        
        // Get Ship Info
        getShipData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem

        if segue.identifier == "gotoCNShipDetail" {
            let destination = segue.destination as! CNShipController
            destination.shipData = self.shipData
        }
    }
    
    // MARK: Data
    func setupLabels() {
        nameLabel.text = playerData[ChineseServer.DataIndex.nickname]
        
        // Some may not have a clan or rank
        let rank = playerData[ChineseServer.DataIndex.rank]
        if rank == "0" {
            rankLabel.text = "没有参加排位赛"
        } else { rankLabel.text = rank }
        let clan = playerData[ChineseServer.DataIndex.clan]
        if clan == "" {
            clanLabel.text = "无工会"
        } else { rankLabel.text = clan }
    }
    
    // MARK: Safari
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange status bar colour back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: Button pressed
    @IBAction func kongzhongBtnPressed(_ sender: Any) {
        let wiki = SFSafariViewController(url: URL(string: playerData[ChineseServer.DataIndex.website])!)
        wiki.modalPresentationStyle = .overFullScreen
        UIApplication.shared.statusBarStyle = .default
        self.present(wiki, animated: true, completion: nil)
    }
    
    @IBAction func shipInfoBtnPressed(_ sender: Any) {
        // Internet latency issue
        if shipData.count > 0 {
            performSegue(withIdentifier: "gotoCNShipDetail", sender: shipData)
        } else {
            let message = UIAlertController.QuickMessage(title: "提示", message: "您也许选择了错误的服务器", cancel: "好的")
            self.present(message, animated: true, completion: nil)
        }
    }
    
    // MARK: Loading Ship Data
    func getShipData() {
        let shipData = ChineseServer(id: playerData[ChineseServer.DataIndex.id])
        shipData.getShipRank { (shipRank) in
            shipData.getShipInformation(rankJson: shipRank, success: { (shipInfo) in
                self.shipData = shipInfo
                DispatchQueue.main.async {
                    // Update now
                    self.loadBasicInfoWithAnimation(data: shipInfo)
                }
            })
        }
    }
    
    func loadBasicInfoWithAnimation(data: [[String]]) {
        var battle = 0.0
        var damage = 0.0
        var win = 0.0
        var frag = 0.0
        var expectedDmg = 0.0
        var expectedWins = 0.0
        var expectedFrags = 0.0
        
        for ship in data {
            let currBattle = Double(ship[ChineseServer.ShipDataIndex.battle].components(separatedBy: " ")[0])!
            battle += currBattle
            damage += Double(ship[ChineseServer.ShipDataIndex.allDamage])!
            win += Double(ship[ChineseServer.ShipDataIndex.allWin])!
            frag += Double(ship[ChineseServer.ShipDataIndex.kill])!
            
            let shipID = ship[ChineseServer.ShipDataIndex.shipID]
            expectedDmg += Double(ShipRating.shipExpected["data"][shipID]["average_damage_dealt"].doubleValue) * currBattle
            expectedWins += Double(ShipRating.shipExpected["data"][shipID]["win_rate"].doubleValue) * currBattle
            expectedFrags += Double(ShipRating.shipExpected["data"][shipID]["average_frags"].doubleValue) * currBattle
        }
        
        let rDmg = damage / expectedDmg
        let rFrags = frag / expectedFrags
        let rWins = win / expectedWins
        
        let nDmg = max(0.0, (rDmg - 0.4) / (1.0 - 0.4))
        let nFrags = max(0.0, (rFrags - 0.1) / (1.0 - 0.1))
        let nWins = max(0.0, (rWins - 0.7) / (1.0 - 0.7))
        
        let index = PersonalRating.getPersonalRatingIndex(PR: 700 * nDmg + 300 * nFrags + 150 * nWins)
        
        DispatchQueue.main.async {
            self.ratingLabel.text = PersonalRating.Comment[index]
            self.ratingLabel.textColor = PersonalRating.ColorGroup[index]
        }
        
        let allBattle = String(format: "%.0f", battle)
        let averageDamage = String(format: "%.0f", round(damage / battle))
        let averageWinrate = String(format: "%.1f", round(win / battle * 10000) / 100)  + "%"
        
        self.battleLabel.text = allBattle
        self.damageLabel.text = averageDamage
        self.winrateLabel.text = averageWinrate
        
        UIView.animate(withDuration: 0.5) { 
            self.battleImage.alpha = 1
            self.winrateImage.alpha = 1
            self.damageImage.alpha = 1
            self.battleLabel.alpha = 1
            self.winrateLabel.alpha = 1
            self.damageLabel.alpha = 1
            self.shipInfoBtn.alpha = 1
            self.ratingLabel.alpha = 1.0
        }
    }
    
}
