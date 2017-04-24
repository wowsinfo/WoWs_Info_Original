//
//  ClanInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 24/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ClanInfoController: UITableViewController {

    var clanDataString: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        if indexPath.row == 0 {
            // First cell is gonna be  ClanCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ClanCell", for: indexPath) as! ClanCell

        } else {
            // Member list
            cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell

        }
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked) == true {
            // Only segue for pro users
            
        }
    }

}
