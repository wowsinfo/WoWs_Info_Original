//
//  IntroController.swift
//  WoWs Info
//
//  Created by Henry Quan on 27/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class IntroController: UIViewController, GADInterstitialDelegate {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var interstitial: GADInterstitial!
    let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UserDefaults.standard.color(forKey: DataManagement.DataName.theme)
        // Setup Ads
        if !isPro {
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-5048098651344514/7499671184")
            interstitial.delegate = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            interstitial.load(request)
        }
        
        if !hasInternet() {
            self.view.isUserInteractionEnabled = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hasInternet() -> Bool {
        var hasInternet = false
        DispatchQueue.main.asyncAfter(deadline:.now() + .seconds(3)) {
            // Stop loading and go to first viewcontroller
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.hidesWhenStopped = true
            
            if Reachability.isConnectedToNetwork() == true {
                // Load data here
                self.loadData()
                hasInternet = true
                // Download data from wows-numbers.com
                if !DataUpdater.hasData() {
                    let success = DataUpdater.update()
                    if !success {
                        let error = UIAlertController.QuickMessage(title: "Error", message: "Fail to download ExpectedValue.json", cancel: "OK")
                        self.present(error, animated: true, completion: nil)
                    }
                }
                
                // Show an ads
                if !self.isPro {
                    if self.interstitial.isReady {
                        self.interstitial.present(fromRootViewController: self)
                    } else {
                        print("\n\n\n\nads\nNot Ready\n\n\n\n\n")
                        self.performSegue(withIdentifier: "gotoMain", sender: nil)
                    }
                    
                } else {
                    self.performSegue(withIdentifier: "gotoMain", sender: nil)
                }
            } else {
                // Show alert
                let alert = UIAlertController(title: ">_<", message: NSLocalizedString("NO_INTERNET", comment: "No Internet"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        return hasInternet
    }

    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.performSegue(withIdentifier: "gotoMain", sender: nil)
    }
    
    func loadData() {
        // Get ship information
        Shipinformation().getShipInformation()
        
        // Get Achievement information
        Achievements().getAchievementJson()
        
        // Get upgrade information
        Upgrade().getUpgradeJson()
        
        // Get flag information
        Flag().getFlagJson()
        
        // Get camouflage information
        Camouflage().getCamouflageJson()
        
        // Get commander skill information
        CommanderSkill().getCommanderSkillJson()
    }
    
    @IBAction func retryLoading(_ sender: Any) {
        // Retry
        _ = hasInternet()
        // Reset animation
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
    }
}
