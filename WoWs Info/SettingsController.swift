//
//  SettingsController.swift
//  WoWs Info
//
//  Created by Henry Quan on 30/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import MessageUI

class SettingsController : UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var silderCountLabel: UILabel!
    @IBOutlet weak var limitSlider: UISlider!
    
    let website = ["https://worldofwarships.com/", "http://wiki.wargaming.net/en/World_of_Warships", "https://warships.today/", "http://wows-numbers.com/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/"]
    let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let limit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        silderCountLabel.text = "\(limit)"
        limitSlider.setValue(Float(limit), animated: true)
        
        let name = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)
        username.text = name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        UserDefaults.standard.set(Int(limitSlider.value), forKey: DataManagement.DataName.SearchLimit)
        
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        
        let name = username.text
        let validName = name?.replacingOccurrences(of: " ", with: "")
        
        if validName != "" {
            UserDefaults.standard.set(validName, forKey: DataManagement.DataName.UserName)
        }

        username.resignFirstResponder()
        
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        
        let value = Int(limitSlider.value)
        silderCountLabel.text = "\(value)"
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Go to a certain website according to tag
        let selectedCell = tableView.cellForRow(at: indexPath)
        let tag = (selectedCell?.tag)!
        
        if tag > 0 && tag <= 5 {
            UIApplication.shared.openURL(URL(string: website[tag - 1])!)
        } else if tag == 10 {
            // Donate through Paypal
            UIApplication.shared.openURL(URL(string: "https://www.paypal.me/YihengQuan/")!)
            
            // Thank user for supporting me
            showAlert(title: ">_<", message: "Thank you for your support", button: "OK")
        } else if tag == 20 {
            // Send email to me
            if MFMailComposeViewController.canSendMail() {
                sendEmail()
            } else {
                showAlert(title: "Error", message: "Cannot send an Email right now", button: "OK")
            }
        } else if tag == 21 {
            // Write a review
            UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1202750166&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8")!)
        } else if tag == 22 {
            // Share with friends
            let share = UIActivityViewController.init(activityItems: ["\n\nPlayer Information for World of Warships (https://itunes.apple.com/us/app/wows-info/id1202750166?ls=1&mt=8)", #imageLiteral(resourceName: "Icon")], applicationActivities: nil)
            self.present(share, animated: true, completion: nil)
        }
        
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
