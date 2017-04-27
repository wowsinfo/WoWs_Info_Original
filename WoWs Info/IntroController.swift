//
//  IntroController.swift
//  WoWs Info
//
//  Created by Henry Quan on 27/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class IntroController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load rating
        ShipRating().loadExpctedJson()
        
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
        
        DispatchQueue.main.asyncAfter(deadline:.now() + .seconds(3)) {
            // Stop loading and go to first viewcontroller
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.hidesWhenStopped = true
            
            if Reachability.isConnectedToNetwork() == true {
                // If conncted to Internet, segue to search view
                self.performSegue(withIdentifier: "gotoMain", sender: nil)
            } else {
                // Show alert
                let alert = UIAlertController(title: ">_<", message: NSLocalizedString("NO_INTERNET", comment: "No Internet"), preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
