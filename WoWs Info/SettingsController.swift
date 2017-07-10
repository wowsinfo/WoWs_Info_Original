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
    let imageSet = [#imageLiteral(resourceName: "Web"),#imageLiteral(resourceName: "AppStore"),#imageLiteral(resourceName: "Settings"), #imageLiteral(resourceName: "Theme"), #imageLiteral(resourceName: "Gold")]
    var wordSet = ["WEB_SETTINGS".localised(), "APP_SETTINGS".localised(), "SETTINGS_SETTINGS".localised(), "THEME_SETTINGS".localised(), "POINT_SYSTEM".localised()]
    let segueSet = ["gotoProVersion", "gotoWeb", "gotoReview", "gotoSettings", "gotoTheme", "gotoPoint"]
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
        
        // Update Point
        if isPro {
            wordSet[4] = "POINT_SYSTEM".localised() + " (∞)"
        } else {
            wordSet[4] = "POINT_SYSTEM".localised() + " (\(PointSystem.getCurrPoint()))"
        }
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
                
                // Change theme for theme
                let icon = imageSet[index]
                if icon == #imageLiteral(resourceName: "Theme") { // <-- It is a white icon...
                    cell.logoImage.backgroundColor = Theme.getCurrTheme()
                }
                
                cell.logoImage.image = icon
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
                
                // Change theme for theme
                let icon = imageSet[index - 1]
                if icon == #imageLiteral(resourceName: "Theme") { // <-- It is a white icon...
                    cell.logoImage.backgroundColor = Theme.getCurrTheme()
                } else {
                    cell.logoImage.backgroundColor = UIColor.clear
                }
                
                cell.logoImage.image = icon
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
        let index = indexPath.row
        if isPro {
            if index != imageSet.count {
                performSegue(withIdentifier: segueSet[index + 1], sender: nil)
            }
        } else {
            if index != imageSet.count + 1 {
                if segueSet[index] == "gotoTheme" {
                    if !UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview) {
                        // Ask User to rate this app
                        let rate = UIAlertController(title: "THEME_TITLE".localised(), message: "THEME_MESSAGE".localised(), preferredStyle: .alert)
                        rate.addAction(UIAlertAction(title: "OK", style: .default, handler: { (Review) in
                            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/app/id1202750166")!)
                            // Well, you dont really need to review though                                                                                                                                                                                                                                                                                                                                               
                            UserDefaults.standard.set(true, forKey: DataManagement.DataName.didReview)
                            // Free 30 points for you
                            PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                        }))
                        rate.addAction(UIAlertAction(title: "SHARE_CANCEL".localised(), style: .cancel, handler: nil))
                        self.present(rate, animated: true, completion: nil)
                    } else {
                        performSegue(withIdentifier: "gotoTheme", sender: nil)
                    }
                } else if segueSet[index] == "gotoProVersion" {
                    let storyboard = UIStoryboard(name: "ProVersion", bundle: Bundle.main)
                    let pro = storyboard.instantiateViewController(withIdentifier: "ProViewController") as! IAPController
                    pro.modalPresentationStyle = .overFullScreen
                    self.present(pro, animated: true, completion: nil)
                } else {
                    performSegue(withIdentifier: segueSet[index], sender: nil)
                }
            }
        }
    }
    
    // MARK: Button pressed
    @IBAction func shareBtnPressed(_ sender: Any) {
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        share.modalPresentationStyle = .overFullScreen
        self.present(share, animated: true, completion: nil)
        // Free 50 points
        PointSystem(index: PointSystem.DataIndex.Share).addPoint()
    }

}
