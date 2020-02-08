//
//  CNSearchController.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SafariServices

class CNSearchController: UIViewController, UITextFieldDelegate , SFSafariViewControllerDelegate {

    @IBOutlet weak var playerTextField: UITextField!
    @IBOutlet weak var serverSwitch: UISwitch!
    @IBOutlet weak var topPlayerBtn: UIButton!
    @IBOutlet weak var pointLabel: UILabel!
    // Theme Colour
    let theme = Theme.getCurrTheme()
    let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Theme Colour
        setupTheme()
        self.title = "国服数据查询"
        
        // Setup TextField
        playerTextField.delegate = self
        
        // Hide point if user is pro
        if isPro {
            pointLabel.isHidden = true
        }
        
        // Add a back button
        let backBtn = UIBarButtonItem(title: "BACK".localised(), style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItem = backBtn
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let currPoint = PointSystem.getCurrPoint()
        pointLabel.text = "点数: \(currPoint)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "gotoCNPlayer" {
            let destination = segue.destination as! CNPlayerController
            destination.playerData = sender as! [String]
        }
    }
    
    @objc func goBack() {
        // Go BACK >_<
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let tabbar = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        tabbar.modalTransitionStyle = .flipHorizontal
        tabbar.modalPresentationStyle = .fullScreen
        self.present(tabbar, animated: true, completion: nil)
    }
    
    // MARK: Theme
    func setupTheme() {
        serverSwitch.tintColor = theme
        serverSwitch.onTintColor = theme
        topPlayerBtn.setTitleColor(theme, for: .normal)
    }
    
    // MARK: Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dimiss keyborad
        self.view.endEditing(true)
        
        if let player = playerTextField.text {
            // Disable Textfield
            playerTextField.isEnabled = false
            // Change title
            self.title = "搜索中..."
            
            if player == "" {
                // This is not valid
                let invalid = UIAlertController.QuickMessage(title: "提示", message: "请输入用户名", cancel: "好的")
                self.present(invalid, animated: true, completion: nil)
                // Change it back when user tries to search another play
                self.playerTextField.isEnabled = true
            } else {
                ChineseServer(player: player, server: self.getServerIndex()).getPlayerInformation(success: { (data) in
                    if data.count > 0 {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "gotoCNPlayer", sender: data)
                            
                            // Change it back when user tries to search another play
                            self.playerTextField.isEnabled = true
                        }
                    } else {
                        // No such player
                        let invalid = UIAlertController.QuickMessage(title: "提示", message: "玩家不存在或无记录", cancel: "好的")
                        self.present(invalid, animated: true, completion: nil)
                        
                        DispatchQueue.main.async {
                            // Change it back when user tries to search another play
                            self.playerTextField.isEnabled = true
                        }
                    }
                })
            }
            self.title = "国服数据查询"
        }
        
        return true
    }
    
    // MARK: Helper functions
    func getServerIndex() -> Int {
        if serverSwitch.isOn {
            return ChineseServer.ServerIndex.south
        } else {
            return ChineseServer.ServerIndex.north
        }
    }
    
    // MARK: Button Pressed
    @IBAction func topPlayerBtnPressed(_ sender: Any) {
        let topPlayer = SFSafariViewController(url: URL(string: "http://rank.kongzhong.com/wows/topplayer.html")!)
        topPlayer.modalPresentationStyle = .overFullScreen
        topPlayer.delegate = self
        UIApplication.shared.statusBarStyle = .default
        self.present(topPlayer, animated: true, completion: nil)
    }

    @IBAction func topShipBtnPressed(_ sender: Any) {
        let topShip = SFSafariViewController(url: URL(string: "http://rank.kongzhong.com/wows/shiptop.html")!)
        topShip.delegate = self
        topShip.modalPresentationStyle = .overFullScreen
        UIApplication.shared.statusBarStyle = .default
        self.present(topShip, animated: true, completion: nil)
    }
    
    // MARK: Safari
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange status bar colour back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }
    
}
