//
//  AdvancedInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 12/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class AdvancedInfoController: UIViewController {

    var playerInfo = [String]()
    var serverIndex = 0
    var hasGotoMoreInfo = false
    var hasVisitNumber = false
    @IBOutlet weak var number: UIImageView!
    @IBOutlet weak var moreInfo: UIImageView!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var levelAndPlaytimeLabel: UILabel!
    @IBOutlet weak var totalBattlesLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var averageExpLabel: UILabel!
    @IBOutlet weak var averageDamageLabel: UILabel!
    @IBOutlet weak var killDeathRatioLabel: UILabel!
    @IBOutlet weak var mainBatteryHitRatioLabel: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet weak var personalRatingLabel: UILabel!
    @IBOutlet var statView: UIView!
    
    let username = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
    
    @IBOutlet weak var setPlayerIDBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load player id into title
        self.title  = playerInfo[1]
        playerNameLabel.text = playerInfo[0]
        
        // Pass account id
        _ = PlayerAccount.init(ID: self.title!, Name: playerInfo[0])
        
        self.loadPlayerData()
        
        // Just to prevent user playing with that button...
        if username.range(of: playerInfo[1]) != nil {
            setPlayerIDBtn.isEnabled = false
        }
        
        // Move stat to center... To look better
        centerConstraint.constant = (view.bounds.size.height - 406) / 4
        
        // Get server index
        self.serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPlayerData() {

        PlayerStat().getDataFromAPI(account: playerInfo[1], success: {playerData in
            self.setLabelText(data: playerData)
        })
        
    }
    
    @IBAction func gotoMoreInfo(_ sender: UITapGestureRecognizer) {
        
        moreInfo.isHidden = true
        
        performSegue(withIdentifier: "gotoMoreInfo", sender: nil)
        hasGotoMoreInfo = true
        
    }
    
    func setLabelText(data: [String]) {
        
        print(data)
        DispatchQueue.main.async {
            // There is about 9 items in this struct, siseof int is 4 so divide by 4
            if data.count < MemoryLayout<PlayerStat.dataIndex>.size/4 {
                return
            } else if data[0] == "HIDDEN" {
                self.levelAndPlaytimeLabel.text = NSLocalizedString("HIDDEN", comment: "Hidden Label")
                self.moreInfo.isHidden = true
                self.number.isHidden = true
            } else {
                self.averageDamageLabel.text = data[PlayerStat.dataIndex.averageDamage]
                self.averageExpLabel.text = data[PlayerStat.dataIndex.averageExp]
                self.killDeathRatioLabel.text = data[PlayerStat.dataIndex.killDeathRatio]
                self.mainBatteryHitRatioLabel.text = data[PlayerStat.dataIndex.hitRatio]
                self.winRateLabel.text = data[PlayerStat.dataIndex.winRate]
                
                let level = data[PlayerStat.dataIndex.servicelevel]
                let playtime = data[PlayerStat.dataIndex.playTime]
                let levelAndPlayTime = NSLocalizedString("LEVEL", comment: "Level label") + ": \(level) | \(playtime) " + NSLocalizedString("DAYS", comment: "Days label")
                self.levelAndPlaytimeLabel.text = levelAndPlayTime
                
                let totalBattles = Double(data[PlayerStat.dataIndex.totalBattles])
                let timePlayed = Double(playtime)
                
                if Int(totalBattles!) > 0 {
                    let battlePerDay = Double(round(100 * (totalBattles! / timePlayed!)) / 100)
                    self.totalBattlesLabel.text = "\(data[PlayerStat.dataIndex.totalBattles]) (\(battlePerDay))"
                } else {
                    self.totalBattlesLabel.text = String(format: "%.0f", totalBattles!)
                    self.moreInfo.isHidden = true
                }
                
                // Get personal rating
                _ = PersonalRating(Damage: data[PlayerStat.dataIndex.averageDamage], WinRate: data[PlayerStat.dataIndex.winRate], Frags: data[PlayerStat.dataIndex.averageFrags])
                self.personalRatingLabel.textColor = PersonalRating.ColorGroup[PersonalRating.index]
                self.personalRatingLabel.text = PersonalRating.Comment[PersonalRating.index]
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.levelAndPlaytimeLabel.alpha = 1.0
                self.personalRatingLabel.alpha = 1.0
                self.winRateLabel.alpha = 1.0
                self.averageDamageLabel.alpha = 1.0
                self.killDeathRatioLabel.alpha = 1.0
                self.totalBattlesLabel.alpha = 1.0
                self.averageExpLabel.alpha = 1.0
                self.mainBatteryHitRatioLabel.alpha = 1.0
            })
        };
        
    }
    
    @IBAction func setPlayerID(_ sender: UIBarButtonItem) {
        
        let playerID = self.title!
        let playerIDAndName = "\(playerNameLabel.text!)|\(playerID)|\(serverIndex)"
        UserDefaults.standard.setValue(playerIDAndName, forKey: DataManagement.DataName.UserName)
        
        // Alert
        let alert = UIAlertController(title: "^_^", message: NSLocalizedString("DASHBOARD_MESSAGE", comment: "Dashboard Message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setPlayerIDBtn.isEnabled = false
        
    }
    
    @IBAction func visitNumber(_ sender: UITapGestureRecognizer) {
        
        self.number.isHidden = true
        // Open World of Warships number
        let number = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: number)
        hasVisitNumber = true
        
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
 
    // Used to take a screenshot
    @IBAction func takeScreenShot(_ sender: UITapGestureRecognizer) {
     
        // Hide number and today and screenshot
        number.isHidden = true
        moreInfo.isHidden = true
        self.screenshot.isHidden = true
     
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
     
        // show number and moreInfo if have not been pressed
        if !hasVisitNumber {
            number.isHidden = false
        }
        
        if !hasGotoMoreInfo {
            moreInfo.isHidden = false
        }
        
        // Popup share button
        let shareSheet  = UIAlertController.init(title: NSLocalizedString("SHARE_TITLE", comment: "Share title"), message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction.init(title: NSLocalizedString("SHARE_MESSAGE", comment: "Share message"), style: .default) { (UIAlertAction) in
            // Share with friends
            let activityViewController = UIActivityViewController(activityItems: [(screenshot!)], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction.init(title: NSLocalizedString("SHARE_CANCEL", comment: "Share cancel"), style: .default, handler: nil)
        shareSheet.addAction(share)
        shareSheet.addAction(cancel)
        
        self.present(shareSheet, animated: true, completion: nil)
        
    }
 
}
