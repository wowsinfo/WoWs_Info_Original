//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Social

class SettingsController: UITableViewController, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var themeImage: UIImageView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var appstoreImage: UIImageView!
    
    @IBOutlet weak var proBtn: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    
    var isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    var didReview = UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview)
    var notReadyCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust insets for Pro and Free users
        var inset: UIEdgeInsets!
        // Whether ads should be shown
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased) {
            // Remove it
            bannerView.removeFromSuperview()
            
            inset = UIEdgeInsets(top: CGFloat(-kGADAdSizeSmartBannerPortrait.size.height), left: 0, bottom: 0, right: 0)
        } else {
            // Load ads
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
            bannerView.rootViewController = self
            bannerView.delegate = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerView.load(request)
            
            inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        // Setup Tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = inset
        
        
        if isPro {
            self.proBtn.removeFromSuperview()
        }
        
        // Setup Theme
        setupTheme()
        // Update points
        updatePoint()
        
        self.navigationController?.navigationBar.topItem?.title = NSLocalizedString("SETTINGS_SETTINGS", comment: "Settings Title")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // If it is Pro
        isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
        didReview = UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview)
        
        // Update theme colour
        let ThemeColour = Theme.getCurrTheme()
        self.navigationController?.navigationBar.barTintColor = ThemeColour
        self.tabBarController?.tabBar.tintColor = ThemeColour
        
        // Update Theme
        setupTheme()
        // Update points
        updatePoint()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updatePoint() {
        if isPro {
            pointLabel.text = "POINT_SYSTEM".localised() + " (∞)"
        } else {
            pointLabel.text = "POINT_SYSTEM".localised() + " (\(PointSystem.getCurrPoint()))"
        }
    }
    
    // MARK: Theme
    func setupTheme() {
        // Setup Image
        let theme = Theme.getCurrTheme()
        setupImage(image: webImage)
        setupImage(image: facebookImage)
        setupImage(image: themeImage)
        setupImage(image: linkImage)
        setupImage(image: appstoreImage)
        linkImage.backgroundColor = theme
        themeImage.backgroundColor = theme
    }
    
    func setupImage(image: UIImageView) {
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "gotoTheme" {
            // You need to rate in order to use it
            if !isPro && !didReview {
                let theme = UIAlertController(title: "THEME_TITLE".localised(), message: "THEME_MESSAGE".localised(), preferredStyle: .alert)
                theme.addAction(UIAlertAction(title: "OK", style: .default, handler: { (OK) in
                    // Free 50 points
                    PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                    UserDefaults.standard.set(true, forKey: DataManagement.DataName.didReview)
                    UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/app/id1202750166")!)
                }))
                theme.addAction(UIAlertAction(title: "SHARE_CANCEL".localised(), style: .cancel, handler: nil))
                self.present(theme, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    // MARK: ADS
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        // Remove it
        bannerView.removeFromSuperview()
        bannerView.frame.size.height = 0
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        // Add some points
        PointSystem(index: PointSystem.DataIndex.AD).addPoint()
        updatePoint()
    }
    
    // MARK: UITableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = tableView.cellForRow(at: indexPath)?.tag {
            // Point
            if tag == 10 {
                if !isPro {
                    GADRewardBasedVideoAd.sharedInstance().delegate = self
                    if GADRewardBasedVideoAd.sharedInstance().isReady {
                        GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
                    } else {
                        notReadyCount += 1
                        let notReady = UIAlertController.QuickMessage(title: "ADS_NOT_READY_TITLE".localised(), message: "ADS_NOT_READY_MESSAGE".localised(), cancel: "OK")
                        self.present(notReady, animated: true, completion: nil)
                        
                        if notReadyCount % 10 == 0 {
                            // You could get 1 point if ads could not load
                            PointSystem(index: PointSystem.DataIndex.NotReady).addPoint()
                            updatePoint()
                        }
                    }
                }
            }
            
            // Share
            let link = URL(string: "https://itunes.apple.com/app/id1202750166")!
            switch tag {
            case 11:
                // Link
                let copyLink = UIActivityViewController(activityItems: [link], applicationActivities: nil)
                copyLink.popoverPresentationController?.sourceView = self.view
                self.present(copyLink, animated: true, completion: nil)
            case 12:
                // Facebook
                let facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebook?.add(link)
                facebook?.add(#imageLiteral(resourceName: "Icon"))
                facebook?.completionHandler = { (result) in
                    if result == .done {
                        // Free 50 points
                        print("Done")
                        PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                        UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                    } else {
                        print("Cancel")
                    }
                }
                self.present(facebook!, animated: true, completion: nil)
            case 13:
                // Twitter
                let twitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitter?.add(link)
                twitter?.add(#imageLiteral(resourceName: "Icon"))
                twitter?.completionHandler = { (result) in
                    if result == .done {
                        // Free 50 points
                        print("Done")
                        PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                        UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                    } else {
                        print("Cancel")
                    }
                }
                self.present(twitter!, animated: true, completion: nil)
            case 14:
                // Weibo
                let weibo = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
                weibo?.add(link)
                weibo?.add(#imageLiteral(resourceName: "Icon"))
                weibo?.completionHandler = { (result) in
                    if result == .done {
                        // Free 50 points
                        print("Done")
                        PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                        UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                    } else {
                        print("Cancel")
                    }
                }
                self.present(weibo!, animated: true, completion: nil)
            case 15:
                // Rate
                UIApplication.shared.openURL(link)
                PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                UserDefaults.standard.set(true, forKey: DataManagement.DataName.didReview)
            default: break
            }
        }
        
        // Deselect
        tableView.deselectRow(at: indexPath, animated: true)
        // Update points
        updatePoint()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: Button pressed
    @IBAction func shareBtnPressed(_ sender: Any) {
        // Free 50 points
        PointSystem(index: PointSystem.DataIndex.Share).addPoint()
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        share.modalPresentationStyle = .overFullScreen
        self.present(share, animated: true, completion: nil)
    }

}
