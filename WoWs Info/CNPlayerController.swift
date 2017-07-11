//
//  CNPlayerController.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SafariServices

class CNPlayerController: UIViewController, SFSafariViewControllerDelegate {

    var playerData = [String]()
    var shipData = [[String]]()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var clanLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = playerData[ChineseServer.DataIndex.id]
        // Setup labels
        setupLabels()
        
        // Get Ship Info
        getShipData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem

        if segue.identifier == "gotoCNShipDetail" {
            let destination = segue.destination as! CNShipController
            destination.shipData = self.shipData
        }
    }
    
    // MARK: Data
    func setupLabels() {
        nameLabel.text = playerData[ChineseServer.DataIndex.nickname]
        
        // Some may not have a clan or rank
        let rank = playerData[ChineseServer.DataIndex.rank]
        if rank == "0" {
            rankLabel.text = "没有参加排位赛"
        } else { rankLabel.text = rank }
        let clan = playerData[ChineseServer.DataIndex.clan]
        if clan == "" {
            clanLabel.text = "无工会"
        } else { rankLabel.text = clan }
    }
    
    // MARK: Safari
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange status bar colour back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: Button pressed
    @IBAction func kongzhongBtnPressed(_ sender: Any) {
        let wiki = SFSafariViewController(url: URL(string: playerData[ChineseServer.DataIndex.website])!)
        wiki.modalPresentationStyle = .overFullScreen
        UIApplication.shared.statusBarStyle = .default
        self.present(wiki, animated: true, completion: nil)
    }
    
    @IBAction func shipInfoBtnPressed(_ sender: Any) {
        // Internet latency issue
        if shipData.count > 0 {
            performSegue(withIdentifier: "gotoCNShipDetail", sender: shipData)
        }
    }
    
    // MARK: Loading Ship Data
    func getShipData() {
        let shipData = ChineseServer(id: playerData[ChineseServer.DataIndex.id])
        shipData.getShipRank { (shipRank) in
            shipData.getShipInformation(rankJson: shipRank, success: { (shipInfo) in
                self.shipData = shipInfo
            })
        }
    }
    
}
