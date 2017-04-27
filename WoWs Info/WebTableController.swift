//
//  WebTableController.swift
//  WoWs Info
//
//  Created by Henry Quan on 21/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class WebTableController: UITableViewController {

    
    let website = ["https://worldofwarships.com/", "http://wiki.wargaming.net/en/World_of_Warships", "https://warships.today/", "http://wows-numbers.com/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/", "https://sea-group.org//", "http://aslain.com/index.php?/topic/2020-06301-aslains-wows-modpack-installer-wpicture-preview/", "https://github.com/HenryQuan/WOWS_TrainingRoom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Go to certain website according to tag
        let tag = tableView.cellForRow(at: indexPath)?.tag
        if tag! > 0 {
            UIApplication.shared.openURL(URL(string: website[tag! - 1])!)
        }
        tableView.reloadData()

    }

}
