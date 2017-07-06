//
//  ShipScreenshotController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import AudioToolbox
import SDWebImage

class ShipScreenshotController: UIViewController {
    
    var shipName: String!
    var battle: String!
    var winrate: String!
    var xp: String!
    var damage: String!
    var hitratio: String!
    var killdeathRatio: String!
    var ratingIndex: Int!
    var shipID: String!
    var shipType: String!
    
    @IBOutlet weak var shipTypeImage: UIImageView!
    @IBOutlet weak var shipImage: UIImageView!
    @IBOutlet weak var screenshotImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var battleLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var hitratioLabel: UILabel!
    @IBOutlet weak var killdeathLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Does not allow landscape for iPhone
        if UIDevice.current.userInterfaceIdiom != .pad {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }

        print(shipID)
        nameLabel.text = PlayerAccount.AccountName
        shipNameLabel.text = shipName
        battleLabel.text = battle
        winrateLabel.text = winrate
        expLabel.text = xp
        damageLabel.text = damage
        hitratioLabel.text = hitratio
        killdeathLabel.text = killdeathRatio
        ratingLabel.text = PersonalRating.Comment[ratingIndex]
        ratingLabel.textColor = PersonalRating.ColorGroup[ratingIndex]
        
        Shipinformation.getImageWithId(ID: shipID) { (Link) in
            self.shipImage.sd_setImage(with: URL(string: Link)!)
        }
        shipTypeImage.image = Shipinformation.getImageWithType(type: shipType)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takeScreenshot(_ sender: UITapGestureRecognizer) {
        
        screenshotImage.isHidden = true
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        
        _ = self.navigationController?.popViewController(animated: true)
        AudioServicesPlaySystemSound(1520)
    }
}
