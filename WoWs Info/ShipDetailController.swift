//
//  ShipDetailController.swift
//  WoWs Info
//
//  Created by Henry Quan on 26/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class ShipDetailController: UIViewController {

    var shipID: String!
    var imageURL: String!
    var shipType: String!
    var shipName: String!
    var shipTier: String!
    @IBOutlet weak var armourTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollviewView: UIView!
    @IBOutlet weak var moneyTypeImage: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    
    @IBOutlet weak var shipTypeImage: UIImageView!
    @IBOutlet weak var shipImage: UIImageView!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipTierLabel: UILabel!
    @IBOutlet weak var shipDescription: UITextView!
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var floodProtectionLabel: UILabel!
    @IBOutlet weak var shotDelayLabel: UILabel!
    @IBOutlet weak var gunLabel: UILabel!
    @IBOutlet weak var gunNameLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var APDamageLabel: UILabel!
    @IBOutlet weak var APSpeedLabel: UILabel!
    @IBOutlet weak var HEDamageLabel: UILabel!
    @IBOutlet weak var HESpeedLabel: UILabel!
    @IBOutlet weak var fireDistanceLabel: UILabel!
    @IBOutlet weak var detectionByPlaneLabel: UILabel!
    @IBOutlet weak var detectionByShipLabel: UILabel!
    @IBOutlet weak var battleRangeLabel: UILabel!
    @IBOutlet weak var torpNameLabel: UILabel!
    @IBOutlet weak var torpDamageLabel: UILabel!
    @IBOutlet weak var torpReloadLabel: UILabel!
    @IBOutlet weak var torpDistanceLabel: UILabel!
    @IBOutlet weak var torpSpeedLabel: UILabel!
    @IBOutlet weak var torpDecectionLabel: UILabel!
    @IBOutlet weak var mobilityLabel: UILabel!
    var screenshotBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load a button in Navigation bar
        screenshotBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takeScreenshot))
        screenshotBtn.isEnabled = false
        self.navigationItem.rightBarButtonItem = screenshotBtn
        
        self.title = shipID
        self.shipImage.sd_setImage(with: URL(string: imageURL)!)
        self.shipTypeImage.image = Shipinformation.getImageWithType(type: shipType)
        self.shipNameLabel.text = shipName

        // Show all data
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takeScreenshot() {
        
        // Take a screenshot of a page
        DispatchQueue.main.async {
            // Scroll to top
            self.shipDescription.setContentOffset(CGPoint.zero, animated: true)
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }
        
        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: { 
            UIGraphicsBeginImageContextWithOptions(self.scrollView.contentSize, true, UIScreen.main.scale)
            self.scrollviewView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let screenshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        }, completion: nil)
        
        self.screenshotBtn.isEnabled = false
        
    }
    
    func loadData() {
        Ships(shipID: shipID).getShipJson { (ship) in
            DispatchQueue.main.async {
                print(ship)
                let isPrenium = ship["is_premium"].boolValue
                
                // Ship Tier
                let tierSymbol = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
                var tierLabel = "Tier " + tierSymbol[Int(self.shipTier)! - 1]
                if  isPrenium {
                    tierLabel += " " + NSLocalizedString("PRENIUM_SHIP", comment: "Prenium ship label")
                }
                self.shipTierLabel.text = tierLabel
                
                // Ship Price
                if isPrenium {
                    self.moneyTypeImage.image = #imageLiteral(resourceName: "Gold")
                    self.moneyLabel.text = ship["price_gold"].stringValue
                } else {
                    self.moneyTypeImage.image = #imageLiteral(resourceName: "Silver")
                    self.moneyLabel.text = ship["price_credit"].stringValue
                }
                
                // Detailed Information
                self.healthLabel.text = ship["default_profile"]["armour"]["health"].stringValue
                self.floodProtectionLabel.text = "\(ship["default_profile"]["armour"]["flood_prob"].stringValue)%"
                
                // If this ship has guns
                if ship["default_profile"]["artillery"] != JSON.null {
                    self.shotDelayLabel.text = "\(ship["default_profile"]["artillery"]["shot_delay"].stringValue) s"
                    self.gunNameLabel.text = ship["default_profile"]["artillery"]["slots"]["0"]["name"].stringValue
                    self.gunLabel.text = "\(ship["default_profile"]["artillery"]["slots"]["0"]["guns"].stringValue) x \(ship["default_profile"]["artillery"]["slots"]["0"]["barrels"].stringValue)"
                    
                    // If this ship have AP
                    if ship["default_profile"]["artillery"]["shells"]["AP"] != JSON.null {
                        self.APDamageLabel.text = ship["default_profile"]["artillery"]["shells"]["AP"]["damage"].stringValue
                        self.APSpeedLabel.text = "\(ship["default_profile"]["artillery"]["shells"]["AP"]["bullet_speed"].stringValue) m/s"
                    }
                    
                    // If this ship have HE
                    if ship["default_profile"]["artillery"]["shells"]["HE"] != JSON.null {
                        self.HEDamageLabel.text = ship["default_profile"]["artillery"]["shells"]["HE"]["damage"].stringValue
                        self.fireLabel.text = "🔥\(ship["default_profile"]["artillery"]["shells"]["HE"]["burn_probability"].stringValue)%"
                        self.HESpeedLabel.text = "\(ship["default_profile"]["artillery"]["shells"]["HE"]["bullet_speed"].stringValue) m/s"
                    }
                    self.fireDistanceLabel.text = String(format: "%0.2f", ship["default_profile"]["artillery"]["distance"].doubleValue) + " km"
                }
                
                self.detectionByPlaneLabel.text = "\(ship["default_profile"]["concealment"]["detect_distance_by_plane"].stringValue) km"
                self.detectionByShipLabel.text = "\(ship["default_profile"]["concealment"]["detect_distance_by_ship"].stringValue) km"
                
                self.battleRangeLabel.text = "\(ship["default_profile"]["battle_level_range_min"].stringValue) - \(ship["default_profile"]["battle_level_range_max"].stringValue)"
                
                // If this ship have torp
                if ship["default_profile"]["torpedoes"] != JSON.null {
                    self.torpNameLabel.text = ship["default_profile"]["torpedoes"]["torpedo_name"].stringValue
                    self.torpReloadLabel.text = "\(ship["default_profile"]["torpedoes"]["reload_time"].stringValue) s"
                    self.torpSpeedLabel.text = "\(ship["default_profile"]["torpedoes"]["torpedo_speed"].stringValue) knot"
                    self.torpDamageLabel.text = ship["default_profile"]["torpedoes"]["max_damage"].stringValue
                    self.torpDecectionLabel.text = "\(ship["default_profile"]["torpedoes"]["visibility_dist"].stringValue) km"
                    self.torpDistanceLabel.text = "\(ship["default_profile"]["torpedoes"]["distance"].stringValue) km"
                }
                
                self.mobilityLabel.text = "\(ship["default_profile"]["mobility"]["max_speed"].stringValue) knot | \(ship["default_profile"]["mobility"]["turning_radius"].stringValue) m"
                
                // Ship description
                self.shipDescription.text = ship["description"].stringValue
                DispatchQueue.main.async {
                    self.shipDescription.setContentOffset(CGPoint.zero, animated: true)
                }
                
                // Animation
                UIView.animate(withDuration: 0.3, animations: { 
                    self.shipTierLabel.alpha = 1.0
                    self.moneyLabel.alpha = 1.0
                    self.moneyTypeImage.alpha = 1.0
                })
                
                UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseIn, animations: {
                    self.shipDescription.alpha = 1.0
                }, completion: nil)
                
                UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseIn, animations: {
                    self.healthLabel.alpha = 1.0
                    self.floodProtectionLabel.alpha = 1.0
                    
                    self.shotDelayLabel.alpha = 1.0
                    self.gunNameLabel.alpha = 1.0
                    self.gunLabel.alpha = 1.0
                    self.APDamageLabel.alpha = 1.0
                    self.APSpeedLabel.alpha = 1.0
                    self.HEDamageLabel.alpha = 1.0
                    self.fireLabel.alpha = 1.0
                    self.HESpeedLabel.alpha = 1.0
                    self.fireDistanceLabel.alpha = 1.0
                    
                    self.detectionByPlaneLabel.alpha = 1.0
                    self.detectionByShipLabel.alpha = 1.0
                    
                    self.battleRangeLabel.alpha = 1.0
                    
                    self.torpNameLabel.alpha = 1.0
                    self.torpReloadLabel.alpha = 1.0
                    self.torpSpeedLabel.alpha = 1.0
                    self.torpDamageLabel.alpha = 1.0
                    self.torpDecectionLabel.alpha = 1.0
                    self.torpDistanceLabel.alpha = 1.0
                    
                    self.mobilityLabel.alpha = 1.0
                    
                    // You could now take a screen shot
                    self.screenshotBtn.isEnabled = true
                }, completion: nil)
            }
        }
        
    }

}
