//
//  File.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds
class WelcomeController : UIViewController {
    
    @IBOutlet var gotoSearchController: UITapGestureRecognizer!
    @IBOutlet var gotoSettingsController: UITapGestureRecognizer!
    @IBOutlet weak var proImage: UIButton!
    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var wikiImage: UIImageView!
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var onlinePlayerLabel: UILabel!
    @IBOutlet weak var onlinePlayerIcon: UIImageView!
    @IBOutlet weak var dashboardBtn: UIImageView!
    @IBOutlet weak var gotoHelpBtn: UIBarButtonItem!
    let serverName = ["RU", "EU", "NA", "ASIA"]
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // If it is first launch
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.FirstLaunch) {
            // Show an alertview
            let welcome = UIAlertController(title: NSLocalizedString("WELCOME_TITLE", comment: "Welcome label"), message: NSLocalizedString("WELCOME_MESSAGE", comment: "Welcome message label"), preferredStyle: .alert)
            welcome.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
                self.performSegue(withIdentifier: "gotoSettings", sender: nil)
            }))
            self.present(welcome, animated: true, completion: nil)
            
            // Change it to false
            UserDefaults.standard.set(false, forKey: DataManagement.DataName.FirstLaunch)
        }
        
        // If it is pro version
        if isProVersion {
            // Hide bannerView
            bannerView.isHidden = true
            
            // If there is a valid id
            if UserDefaults.standard.string(forKey: DataManagement.DataName.UserName) == ">_<" {
                dashboardBtn.isHidden = true
            }
        } else {
            proImage.layer.cornerRadius = 5.0
            // Hide dashboard
            dashboardBtn.isHidden = true
            // Hide help btn
            gotoHelpBtn.isEnabled = false
            // Hide friend list
            friendImage.isHidden = true
            // Show pro
            proImage.isHidden = false
            
            // Load ads
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerView.adSize = kGADAdSizeSmartBannerLandscape
            bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
            bannerView.rootViewController = self
            bannerView.load(request)
        }
        
        // Load rating
        ShipRating().loadExpctedJson()
        
        // Get ship information
        Shipinformation().getShipInformation()
        
        // Get Achievement information
        Achievements().getAchievementJson()
        
        // Get upgrade information
        Upgrade().getUpgradeJson()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        onlinePlayerLabel.text = " ... "
        
        if UserDefaults.standard.string(forKey: DataManagement.DataName.UserName) != ">_<" {
            dashboardBtn.isHidden = false
        }
        
        if searchButton.alpha == 0.0 {
            // Show Ads first
            UIView.animate(withDuration: 0.85, delay: 0.0, options: .curveEaseIn, animations: {
                self.bannerView.alpha = 1.0
            }, completion: nil)
            
            // Show online player
            UIView.animate(withDuration: 0.85, delay: 1.0, options: .curveEaseIn, animations: {
                self.onlinePlayerLabel.alpha = 1.0
                self.onlinePlayerLabel.frame.origin.y += 25
                self.onlinePlayerIcon.alpha = 1.0
                self.onlinePlayerIcon.frame.origin.y += 25
            }, completion: nil)
            
            // Show Search Button
            UIView.animate(withDuration: 0.85, delay: 2.0, options: .curveEaseIn, animations: {
                self.searchButton.alpha = 1.0
                self.searchButton.frame.origin.y -= 25
            }, completion: nil)
            
            // Show Settings and Dashboard Button
            UIView.animate(withDuration: 0.85, delay: 2.5, options: .curveEaseIn, animations: {
                self.webImage.alpha = 1.0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.85, delay: 2.75, options: .curveEaseIn, animations: {
                self.wikiImage.alpha = 1.0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.85, delay: 3.0, options: .curveEaseIn, animations: {
                self.settingsBtn.alpha = 1.0
            }, completion: nil)
            
            UIView.animate(withDuration: 0.85, delay: 3.25, options: .curveEaseIn, animations: {
                self.dashboardBtn.alpha = 1.0
            }, completion: nil)
            
            if isProVersion {
                UIView.animate(withDuration: 0.85, delay: 3.5, options: .curveEaseIn, animations: {
                    self.friendImage.alpha = 1.0
                }, completion: nil)
            } else {
                // Show pro button
                UIView.animate(withDuration: 0.85, delay: 3.75, options: .curveEaseIn, animations: {
                    self.proImage.alpha = 1.0
                }, completion: nil)
            }
            
            
        }
        
        // Update online player number
        PlayerOnline().getOnlinePlayerNumber { (player) in
            DispatchQueue.main.async {
                self.onlinePlayerLabel.text = self.serverName[UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)] + " \(player)"
                print("Updated")
            }
        }
        
        // If user is pro version
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked) {
            proImage.isHidden = true
        } else {
            proImage.isHidden = false
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoDashboard" {
            let destination = segue.destination as! AdvancedInfoController
            let playerAccount = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
            destination.playerInfo = playerAccount.components(separatedBy: "|")
            // Change server
            UserDefaults.standard.set(Int(playerAccount.components(separatedBy: "|")[2]), forKey: DataManagement.DataName.Server)
        }
        
    }

    @IBAction func gotoHelp(_ sender: UIBarButtonItem) {
        UIApplication.shared.openURL(URL(string: "https://yihengquan.wordpress.com/2017/03/16/ios-wows-info/")!)
    }
    
}
