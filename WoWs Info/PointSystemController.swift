//
//  PointSystemController.swift
//  WoWs Info
//
//  Created by Henry Quan on 9/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class PointSystemController: UIViewController {

    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var adBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var pointTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Theme
        setupTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Theme
    func setupTheme() {
        setupBtn(btn: adBtn)
        setupBtn(btn: reviewBtn)
        setupBtn(btn: shareBtn)
        
        // Setup pointlabel
        pointLabel.backgroundColor = Theme.getCurrTheme()
        pointLabel.layer.cornerRadius = view.frame.width * 0.1
        pointLabel.layer.masksToBounds = true
    }
    
    func setupBtn(btn: UIButton) {
        btn.layer.cornerRadius = view.frame.height * 0.02
        btn.layer.masksToBounds = true
        btn.backgroundColor = Theme.getCurrTheme()
    }

}
