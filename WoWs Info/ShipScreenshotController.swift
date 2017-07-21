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
    
    @IBOutlet weak var themeImage: UIImageView!
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
    
    let theme = Theme.getCurrTheme()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        // ShipScreen button
        let share = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(takeScreenshot))
        self.navigationItem.rightBarButtonItem = share
        
        // Setup theme
        themeImage.backgroundColor = theme
        themeImage.layer.cornerRadius = 10
        themeImage.layer.masksToBounds = true
        shipTypeImage.tintColor = theme
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takeScreenshot() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let share = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        share.popoverPresentationController?.sourceView = self.view
        self.present(share, animated: true, completion: nil)

        AudioServicesPlaySystemSound(1520)
    }
}
