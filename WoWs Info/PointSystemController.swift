//
//  PointSystemController.swift
//  WoWs Info
//
//  Created by Henry Quan on 9/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Social

class PointSystemController: UIViewController, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var adBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    let pro = UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Theme
        setupTheme()
        
        // Setup pointLabel
        if pro {
            pointLabel.text = "∞"
        } else {
            pointLabel.text = "\(self.getCurrPoint())"
        }
        
        // Check if user has share and review
        if hasShare() {
            shareBtn.alpha = 0.75
        }
        if hasReview() {
            reviewBtn.alpha = 0.75
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: ADS
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        PointSystem(index: PointSystem.DataIndex.AD).addPoint()
        updatePoint()
    }
    
    // MARK: Theme
    func setupTheme() {
        setupBtn(btn: adBtn)
        setupBtn(btn: reviewBtn)
        setupBtn(btn: shareBtn)
        
        // Setup pointlabel
        pointLabel.backgroundColor = Theme.getCurrTheme()
        pointLabel.layer.cornerRadius = pointLabel.frame.width / 2
        pointLabel.layer.masksToBounds = true
    }
    
    func setupBtn(btn: UIButton) {
        btn.layer.cornerRadius = view.frame.height * 0.02
        btn.layer.masksToBounds = true
        btn.backgroundColor = Theme.getCurrTheme()
    }
    
    // MARK: Button pressed
    @IBAction func playVideoBtnPressed(_ sender: Any) {
        GADRewardBasedVideoAd.sharedInstance().delegate = self
        if GADRewardBasedVideoAd.sharedInstance().isReady {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
    
    @IBAction func reviewBtnPressed(_ sender: Any) {
        // Free 30 points
        PointSystem(index: PointSystem.DataIndex.Review).addPoint()
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.didReview)
        UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/app/id1202750166")!)
        updatePoint()
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        // Free 50 points
        PointSystem(index: PointSystem.DataIndex.Share).addPoint()
        UserDefaults.standard.set(true, forKey: DataManagement.DataName.didShare)
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        share.modalPresentationStyle = .overFullScreen
        self.present(share, animated: true, completion: nil)
        updatePoint()
    }
    
    // MARK: Loading Points
    func getCurrPoint() -> Int {
        return UserDefaults.standard.integer(forKey: DataManagement.DataName.pointSystem)
    }
    
    func updatePoint() {
        if pro {
            pointLabel.text = "∞"
        } else {
            pointLabel.text = "\(self.getCurrPoint())"
        }
    }
    
    // MARK: Helper functions
    func hasReview() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.didReview)
    }
    
    func hasShare() -> Bool {
        return UserDefaults.standard.bool(forKey: DataManagement.DataName.didShare)
    }
}
