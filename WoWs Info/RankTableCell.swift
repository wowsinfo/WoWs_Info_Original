//
//  RankTableCell.swift
//  WoWs Info
//
//  Created by Henry Quan on 16/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class RankTableCell: UITableViewCell {

    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var battlesLabel: UILabel!
    @IBOutlet weak var winRateLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var damageLabel: UILabel!
    
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
