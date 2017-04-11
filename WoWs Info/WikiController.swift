//
//  WikiController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class WikiController: UITableViewController {

    let name = [NSLocalizedString("ACHIEVEMENT", comment: "Achievement"), NSLocalizedString("WARSHIPS", comment: "Warships"), NSLocalizedString("UPGRADES", comment: "Upgrades"), NSLocalizedString("FLAGS", comment: "Flags"), NSLocalizedString("CAMOUFLAGE", comment: "Camouflage"), NSLocalizedString("COMMANDER_SKILL", comment: "CommanderSkill")]
    let identifier = ["gotoAchievement", "gotoWarships", "gotoWikiData"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiCell", for: indexPath) as! WikiCell
        cell.wikiTextLabel.text = name[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 1 {
            performSegue(withIdentifier: identifier[2], sender: indexPath.row - 2)
        } else {
            performSegue(withIdentifier: identifier[indexPath.row], sender: nil)
        }
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoWikiData" {
            // We have to send seme data
            let destination = segue.destination as! WikiDataController
            destination.dataType = sender as! Int
        }
    }
    
}
