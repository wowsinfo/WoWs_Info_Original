//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SettingsController: UITableViewController, GADBannerViewDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var webImage: UIImageView!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var themeImage: UIImageView!
    @IBOutlet weak var linkImage: UIImageView!
    @IBOutlet weak var appstoreImage: UIImageView!
    
    @IBOutlet weak var proBtn: UIButton!
    
    var isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    var didReview = UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust insets for Pro and Free users
        var inset: UIEdgeInsets!
        // Whether ads should be shown
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased) {
            // Remove it
            bannerView.removeFromSuperview()
            bannerView.frame.size.height = 0
            
            inset = UIEdgeInsets(top: -44, left: 0, bottom: 0, right: 0)
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            // You could need rate in order to use it
            if !isPro || !didReview { return false }
        }
        
        return true
    }
    
    // MARK: ADS
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        // Remove it
        bannerView.removeFromSuperview()
        bannerView.frame.size.height = 0
    }
    
    // MARK: UITableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = tableView.cellForRow(at: indexPath)?.tag {
            // Segue to certain contorller
        }
        
        // Deselect
        tableView.deselectRow(at: indexPath, animated: true)
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
