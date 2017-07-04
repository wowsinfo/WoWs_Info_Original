//
//  ShipDetailController.swift
//  WoWs Info
//
//  Created by Henry Quan on 26/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage
import AudioToolbox
import SwiftyJSON
import SafariServices

class ShipDetailController: UITableViewController, SFSafariViewControllerDelegate {
    
    // MARK: variables
    var shipID: String!
    var imageURL: String!
    var shipType: String!
    var shipName: String!
    var shipTier: String!
    var descriptionText: String!
    var nationText: String!
    var moduleTree: [[[String]]]!
    var currModule = [String].init(repeating: "", count: 6)
    
    var ColourGroup = [ UIColor.RGB(red: 85, green: 163, blue: 255), // Blue
                        UIColor.RGB(red: 10, green: 86, blue: 143),
                        
                        UIColor.RGB(red: 255, green: 109, blue: 107), // Red
                        UIColor.RGB(red: 191, green: 86, blue: 135),
                        
                        UIColor.RGB(red: 44, green: 204, blue: 114), // Green
                        UIColor.RGB(red: 43, green: 105, blue: 80),
                        
                        UIColor.RGB(red: 163, green: 107, blue: 242),// Purple
                        UIColor.RGB(red: 109, green: 116, blue: 242),
                        
                        UIColor.RGB(red: 171, green: 119, blue: 84), // Brown
        
                        UIColor.RGB(red: 254, green: 152, blue: 58), // Orange
                        
                        UIColor.RGB(red: 57, green: 57, blue: 62) ] // Black
                    
    // MARK: Buttons
    @IBOutlet weak var hullBtn: UIButton!
    @IBOutlet weak var engineBtn: UIButton!
    @IBOutlet weak var torpBtn: UIButton!
    @IBOutlet weak var fireControlBtn: UIButton!
    @IBOutlet weak var artilleryBtn: UIButton!
    @IBOutlet weak var flightControlBtn: UIButton!
    @IBOutlet weak var moduleColour: UIImageView!
    
    // MARK: Process bar and its value
    @IBOutlet weak var survivabilityBar: UIProgressView!
    @IBOutlet weak var artilleryBar: UIProgressView!
    @IBOutlet weak var torpedoesBar: UIProgressView!
    @IBOutlet weak var AABar: UIProgressView!
    @IBOutlet weak var maneuverbilityBar: UIProgressView!
    @IBOutlet weak var concealmentBar: UIProgressView!
    @IBOutlet weak var aircraftBar: UIProgressView!
    @IBOutlet weak var survivabilityLabel: UILabel!
    @IBOutlet weak var artilleryLabel: UILabel!
    @IBOutlet weak var torpedoesLabel: UILabel!
    @IBOutlet weak var AALabel: UILabel!
    @IBOutlet weak var maneuverbilityLabel: UILabel!
    @IBOutlet weak var concealmentLabel: UILabel!
    @IBOutlet weak var aircraftLabel: UILabel!
    @IBOutlet weak var statusColour: UIImageView!
    
