//
//  AdvancedInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 12/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class AdvancedInfoController: UIViewController {

    var playerInfo = [String]()
    var serverIndex = 0
    @IBOutlet weak var number: UIImageView!
    @IBOutlet weak var today: UIImageView!
    @IBOutlet weak var screenshot: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    let username = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)!
    
    @IBOutlet weak var setPlayerIDBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load player id into title
        self.title  = playerInfo[1]
        playerNameLabel.text = playerInfo[0]
        
        // Just to prevent user playing with that button...
        if username.range(of: playerInfo[1]) != nil {
            setPlayerIDBtn.isEnabled = false
        }
        
        // Get server index
        self.serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func setPlayerID(_ sender: UIBarButtonItem) {
        
        let playerID = self.title!
        let playerIDAndName = "\(playerNameLabel.text!)|\(playerID)"
        UserDefaults.standard.setValue(playerIDAndName, forKey: DataManagement.DataName.UserName)
        
        // Alert
        let alert = UIAlertController(title: "^_^", message: "Your name and ID are saved!\nYou could now use Dashboard", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        setPlayerIDBtn.isEnabled = false
        
    }
    
    @IBAction func visitNumber(_ sender: UITapGestureRecognizer) {
        
        print("Number")
        // Open World of Warships Number
        let number = ServerUrl(serverIndex: serverIndex).getUrlForNumber(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: number)
        
    }
    
    @IBAction func visitToday(_ sender: UITapGestureRecognizer) {
        
        print("Today")
        // Open World of Warships Today
        let today = ServerUrl(serverIndex: serverIndex).getUrlForToday(account: self.title!, name: playerNameLabel.text!)
        performSegue(withIdentifier: "gotoWebView", sender: today)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        // Go to PlayerInfoController
        let destination = segue.destination as! WebViewController
        destination.url = sender as! String
        
    }
 
    // Used to take a screenshot
    @IBAction func takeScreenShot(_ sender: UITapGestureRecognizer) {
     
        // Hide number and today and screenshot
        number.isHidden = true
        today.isHidden = true
        self.screenshot.isHidden = true
     
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
     
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
     
        // show number and today
        number.isHidden = false
        today.isHidden = false
 
    }
 
}
