//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    let imageSet = [#imageLiteral(resourceName: "Web"),#imageLiteral(resourceName: "AppStore"),#imageLiteral(resourceName: "Settings"), #imageLiteral(resourceName: "Icon")]
    let wordSet = ["WEB_SETTINGS".localised(), "APP_SETTINGS".localised(), "SETTINGS_SETTINGS".localised(), "THEME_SETTINGS".localised()]
    let segueSet = ["gotoProVersion", "gotoWeb", "gotoReview", "gotoSettings", "gotoTheme"]
    var isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Whether ads should be shown
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased) {
            // Remove it
            bannerView.removeFromSuperview()
            bannerView.frame.size.height = 0
        } else {
            // Load ads
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
            bannerView.rootViewController = self
            bannerView.delegate = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerView.load(request)
        }
        
        // Setup tableview
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorColor = UIColor.clear
        
        settingsTableView.estimatedRowHeight = 60
        settingsTableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("SETTINGS_SETTINGS", comment: "Settings Title")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If it is Pro
        isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
        // Update theme colour
        let ThemeColour = Theme.getCurrTheme()
        self.navigationController?.navigationBar.barTintColor = ThemeColour
        self.tabBarController?.tabBar.tintColor = ThemeColour
        // Reload tableview
        self.settingsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: ADS
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        // Remove it
        bannerView.removeFromSuperview()
        bannerView.frame.size.height = 0
    }
    
    // MARK: UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPro { return imageSet.count + 1 }
        // IF not ask user to buy it
        return imageSet.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        if isPro {
            // Paid version
            if indexPath.row != imageSet.count {
                // Setting cell
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.logoImage.layer.cornerRadius = cell.logoImage.frame.width / 5
                cell.logoImage.layer.masksToBounds = true
                cell.logoImage.image = imageSet[index]
                cell.nameLabel.text = wordSet[index]
                return cell
            } else {
                // Developer cell
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "DeveloperCell", for: indexPath) as! DeveloperCell
                cell.devLabel.text = NSLocalizedString("DEV_LABEL", comment: "Devloper")
                return cell
            }
        } else {
            // Free version
            if index == 0 {
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "UpgradeCell", for: indexPath) as! UpgradeCell
                // Update text colour as well
                cell.proLabel.text = NSLocalizedString("UPGRADE_SETTINGS", comment: "Upgrade to Pro")
                cell.proLabel.textColor = Theme.getCurrTheme()
                return cell
            } else if indexPath.row != imageSet.count + 1{
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
                cell.logoImage.image = imageSet[index - 1]
                cell.logoImage.layer.cornerRadius = cell.logoImage.frame.width / 5
                cell.logoImage.layer.masksToBounds = true
                cell.nameLabel.text = wordSet[index - 1]
                return cell
            } else {
                // Developer cell
                let cell = settingsTableView.dequeueReusableCell(withIdentifier: "DeveloperCell", for: indexPath) as! DeveloperCell
                cell.devLabel.text = NSLocalizedString("DEV_LABEL", comment: "Devloper")
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isPro {
            if indexPath.row != imageSet.count {
                performSegue(withIdentifier: segueSet[indexPath.row + 1], sender: nil)
            }
        } else {
            if indexPath.row != imageSet.count + 1 {
                performSegue(withIdentifier: segueSet[indexPath.row], sender: nil)
            }
        }
    }
    
    // MARK: Button pressed
    @IBAction func shareBtnPressed(_ sender: Any) {
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
    }

}
