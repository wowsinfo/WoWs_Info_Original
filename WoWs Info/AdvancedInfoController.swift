//
//  AdvancedInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 12/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import AudioToolbox

class AdvancedInfoController: UITableViewController {

    var playerInfo = [String]()
    @IBOutlet weak var clanNameLabel: UILabel!
    var serverIndex = 0
    var isPreview = false
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var levelAndPlaytimeLabel: UILabel!
    @IBOutlet weak var totalBattlesLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var averageExpLabel: UILabel!
    @IBOutlet weak var averageDamageLabel: UILabel!
    @IBOutlet weak var killDeathRatioLabel: UILabel!
    @IBOutlet weak var mainBatteryHitRatioLabel: UILabel!
    @IBOutlet weak var friendBtn: UIButton!
    @IBOutlet weak var tkBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    var shipData: [[String]]!
    var clanInfo: [String]!
    var clanData = [String]()
    
    let username = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
    let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    @IBOutlet weak var setPlayerIDBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load player id into title
        self.title  = playerInfo[1]
        playerNameLabel.text = playerInfo[0]
        
        // Pass account id
        _ = PlayerAccount.init(ID: self.title!, Name: playerInfo[0])
        
        // Just to prevent user playing with that button...
        if username.range(of: playerInfo[1]) != nil {
            setPlayerIDBtn.isEnabled = false
        }
        
        // Get server index
        self.serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
        // Check for friend or tk
        setupNameColour()
        
        // If it is for review
        if isPreview {
            tkBtn.isHidden = true
            friendBtn.isHidden = true
            setPlayerIDBtn.isEnabled = false
        }
        