    // MARK: Ship
    @IBOutlet weak var moneyTypeImage: UIImageView!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var shipTypeImage: UIImageView!
    @IBOutlet weak var shipImage: UIImageView!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipTierLabel: UILabel!
    // MARK: Armour
    @IBOutlet weak var healthLabel: UILabel!
    @IBOutlet weak var floodProtectionLabel: UILabel!
    @IBOutlet weak var armourColour: UIImageView!
    // MARK: Artillery
    @IBOutlet weak var shotDelayLabel: UILabel!
    @IBOutlet weak var gunLabel: UILabel!
    @IBOutlet weak var gunNameLabel: UILabel!
    @IBOutlet weak var fireLabel: UILabel!
    @IBOutlet weak var APDamageLabel: UILabel!
    @IBOutlet weak var APSpeedLabel: UILabel!
    @IBOutlet weak var HEDamageLabel: UILabel!
    @IBOutlet weak var HESpeedLabel: UILabel!
    @IBOutlet weak var fireDistanceLabel: UILabel!
    @IBOutlet weak var artilleryColour: UIImageView!
    // MARK: Concealment
    @IBOutlet weak var detectionByPlaneLabel: UILabel!
    @IBOutlet weak var detectionByShipLabel: UILabel!
    @IBOutlet weak var concealmentColour: UIImageView!
    // MARK: Battle Range
    @IBOutlet weak var battleRangeLabel: UILabel!
    @IBOutlet weak var battleRangeColour: UIImageView!
    // MARK: Torpodoes
    @IBOutlet weak var torpLabel: UILabel!
    @IBOutlet weak var torpNameLabel: UILabel!
    @IBOutlet weak var torpDamageLabel: UILabel!
    @IBOutlet weak var torpReloadLabel: UILabel!
    @IBOutlet weak var torpDistanceLabel: UILabel!
    @IBOutlet weak var torpSpeedLabel: UILabel!
    @IBOutlet weak var torpDecectionLabel: UILabel!
    @IBOutlet weak var torpedoesColour: UIImageView!
    // MARK: Mobility
    @IBOutlet weak var mobilityLabel: UILabel!
    @IBOutlet weak var mobilityColour: UIImageView!
    // MARK: Anti Aricraft
    @IBOutlet weak var antiAircraftLabel: UILabel!
    @IBOutlet weak var antiAircraftColour: UIImageView!
    // MARK: Aircraft
    @IBOutlet weak var flightLabel: UILabel!
    @IBOutlet weak var flightColour: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Load module tree and some other basic information
        print("Getting Module Tree")
        Ships(shipID: shipID).getBasicInformation { (ship) in
            DispatchQueue.main.async {
                // Module tree for this ship
                self.moduleTree = Ships.getModuleTree(data: ship)
                
                // Some information that never changes
                self.descriptionText = ship["description"].stringValue
                self.nationText = ship["nation"].stringValue.uppercased()
                let isPrenium = ship["is_premium"].boolValue
                
                // Ship Tier
                let tierSymbol = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
                var tierLabel = "Tier " + tierSymbol[Int(self.shipTier)! - 1]
                if isPrenium {
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
                
                // Battle range
                self.battleRangeLabel.text = "\(ship["default_profile"]["battle_level_range_min"]) - \(ship["default_profile"]["battle_level_range_max"])"
            }
        }
    }
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
        // Add a button to visit official wiki
        let wiki = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(visitWiki))
        self.navigationItem.rightBarButtonItem = wiki
        
        // Setup basic information
        self.title = shipID
        self.shipImage.sd_setImage(with: URL(string: imageURL)!)
        self.shipTypeImage.image = Shipinformation.getImageWithType(type: shipType)
        self.shipNameLabel.text = shipName
        
        // Setup Theme
        setupTheme()
        // Load Default Data (All Empty)
        updateModule()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Button Pressed
    @IBAction func moduleBtnPressed(_ sender: UIButton) {
        // Differentiate Buttons by tag (Tag also indicates type)
        let index = sender.tag
        let count = moduleTree[index].count
        if count > 1 {
            let moduleSelection = UIAlertController(title: "", message: "", preferredStyle: .alert)
            
            for i in 0 ..< moduleTree[index].count {
                // Index 0 is name
                moduleSelection.addAction(UIAlertAction(title: moduleTree[index][i][0], style: .default, handler: { (Action) in
                    // Index 1 is ID
                    self.currModule[index] = self.moduleTree[index][i][1]
                    UIView.animate(withDuration: 0.5, animations: { 
                        self.labelControl(state: 0)
                    })
                    self.updateModule()
                }))
            }
            self.present(moduleSelection, animated: true, completion: nil)
        }
    }
    
    // MARK: Update Data
    func updateModule() {
        Ships(shipID: shipID).getUpdatedInformation(hull: currModule[0], engine: currModule[1], torpedoes: currModule[2], fireControl: currModule[3], artillery: currModule[4], flightControl: currModule[5]) { (ship) in
            DispatchQueue.main.async {
                // Detailed Information
                self.healthLabel.text = ship["armour"]["health"].stringValue
                self.floodProtectionLabel.text = "\(ship["armour"]["flood_prob"])%"
                
                // If this ship has guns
                if ship["artillery"] != JSON.null {
                    self.shotDelayLabel.text = "\(String(format: "%.2f", 60 / ship["artillery"]["gun_rate"].doubleValue)) s"
                    self.gunNameLabel.text = ship["artillery"]["slots"]["0"]["name"].stringValue
                    
                    // Update Gun
                    var gunText = ""
                    for gun in ship["artillery"]["slots"] {
                        gunText += "\(gun.1["guns"]) x \(gun.1["barrels"])"
                        if Int(gun.0) != ship["artillery"]["slots"].count - 1 {
                            gunText += " | "
                        }
                    }
                    self.gunLabel.text = gunText
                    
                    // If this ship have AP
                    if ship["artillery"]["shells"]["AP"] != JSON.null {
                        self.APDamageLabel.text = ship["artillery"]["shells"]["AP"]["damage"].stringValue
                        self.APSpeedLabel.text = "\(ship["artillery"]["shells"]["AP"]["bullet_speed"]) m/s"
                    }
                    
                    // If this ship have HE
                    if ship["artillery"]["shells"]["HE"] != JSON.null {
                        self.HEDamageLabel.text = ship["artillery"]["shells"]["HE"]["damage"].stringValue
                        self.fireLabel.text = "🔥\(ship["artillery"]["shells"]["HE"]["burn_probability"])%"
                        self.HESpeedLabel.text = "\(ship["artillery"]["shells"]["HE"]["bullet_speed"]) m/s"
                    }
                    self.fireDistanceLabel.text = String(format: "%0.2f", ship["artillery"]["distance"].doubleValue) + " km"
                }
                
                self.detectionByPlaneLabel.text = "\(ship["concealment"]["detect_distance_by_plane"]) km"
                self.detectionByShipLabel.text = "\(String(format: "%.1f", ship["concealment"]["detect_distance_by_ship"].doubleValue)) km"
                
                // If this ship have torp
                if ship["torpedoes"] != JSON.null {
                    self.torpNameLabel.text = ship["torpedoes"]["torpedo_name"].stringValue
                    self.torpReloadLabel.text = "\(ship["torpedoes"]["reload_time"]) s"
                    self.torpSpeedLabel.text = "\(ship["torpedoes"]["torpedo_speed"]) knot"
                    self.torpDamageLabel.text = ship["torpedoes"]["max_damage"].stringValue
                    self.torpDecectionLabel.text = "\(ship["torpedoes"]["visibility_dist"]) km"
                    self.torpDistanceLabel.text = "\(ship["torpedoes"]["distance"]) km"
                    
                    // Update Torpedoes
                    var torpText = ""
                    for torp in ship["torpedoes"]["slots"] {
                        torpText += "\(torp.1["guns"]) x \(torp.1["barrels"])"
                        if Int(torp.0) != ship["torpedoes"]["slots"].count - 1 {
                            torpText += " | "
                        }
                    }
                    self.torpLabel.text = torpText
                }
                
                self.mobilityLabel.text = "\(ship["mobility"]["max_speed"]) knot | \(ship["mobility"]["turning_radius"]) m | \(ship["mobility"]["rudder_time"]) s"
                
                // Update Status Label
                self.survivabilityLabel.text = ship["armour"]["total"].stringValue
                self.artilleryLabel.text = ship["weaponry"]["artillery"].stringValue
                self.torpedoesLabel.text = ship["weaponry"]["torpedoes"].stringValue
                self.AALabel.text = ship["weaponry"]["anti_aircraft"].stringValue
                self.maneuverbilityLabel.text = ship["mobility"]["total"].stringValue
                self.concealmentLabel.text = ship["concealment"]["total"].stringValue
                self.aircraftLabel.text = ship["weaponry"]["aircraft"].stringValue
                
                // Update Status Bar
                self.survivabilityBar.progress = Float(ship["armour"]["total"].doubleValue / 100)
                self.artilleryBar.progress = Float(ship["weaponry"]["artillery"].doubleValue / 100)
                self.torpedoesBar.progress = Float(ship["weaponry"]["torpedoes"].doubleValue / 100)
                self.AABar.progress = Float(ship["weaponry"]["anti_aircraft"].doubleValue / 100)
                self.maneuverbilityBar.progress = Float(ship["mobility"]["total"].doubleValue / 100)
                self.concealmentBar.progress = Float(ship["concealment"]["total"].doubleValue / 100)
                self.aircraftBar.progress = Float(ship["weaponry"]["aircraft"].doubleValue / 100)
                
                // If this is a cv
                if ship["flight_control"] != JSON.null {
                    self.flightLabel.text = "\(ship["hull"]["planes_amount"]) (\(ship["flight_control"]["fighter_squadrons"]) - \(ship["flight_control"]["torpedo_squadrons"]) - \(ship["flight_control"]["bomber_squadrons"]))"
                }
                
                // Update AA
                var AAText = ""
                for AA in ship["anti_aircraft"]["slots"] {
                    AAText += "\(AA.1["distance"]) km  |  \(String(format: "%3d", AA.1["caliber"].intValue)) mm  |  \(String(format: "%3d", AA.1["avg_damage"].intValue))"
                    if Int(AA.0) != ship["anti_aircraft"]["slots"].count - 1 {
                        AAText += "\n"
                    }
                }
                self.antiAircraftLabel.text = AAText
                
                // Update label alpha
                UIView.animate(withDuration: 0.5, animations: {
                    self.labelControl(state: 1.0)
                })
            }
        }
    }
    
    func labelControl(state: CGFloat) {
        // Change Alpha
        survivabilityBar.alpha = state
        artilleryBar.alpha = state
        torpedoesBar.alpha = state
        AABar.alpha = state
        maneuverbilityBar.alpha = state
        concealmentBar.alpha = state
        artilleryBar.alpha = state
        moneyTypeImage.alpha = state
        survivabilityLabel.alpha = state
        artilleryLabel.alpha = state
        torpedoesLabel.alpha = state
        AALabel.alpha = state
        maneuverbilityLabel.alpha = state
        concealmentLabel.alpha = state
        moneyLabel.alpha = state
        shipTierLabel.alpha = state
        healthLabel.alpha = state
        floodProtectionLabel.alpha = state
        aircraftLabel.alpha = state
        shotDelayLabel.alpha = state
        gunLabel.alpha = state
        gunNameLabel.alpha = state
        fireLabel.alpha = state
        APDamageLabel.alpha = state
        APSpeedLabel.alpha = state
        HEDamageLabel.alpha = state
        HESpeedLabel.alpha = state
        fireDistanceLabel.alpha = state
        detectionByPlaneLabel.alpha = state
        detectionByShipLabel.alpha = state
        battleRangeLabel.alpha = state
        torpLabel.alpha = state
        torpNameLabel.alpha = state
        torpDamageLabel.alpha = state
        torpReloadLabel.alpha = state
        torpDistanceLabel.alpha = state
        torpSpeedLabel.alpha = state
        torpDecectionLabel.alpha = state
        mobilityLabel.alpha = state
        antiAircraftLabel.alpha = state
        flightLabel.alpha = state
    }
    
    // MARK: Theme
    func setupTheme() {
        // I hope there wont be any crazy combinations
        shuffleColour()
        
        // Setup Colour
        setupBackground(view: moduleColour, index: 0)
        setupBackground(view: statusColour, index: 1)
        setupBackground(view: armourColour, index: 2)
        setupBackground(view: artilleryColour, index: 3)
        setupBackground(view: torpedoesColour, index: 4)
        setupBackground(view: antiAircraftColour, index: 5)
        setupBackground(view: battleRangeColour, index: 6)
        setupBackground(view: mobilityColour, index: 7)
        setupBackground(view: concealmentColour, index: 8)
        setupBackground(view: flightColour, index: 9)
        
        // Setup Buttons
        setupBtn(btn: hullBtn)
        setupBtn(btn: torpBtn)
        setupBtn(btn: engineBtn)
        setupBtn(btn: artilleryBtn)
        setupBtn(btn: fireControlBtn)
        setupBtn(btn: flightControlBtn)
    }
    
    func shuffleColour() {
        // Randomise theme colour
        for i in 0 ..< 11 {
            let number = Int(arc4random() % 11)
            // Swap them
            let temp = ColourGroup[number]
            ColourGroup[number] = ColourGroup[i]
            ColourGroup[i] = temp
        }
    }
    
    func setupBackground(view: UIImageView, index: Int) {
        // Backgroun colour
        view.backgroundColor = ColourGroup[index]
        // Corner Radius
        view.layer.cornerRadius = 10.0
        view.layer.masksToBounds = true
    }
    
    func setupBtn(btn: UIButton) {
        btn.layer.borderWidth = 1.5
        btn.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: Wiki Btn
    func visitWiki() {
        // Remove weird symbols
        let wikiShipName = "http://wiki.wargaming.net/en/Ship:\(String(describing: shipName.replacingOccurrences(of: " ", with: "_").addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!))"
        print(wikiShipName)
        // Try to make it a Url
        if let name = URL(string: wikiShipName) {
            let wiki = SFSafariViewController(url: name)
            wiki.modalPresentationStyle = .overFullScreen
            UIApplication.shared.statusBarStyle = .default
            self.present(wiki, animated: true, completion: nil)
        }
    }
    
    // MARK: Safari
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange status bar colour back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Description
    @IBAction func showDescriptionPressed(_ sender: Any) {
        let description = UIAlertController.QuickMessage(title: "\(shipName!) (\(nationText!))", message: descriptionText, cancel: "OK")
        self.present(description, animated: true, completion: nil)
    }
    
}

/*
 @IBOutlet weak var armourTopConstraint: NSLayoutConstraint!
 @IBOutlet weak var scrollView: UIScrollView!
 @IBOutlet weak var scrollviewView: UIView!
 
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Load a button in Navigation bar
 screenshotBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takeScreenshot))
 screenshotBtn.isEnabled = false
 self.navigationItem.rightBarButtonItem = screenshotBtn
 
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
 
 AudioServicesPlaySystemSound(1520)
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
*/
