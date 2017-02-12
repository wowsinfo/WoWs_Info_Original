//
//  PlayerInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//
import UIKit
import GoogleMobileAds

class PlayerInfoController : UIViewController {
    
    var playerInfo = [String]()
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var levelAndPlaytimeLabel: UILabel!
    @IBOutlet weak var totalBattlesLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var averageExpLabel: UILabel!
    @IBOutlet weak var averageDamageLabel: UILabel!
    @IBOutlet weak var killDeathRatioLabel: UILabel!
    @IBOutlet weak var mainBatteryHitRatioLabel: UILabel!
    @IBOutlet weak var centerDataConstraint: NSLayoutConstraint!
    @IBOutlet weak var dataStack: UIStackView!
    @IBOutlet weak var bannerView: GADBannerView!
    var serverIndex = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Load player id into title
        self.title  = playerInfo[1]
        playerNameLabel.text = playerInfo[0]
        
        // Change Constraint constant to let stack view in the centre of the screen
        centerDataConstraint.constant = UIScreen.main.bounds.height/2 - 32 - playerNameLabel.bounds.size.height - totalBattlesLabel.bounds.size.height - dataStack.bounds.size.height/2
        print("\(centerDataConstraint.constant)")
        
        self.serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
        loadPlayerData()
        
        // Load ads
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
        bannerView.rootViewController = self
        bannerView.load(request)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadPlayerData() {
        PlayerStat().getDataFromAPI(account: playerInfo[1], success: {playerData in
            self.setLabelText(data: playerData)
        })
    }
    
    func setLabelText(data: [String]) {
        
        print(data)
        DispatchQueue.main.async {
            // There is about 9 items in this struct, siseof int is 4 so divide by 4
            if data.count < MemoryLayout<PlayerStat.dataIndex>.size/4 {
                return
            } else if data[0] == "HIDDEN" {
                self.levelAndPlaytimeLabel.text = "Account is Hidden!"
            } else {
                self.averageDamageLabel.text = data[PlayerStat.dataIndex.averageDamage]
                self.averageExpLabel.text = data[PlayerStat.dataIndex.averageExp]
                self.killDeathRatioLabel.text = data[PlayerStat.dataIndex.killDeathRatio]
                self.mainBatteryHitRatioLabel.text = data[PlayerStat.dataIndex.hitRatio]
                self.winRateLabel.text = data[PlayerStat.dataIndex.winRate]
                
                let level = data[PlayerStat.dataIndex.servicelevel]
                let playtime = data[PlayerStat.dataIndex.playTime]
                let levelAndPlayTime = "Level: \(level)   (\(playtime) DAYS)"
                self.levelAndPlaytimeLabel.text = levelAndPlayTime
                
                let totalBattles = Double(data[PlayerStat.dataIndex.totalBattles])
                let timePlayed = Double(playtime)
                
                if Int(totalBattles!) > 0 {
                    let battlePerDay = Double(round(100 * (totalBattles! / timePlayed!)) / 100)
                    self.totalBattlesLabel.text = "\(data[PlayerStat.dataIndex.totalBattles]) (\(battlePerDay)/day)"
                } else {
                    self.totalBattlesLabel.text = String(format: "%.0f", totalBattles!)
                }
                
            }
        };
        
    }

    @IBAction func visitNumber(_ sender: UITapGestureRecognizer) {
        
        print("Number")
        // Open World of Warships Number
        let number = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: number)
        
    }
    
    @IBAction func visitToday(_ sender: UITapGestureRecognizer) {
        
        print("Today")
        // Open World of Warships Today
        let today = ServerUrl(serverIndex: serverIndex).getUrlForToday(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: today)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        // Go to PlayerInfoController
        let destination = segue.destination as! WebViewController
        destination.url = sender as! String
        
    }
    
}
