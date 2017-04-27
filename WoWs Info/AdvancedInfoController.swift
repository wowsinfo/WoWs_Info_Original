//
//  AdvancedInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 12/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import AudioToolbox

class AdvancedInfoController: UIViewController {

    var playerInfo = [String]()
    var serverIndex = 0
    var isPreview = false
    @IBOutlet weak var number: UIImageView!
    @IBOutlet weak var moreInfo: UIImageView!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var levelAndPlaytimeLabel: UILabel!
    @IBOutlet weak var totalBattlesLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var averageExpLabel: UILabel!
    @IBOutlet weak var averageDamageLabel: UILabel!
    @IBOutlet weak var killDeathRatioLabel: UILabel!
    @IBOutlet weak var mainBatteryHitRatioLabel: UILabel!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    @IBOutlet var statView: UIView!
    @IBOutlet weak var friendBtn: UIButton!
    @IBOutlet weak var tkBtn: UIButton!
    @IBOutlet weak var retryBtn: UIButton!
    var shipData: [[String]]!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shipData = PlayerShip.playerShipInfo
        UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
            self.moreInfo.alpha = 1
        }, completion: nil)
        
        if shipData.count > 0 {
            UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
                self.prLabel.alpha = 1
            }, completion: nil)
            self.calAvgShipRating()
        }
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController){
            // Free it
            PlayerShip.playerShipInfo = [[String]]()
        }
    }
    
    func loadPlayerData() {

        PlayerStat().getDataFromAPI(account: playerInfo[1], success: {playerData in
            self.setLabelText(data: playerData)
        })
        
    }
    
    @IBAction func gotoMoreInfo(_ sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "gotoMoreInfo", sender: nil)
        
    }
    
    func setupNameColour() {
        // Check if this player is friend or tk
        var hasFound = false
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) != nil {
            let friends = user.object(forKey: DataManagement.DataName.friend) as! [String]
            
            for friend in friends {
                if friend.contains(self.title!) {
                    self.playerNameLabel.textColor = UIColor(red: 35/255, green: 135/255, blue: 1, alpha: 1.0)
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
    
    @IBAction func visitNumber(_ sender: UITapGestureRecognizer) {
        
        // Open World of Warships number
        let number = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: number)
        
    }
    
    @IBAction func retryBtnPressed(_ sender: Any) {
        // Load data here
        PlayerShip(account: PlayerAccount.AccountID).getPlayerShipInfo()
        AudioServicesPlaySystemSound(1520)
        moreInfo.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
            self.moreInfo.alpha = 1
        }, completion: nil)
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
        tkBtn.isHidden = true
        friendBtn.isHidden = true
        retryBtn.isHidden = true
        self.screenshot.isHidden = true
     
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
     
        // show number and moreInfo
        number.isHidden = false
        moreInfo.isHidden = false
        tkBtn.isHidden = false
        friendBtn.isHidden = false
        retryBtn.isHidden = false
        
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
        AudioServicesPlaySystemSound(1520)
        
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
    }
 
}
