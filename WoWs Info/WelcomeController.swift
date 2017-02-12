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
    @IBOutlet weak var searchButton: UIImageView!
    @IBOutlet weak var settingsBtn: UIImageView!
    @IBOutlet weak var onlinePlayerLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // If it is first launch
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.FirstLaunch) {
            // Show an alertview
            let welcome = UIAlertController(title: "Welcome", message: "This application is designed to get a quick overview of other players before battle begins. Please first customise some settings.", preferredStyle: .alert)
            welcome.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> () in
                self.performSegue(withIdentifier: "gotoSettings", sender: nil)
            }))
            self.present(welcome, animated: true, completion: nil)
            
            // Change it to false
            UserDefaults.standard.set(false, forKey: DataManagement.DataName.FirstLaunch)
        }
        
        // Load ads
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        bannerView.adSize = kGADAdSizeSmartBannerLandscape
        bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
        bannerView.rootViewController = self
        bannerView.load(request)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        onlinePlayerLabel.text = "  Updating..."
        
        if searchButton.alpha == 0.0 {
            // Show Ads first
            UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseIn, animations: {
                self.bannerView.alpha = 1.0
            }, completion: nil)
            
            // Show online player
            UIView.animate(withDuration: 0.75, delay: 1.0, options: .curveEaseIn, animations: {
                self.onlinePlayerLabel.alpha = 1.0
            }, completion: nil)
            
            // Show Search Button
            UIView.animate(withDuration: 0.75, delay: 2.0, options: .curveEaseIn, animations: {
                self.searchButton.alpha = 1.0
            }, completion: nil)
            
            // Show Settings Button
            UIView.animate(withDuration: 0.75, delay: 2.5, options: .curveEaseIn, animations: {
                self.settingsBtn.alpha = 1.0
            }, completion: nil)
        }
        
        // Update online player number
        PlayerOnline().getOnlinePlayerNumber { (player) in
            DispatchQueue.main.async {
                self.onlinePlayerLabel.text = "  \(player) players online"
                print("Updated")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }

}
