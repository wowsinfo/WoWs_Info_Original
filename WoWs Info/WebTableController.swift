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

    var serverIndex = 0
    var website = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        serverIndex = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        let language = Language.getLanguageString(Mode: 0).replacingOccurrences(of: "&language=", with: "")
        website = ["https://worldofwarships.\(ServerUrl.Server[serverIndex])/", "http://wiki.wargaming.net/\(language)/World_of_Warships", "https://\(ServerUrl.TodayDomain[serverIndex]).warships.today/", "http://\(ServerUrl.NumberDomain[serverIndex])wows-numbers.com/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/", "http://maplesyrup.sweet.coocan.jp/wows/ranking/20170422/\(ServerUrl.TodayDomain[serverIndex])_2month/ranking_clan.html", "https://sea-group.org//", "http://aslain.com/index.php?/topic/2020-06301-aslains-wows-modpack-installer-wpicture-preview/", "https://github.com/HenryQuan/WOWS_TrainingRoom", "https://github.com/HenryQuan/WoWs_Real"]
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
