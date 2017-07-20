//
//  CNShipCell.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class CNShipCell: UITableViewCell {

    @IBOutlet weak var shipImage: UIImageView!
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var battleLabel: UILabel!
    @IBOutlet weak var winrateLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    @IBOutlet weak var killDeathLabel: UILabel!
    @IBOutlet weak var fragLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    
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
