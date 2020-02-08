//
//  ServerStatusController.swift
//  WoWs Info
//
//  Created by Henry Quan on 21/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ServerStatusController: UIViewController {

    @IBOutlet weak var naLabel: UILabel!
    @IBOutlet weak var euLabel: UILabel!
    @IBOutlet weak var ruLabel: UILabel!
    @IBOutlet weak var asiaLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Back Button
        let back = UIBarButtonItem(title: "BACK".localised(), style: .done, target: self, action: #selector(dismissController))
        self.navigationItem.leftBarButtonItem = back
        
        // Setup Theme
        setupTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Alpha -> 0 for all labels
        alphaControl(status: 0)
        // For all servers
        getAndLoadServerInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Theme
    func setupTheme() {
        let theme = Theme.getCurrTheme()
        self.naLabel.textColor = theme
        self.euLabel.textColor = theme
        self.ruLabel.textColor = theme
        self.asiaLabel.textColor = theme
        self.totalLabel.textColor = theme
    }
    
    // MARK: Dismiss
    @objc func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Getting data
    func getAndLoadServerInfo() {
        // Game Version
        ServerStatus.getServerVersion { (version) in
            DispatchQueue.main.async {
                self.title = version
            }
        }
        
        // Server Status
        ServerStatus.getPlayerOnline { (player) in
            print("Total: \(player)")
            if player.count == 4 {
                var totalOnline = 0
                for server in player {
                    totalOnline += Int(server)!
                }
                
                DispatchQueue.main.async {
                    self.naLabel.text = player[0]
                    self.euLabel.text = player[1]
                    self.ruLabel.text = player[2]
                    self.asiaLabel.text = player[3]
                    self.totalLabel.text = "\(totalOnline)"
                    UIView.animate(withDuration: 0.5) {
                        self.alphaControl(status: 1)
                    }
                }
            }
        }
    }
    
    // Mark: Control Alpha
    func alphaControl(status: CGFloat) {
        self.naLabel.alpha = status
        self.euLabel.alpha = status
        self.ruLabel.alpha = status
        self.asiaLabel.alpha = status
        self.totalLabel.alpha = status

    }

}
