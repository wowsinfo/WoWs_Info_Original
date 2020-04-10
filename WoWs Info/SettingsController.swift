//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 28/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Social

class SettingsController: UITableViewController {

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
    
        // Setup Tableview
        tableView.delegate = self
        tableView.dataSource = self
        
        PointSystem(index: PointSystem.DataIndex.Review).addPoint()

        self.proBtn.removeFromSuperview()
        // Update theme image
        themeImage.image = #imageLiteral(resourceName: "ThemePro")
        
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
    
    
    // MARK: UITableView
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = tableView.cellForRow(at: indexPath)?.tag {
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
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                    let facebook = SLComposeViewController(forServiceType: SLServiceTypeFacebook)!
                    facebook.add(link)
                    facebook.add(#imageLiteral(resourceName: "Icon"))
                    facebook.completionHandler = { (result) in
                        if result == .done {
                            // Free 50 points
                            print("Done")
                            PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                            UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                        } else {
                            print("Cancel")
                        }
                    }
                    self.present(facebook, animated: true, completion: nil)
                } else {
                    let error = UIAlertController.QuickMessage(title: "SOCIAL_ERROR_TITLE".localised(), message: "SOCIAL_ERROR_MESSAGE".localised(), cancel: "OK")
                    self.present(error, animated: true, completion: nil)
                }
            case 13:
                // Twitter
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                    let twitter = SLComposeViewController(forServiceType: SLServiceTypeTwitter)!
                    twitter.add(link)
                    twitter.add(#imageLiteral(resourceName: "Icon"))
                    twitter.completionHandler = { (result) in
                        if result == .done {
                            // Free 50 points
                            print("Done")
                            PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                            UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                        } else {
                            print("Cancel")
                        }
                    }
                    self.present(twitter, animated: true, completion: nil)
                } else {
                    let error = UIAlertController.QuickMessage(title: "SOCIAL_ERROR_TITLE".localised(), message: "SOCIAL_ERROR_MESSAGE".localised(), cancel: "OK")
                    self.present(error, animated: true, completion: nil)
                }
            case 14:
                // Weibo
                if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
                    let weibo = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)!
                    weibo.add(link)
                    weibo.add(#imageLiteral(resourceName: "Icon"))
                    weibo.completionHandler = { (result) in
                        if result == .done {
                            // Free 50 points
                            print("Done")
                            PointSystem(index: PointSystem.DataIndex.Review).addPoint()
                            UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
                        } else {
                            print("Cancel")
                        }
                    }
                    self.present(weibo, animated: true, completion: nil)
                } else {
                    let error = UIAlertController.QuickMessage(title: "SOCIAL_ERROR_TITLE".localised(), message: "SOCIAL_ERROR_MESSAGE".localised(), cancel: "OK")
                    self.present(error, animated: true, completion: nil)
                }
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