        // Load data here
        PlayerShip(account: PlayerAccount.AccountID).getPlayerShipInfo()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.shipData = PlayerShip.playerShipInfo
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.loadPlayerData()
        })
        
        // Get Clan Info
        PlayerClan().getClanList { (Data) in
            DispatchQueue.main.async {
                print("Clan Data: \(Data) \(Data.count)")
                if Data.count > 0 {
                    self.clanInfo = Data
                    UIView.animate(withDuration: 0.5, animations: {
                        self.clanNameLabel.alpha = 1
                        self.clanNameLabel.text = self.clanInfo[1]
                    })
                    
                    // Get Clan Info
                    ClanSearch().getClanList(clan: Data[1], success: { (Clan) in
                        self.clanData = Clan[0]
                    })
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isMovingToParentViewController {
            // Clear Data Here
            print("Clearing")
            shipData = [[String]]()
            PlayerShip.playerShipInfo = [[String]]()
        }
    }
    
    func loadPlayerData() {

        PlayerStat().getDataFromAPI(account: playerInfo[1], success: {playerData in
            self.setLabelText(data: playerData)
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Calculate PR after 1 seconds
            self.calAvgShipRating()
        })
        
    }
    
    func setupNameColour() {
        // Check if this player is friend or tk
        var hasFound = false
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) != nil {
            let friends = user.object(forKey: DataManagement.DataName.friend) as! [String]
            
            for friend in friends {
                if friend.contains(self.title!) {
                    hideFriendTKBtn()
                    hasFound = true
                    break
                }
            }
            
            // Search for tk if not found
            if !hasFound {
                if user.object(forKey: DataManagement.DataName.tk) != nil {
                    let tks = user.object(forKey: DataManagement.DataName.tk) as! [String]
                    for tk in tks {
                        if tk.contains(self.title!) {
                            self.playerNameLabel.textColor = UIColor(red: 230/255, green: 106/255, blue: 1, alpha: 1.0)
                            hideFriendTKBtn()
                            break
                        }
                    }
                }
            }
        }
    }
    
    func setLabelText(data: [String]) {
        
        print(data)
        DispatchQueue.main.async {
            // There is about 9 items in this struct, siseof int is 4 so divide by 4
            if data.count < MemoryLayout<PlayerStat.dataIndex>.size/4 {
                return
            } else if data[0] == "HIDDEN" {
                self.levelAndPlaytimeLabel.text = NSLocalizedString("HIDDEN", comment: "Hidden Label")
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
                }
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.levelAndPlaytimeLabel.alpha = 1.0
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
        var gamePerDay = totalBattlesLabel.text?.components(separatedBy: "(")[1]
        gamePerDay = gamePerDay?.replacingOccurrences(of: ")", with: "")
        
        let alert: UIAlertController!
        if Double(gamePerDay!)! >= 15 {
            alert = UIAlertController(title: ">_<", message: NSLocalizedString("GAME_ISNOT_EVERYTHING", comment: "Remainder"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("GAME_ISNOT_EVERYTHING_BTN", comment: "Remainder"), style: .default, handler: nil))
        } else {
            alert = UIAlertController(title: "^_^", message: NSLocalizedString("DASHBOARD_MESSAGE", comment: "Dashboard Message"), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        self.present(alert, animated: true, completion: nil)
        
        setPlayerIDBtn.isEnabled = false
        
    }
    
    @IBAction func retryBtnPressed(_ sender: Any) {
        // Load data here
        PlayerShip(account: PlayerAccount.AccountID).getPlayerShipInfo()
        calAvgShipRating()
        AudioServicesPlaySystemSound(1520)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back button")
        navigationItem.backBarButtonItem = backItem
        
        // Go to WebView
        if segue.identifier == "gotoWebView" {
            let destination = segue.destination as! WebViewController
            // Open in WoWs Number
            destination.url = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        }
        
        // Go to Clan
        if segue.identifier == "gotoClan" {
            let destination = segue.destination as! ClanInfoController
            destination.clanDataString = "\(clanData[ClanSearch.dataIndex.id]) | \(clanData[ClanSearch.dataIndex.memberCount]) | \(clanData[ClanSearch.dataIndex.name]) | \(clanData[ClanSearch.dataIndex.tag])"
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !isPro {
            // Do not segue if it is not Pro
            return false
        }
        
        if identifier == "gotoClan" {
            if clanData.count == 0 {
                // If player does not have a clan
                return false
            }
        }
        
        if identifier == "gotoWebView" || identifier == "gotoMoreInfo" {
            if self.totalBattlesLabel.text == "0" {
                // Do not segue if they never player a battle
                return false
            }
        }
        
        
        
        return true
    }
    
    // MARK: Button pressed
    @IBAction func friendbtnPressed(_ sender: UIButton) {
        hideFriendTKBtn()
        
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) == nil {
            user.set(["HenryQuan|2011774448|3"], forKey: DataManagement.DataName.friend)
        }
        
        let text = "\(self.playerNameLabel.text!)|\(self.title!)|\(user.integer(forKey: DataManagement.DataName.Server))"
        if text != "HenryQuan|2011774448|3" {
            var list = user.object(forKey: DataManagement.DataName.friend) as! [String]
            list.append(text)
            user.set(list, forKey: DataManagement.DataName.friend)
        }

    }
    
    @IBAction func tkBtnPressed(_ sender: UIButton) {
        hideFriendTKBtn()
        
        let user = UserDefaults.standard
        if UserDefaults.standard.object(forKey: DataManagement.DataName.tk) == nil {
            UserDefaults.standard.set([String](), forKey: DataManagement.DataName.tk)
        }
        
        var list = user.object(forKey: DataManagement.DataName.tk) as! [String]
        list.append("\(self.playerNameLabel.text!)|\(self.title!)|\(user.integer(forKey: DataManagement.DataName.Server))")
        user.set(list, forKey: DataManagement.DataName.tk)
        
    }
    
    func hideFriendTKBtn() {
        friendBtn.isHidden = true
        tkBtn.isHidden = true
        tkBtn.setTitleColor(UIColor.darkText, for: .normal)
    }
    
    func calAvgShipRating() {
        
        var actualDmg = 0.0
        var actualWins = 0.0
        var actualFrags = 0.0
        
        var expectedDmg = 0.0
        var expectedWins = 0.0
        var expectedFrags = 0.0
        
        var rating = 0.0
        
        if shipData.count > 0 {
            // Wont crash
            for ship in shipData {
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
            
            prLabel.text = PersonalRating.Comment[index]
            prLabel.textColor = PersonalRating.ColorGroup[index]
            UIView.animate(withDuration: 0.5) { 
                self.prLabel.alpha = 1
            }
        } else {
            prLabel.text = ">_<"
            UIView.animate(withDuration: 0.5) {
                self.prLabel.alpha = 1
            }
        }
    }
 
}
