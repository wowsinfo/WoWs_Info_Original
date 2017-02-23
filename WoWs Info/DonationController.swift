//
//  DonationController.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class DonationController: UIViewController {

    var tag: Int!
    @IBOutlet weak var saveImageBtn: UIButton!
    @IBOutlet weak var QRImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tag == 11 {
            QRImage.image = #imageLiteral(resourceName: "Alipay")
        } else if tag == 12 {
            QRImage.image = #imageLiteral(resourceName: "Wechat")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func saveToAlbum(_ sender: UIButton) {
        
        // Save to camera roll
        UIImageWriteToSavedPhotosAlbum(self.QRImage.image!, nil, nil, nil)
        
        let alert = UIAlertController(title: ">_<", message: NSLocalizedString("THX_SUPPORT", comment: "Thank you label"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        UIView.animate(withDuration: 0.3) {
            self.saveImageBtn.alpha = 0
            self.saveImageBtn.isHidden = true
        }
        
    }

}
