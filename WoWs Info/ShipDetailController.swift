//
//  ShipDetailController.swift
//  WoWs Info
//
//  Created by Henry Quan on 26/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage

class ShipDetailController: UIViewController {

    var shipID: String!
    var imageURL: String!
    var shipType: String!
    var shipName: String!
    var shipTier: String!
    
    @IBOutlet weak var shipTypeImage: UIImageView!
    @IBOutlet weak var shipImage: UIImageView!
    @IBOutlet weak var shipNameLabel: UILabel!
    @IBOutlet weak var shipTierLabel: UILabel!
    @IBOutlet weak var shipDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tierSymbol = ["I","II","III","IV","V","VI","VII","VIII","IX","X"]
        self.title = shipID
        self.shipImage.sd_setImage(with: URL(string: imageURL)!)
        self.shipTypeImage.image = Shipinformation.getImageWithType(type: shipType)
        self.shipNameLabel.text = shipName
        self.shipTierLabel.text = "Tier " + tierSymbol[Int(shipTier)! - 1]

        // Show all data
        self.loadData()
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseIn, animations: { 
            self.shipDescription.alpha = 1.0
        }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData() {
        Ships(shipID: shipID).getShipJson { (ship) in
            DispatchQueue.main.async {
                print(ship)
                self.shipDescription.text = ship["description"].stringValue
                self.shipDescription.isScrollEnabled = false
                self.shipDescription.sizeToFit()
            }
        }
        
    }

}
