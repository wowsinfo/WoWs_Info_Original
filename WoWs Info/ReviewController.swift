//
//  ReviewController.swift
//  WoWs Info
//
//  Created by Henry Quan on 13/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import MessageUI

class ReviewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundBtn(btn: shareBtn)
        roundBtn(btn: reviewBtn)
        roundBtn(btn: emailBtn)
        roundBtn(btn: twitterBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func roundBtn(btn: UIButton) {
        btn.layer.cornerRadius = btn.frame.height / 2
        // Update theme
        btn.backgroundColor = Theme.getCurrTheme()
    }
    
    @IBAction func shareBtnPressed(_ sender: Any) {
        // Share with friends
        let share = UIActivityViewController.init(activityItems: [URL(string: "https://itunes.apple.com/app/id1202750166")!], applicationActivities: nil)
        self.present(share, animated: true, completion: nil)
    }
    
    @IBAction func reviewBtnPressed(_ sender: Any) {
        // Review
        UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1202750166&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
    }
    
    @IBAction func emailBtnPressed(_ sender: Any) {
        // Email
        if MFMailComposeViewController.canSendMail() {
            sendEmail()
        } else {
            showAlert(title: NSLocalizedString("EMAIL_TITLE", comment: "Error label"), message: NSLocalizedString("EMAIL_MESSAGE", comment: "Email label"), button: "OK")
        }
    }
    
    @IBAction func twitterBtnPressed(_ sender: Any) {
        // Go to my twitter account
        UIApplication.shared.openURL(URL(string: "https://twitter.com/Yiheng_Quan")!)
    }
    
    func showAlert(title: String, message: String, button: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func sendEmail() {
        
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["development.henryquan@gmail.com"])
        mailVC.setSubject("[WoWs Info] ")
        mailVC.setMessageBody("", isHTML: false)
        
        // Change button colour on mailVC
        mailVC.navigationBar.tintColor = UIColor.white
        present(mailVC, animated: true) {
            // Set it to be white
            UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        }
        
    }
    
    // To dismiss the controller
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
