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
    
    
    let username = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
    
    @IBOutlet weak var setPlayerIDBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load player id into title
        self.title  = playerInfo[1]
        playerNameLabel.text = playerInfo[0]
        
        loadPlayerData()
        
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
    }
    
    func setLabelText(data: [String]) {
        
        print(data)
        DispatchQueue.main.async {
            // There is about 9 items in this struct, siseof int is 4 so divide by 4
            if data.count < MemoryLayout<PlayerStat.dataIndex>.size/4 {
                return
            } else if data[0] == "HIDDEN" {
                self.levelAndPlaytimeLabel.text = "HIDDEN"
            } else {
                self.averageDamageLabel.text = data[PlayerStat.dataIndex.averageDamage]
                self.averageExpLabel.text = data[PlayerStat.dataIndex.averageExp]
                self.killDeathRatioLabel.text = data[PlayerStat.dataIndex.killDeathRatio]
                self.mainBatteryHitRatioLabel.text = data[PlayerStat.dataIndex.hitRatio]
                self.winRateLabel.text = data[PlayerStat.dataIndex.winRate]
                
                let level = data[PlayerStat.dataIndex.servicelevel]
                let playtime = data[PlayerStat.dataIndex.playTime]
                let levelAndPlayTime = "Level: \(level) | \(playtime) DAYS"
                self.levelAndPlaytimeLabel.text = levelAndPlayTime
                
                let totalBattles = Double(data[PlayerStat.dataIndex.totalBattles])
                let timePlayed = Double(playtime)
                
                if Int(totalBattles!) > 0 {
                    let battlePerDay = Double(round(100 * (totalBattles! / timePlayed!)) / 100)
                    self.totalBattlesLabel.text = "\(data[PlayerStat.dataIndex.totalBattles]) (\(battlePerDay))"
                } else {
                    self.totalBattlesLabel.text = String(format: "%.0f", totalBattles!)
                }
                
                // Get personal rating
                let PR = PersonalRating(Damage: data[PlayerStat.dataIndex.averageDamage], WinRate: data[PlayerStat.dataIndex.winRate], Frags: data[PlayerStat.dataIndex.averageFrags])
                let Index = PR.getPersonalRatingIndex()
                self.personalRatingLabel.textColor = PersonalRating.ColorGroup[Index]
                self.personalRatingLabel.text = PersonalRating.Comment[Index]
            }
        };
        
    }

    @IBAction func personalRatingPressed(_ sender: UIButton) {
        
        // Show all stat and hide all stat
        
    }
    
    @IBAction func setPlayerID(_ sender: UIBarButtonItem) {
        
        let playerID = self.title!
        let playerIDAndName = "\(playerNameLabel.text!)|\(playerID)"
        UserDefaults.standard.setValue(playerIDAndName, forKey: DataManagement.DataName.UserName)
        
        // Alert
        let alert = UIAlertController(title: "^_^", message: "Your name and ID are saved!\nYou could now use Dashboard", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setPlayerIDBtn.isEnabled = false
        
    }
    
    @IBAction func visitNumber(_ sender: UITapGestureRecognizer) {
        
        print("Number")
        // Open World of Warships Number
        let number = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: number)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
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
     
        // show number and today
        number.isHidden = false
        moreInfo.isHidden = false
 
    }
 
}
