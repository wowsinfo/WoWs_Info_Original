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
    var recentData = [[String]]()
    @IBOutlet weak var shipInfoBtn: UIButton!
    @IBOutlet weak var recentInfoBtn: UIButton!
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
    let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    let currPoint = PointSystem.getCurrPoint()
    var usedPoint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = playerData[ChineseServer.DataIndex.id]
        // Setup labels
        setupLabels()
        
        // Get Ship Info
        getShipData()
        
        // Setup Share Btn
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharePlayer))
        self.navigationItem.rightBarButtonItem = share
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController {
            // Remove one point
            if usedPoint > 2 { usedPoint = 2 }
            PointSystem(pointToRemove: usedPoint).removePoint()
        }
    }
    
    func sharePlayer() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Crop
        let source = screenshot.cgImage!
        let newCGImage = source.cropping(to: CGRect(x: 0, y: 128, width: source.width + 128, height: source.height))
        let playerImage = UIImage(cgImage: newCGImage!)

        // Share
        let share = UIActivityViewController(activityItems: [playerImage], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem

        if segue.identifier == "gotoCNShipDetail" {
            let destination = segue.destination as! CNShipController
            destination.shipData = self.shipData
            usedPoint += 1
        } else if segue.identifier == "gotoCNChart" {
            let destination = segue.destination as! CNChartController
            destination.recentData = self.recentData
            usedPoint += 1
        }
    }
    
    // MARK: Data
    func setupLabels() {
        nameLabel.text = playerData[ChineseServer.DataIndex.nickname]
        
        // Some may not have a clan or rank
        let rank = playerData[ChineseServer.DataIndex.rank]
        if rank == "0" {
            rankLabel.text = "无排名"
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
        let kongzhong = SFSafariViewController(url: URL(string: playerData[ChineseServer.DataIndex.website])!)
        kongzhong.modalPresentationStyle = .overFullScreen
        UIApplication.shared.statusBarStyle = .default
        self.present(kongzhong, animated: true, completion: nil)
    }
    
    @IBAction func recentInfoBtnPressed(_ sender: Any) {
        // Internet latency issue
        if recentData.count > 0 {
            if !isPro && currPoint < 1 {
                // Do not segue if it is not Pro
                let pro = UIAlertController(title: "NO_ENOUGH_POINT_TITLE".localised(), message: "NO_ENOUGH_POINT_MESSAGE".localised(), preferredStyle: .alert)
                pro.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(pro, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: "gotoCNChart", sender: recentData)
            }
        } else {
            let message = UIAlertController.QuickMessage(title: "提示", message: "没有最近数据", cancel: "好的")
            self.present(message, animated: true, completion: nil)
        }
    }
    
    @IBAction func shipInfoBtnPressed(_ sender: Any) {
        // Internet latency issue
        if shipData.count > 0 {
            if !isPro && currPoint < 1 {
                // Do not segue if it is not Pro
                let pro = UIAlertController(title: "NO_ENOUGH_POINT_TITLE".localised(), message: "NO_ENOUGH_POINT_MESSAGE".localised(), preferredStyle: .alert)
                pro.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(pro, animated: true, completion: nil)
            } else {
                performSegue(withIdentifier: "gotoCNShipDetail", sender: shipData)
            }
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
                shipData.getRecentInformation(success: { (recent) in
                    self.shipData = shipInfo
                    self.recentData = recent
                    DispatchQueue.main.async {
                        // Update now
                        self.loadBasicInfoWithAnimation(data: shipInfo)
                    }
                })
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
            self.recentInfoBtn.alpha = 1.0
        }
    }
    
}
