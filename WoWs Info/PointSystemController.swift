//
//  PointSystemController.swift
//  WoWs Info
//
//  Created by Henry Quan on 9/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PointSystemController: UIViewController, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var adBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    let pro = UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    var rewardVideo: GADRewardBasedVideoAd!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Theme
        setupTheme()
        
        // Setup ADs
        rewardVideo = GADRewardBasedVideoAd()
        rewardVideo.delegate = self
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        rewardVideo.load(request, withAdUnitID: "ca-app-pub-5048098651344514/7499671184")
        
        // Setup pointLabel
        if pro {
            pointLabel.text = "∞"
        } else {
            pointLabel.text = "\(self.getCurrPoint())"
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
        print("Ads is \(rewardVideo.isReady)")
        if rewardVideo.isReady {
            // Show an ads
            rewardVideo.present(fromRootViewController: self)
        }
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
}
