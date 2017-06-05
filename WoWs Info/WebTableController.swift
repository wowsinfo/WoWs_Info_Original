//
//  WebTableController.swift
//  WoWs Info
//
//  Created by Henry Quan on 21/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SafariServices

class WebTableController: UITableViewController, SFSafariViewControllerDelegate {

    
    let website = ["https://worldofwarships.com/", "http://wiki.wargaming.net/en/World_of_Warships", "https://warships.today/", "http://wows-numbers.com/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/20170422/asia_2month/ranking_clan.html", "https://sea-group.org//", "http://aslain.com/index.php?/topic/2020-06301-aslains-wows-modpack-installer-wpicture-preview/", "https://github.com/HenryQuan/WOWS_TrainingRoom", "https://github.com/HenryQuan/WoWs_Real"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange it back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Go to certain website according to tag
        let tag = tableView.cellForRow(at: indexPath)?.tag
        if tag! > 0 {
            let website = SFSafariViewController(url: URL(string: self.website[tag! - 1])!)
            website.modalPresentationStyle = .overFullScreen
            website.delegate = self
            // Change it to black
            UIApplication.shared.statusBarStyle = .default
            self.present(website, animated: true, completion: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)

    }

}
