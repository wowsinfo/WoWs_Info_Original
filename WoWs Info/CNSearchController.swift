//
//  CNSearchController.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class CNSearchController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var playerTextField: UITextField!
    @IBOutlet weak var serverSwitch: UISwitch!
    // Theme Colour
    let theme = Theme.getCurrTheme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Theme Colour
        setupTheme()
        self.title = "国服数据查询"
        
        // Setup TextField
        playerTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Change it back when user tries to search another play
        self.playerTextField.isEnabled = true
        self.title = "国服数据查询"
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
    
    // MARK: Theme
    func setupTheme() {
        serverSwitch.tintColor = theme
        serverSwitch.onTintColor = theme
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
            } else {
                ChineseServer(player: player, server: self.getServerIndex()).getPlayerInformation(success: { (data) in
                    if data.count > 0 {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "gotoCNPlayer", sender: data)
                        }
                    } else {
                        // No such player
                        let invalid = UIAlertController.QuickMessage(title: "提示", message: "玩家不存在或无记录", cancel: "好的")
                        self.present(invalid, animated: true, completion: nil)
                    }
                })
            }
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
    
}
