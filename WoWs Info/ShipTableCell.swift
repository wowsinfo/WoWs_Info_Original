//
//  ShipTableCell.swift
//  WoWs Info
//
//  Created by Henry Quan on 17/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ShipTableCell: UITableViewCell {

    @IBOutlet weak var TierNameLabel: UILabel!
    @IBOutlet weak var battlesLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var shipTypeImage: UIImageView!
    @IBOutlet weak var shipRating: UILabel!

    // Change the frame
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (Optimised) {
            var frame =  Optimised
            frame.origin.x += 10
            frame.origin.y += 5
            frame.size.width -= 2 * 10
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }
    
    
    
}
