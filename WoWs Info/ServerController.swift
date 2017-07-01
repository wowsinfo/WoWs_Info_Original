//
//  ServerController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ServerController : UITableViewController {
    
    let Server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
    let ServerName = ["RU".localised(), "EU".localised(), "NA".localised(), "ASIA".localised()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Save the index
        UserDefaults.standard.set(indexPath.row, forKey: DataManagement.DataName.Server)
        // Go back to Settings
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let index  = indexPath.row
        
        cell.textLabel?.text = ServerName[index]
        if index == Server {
            // Change server cell colour
            cell.backgroundColor = Theme.getCurrTheme()
            cell.textLabel?.textColor = UIColor.white
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ServerName.count
    }
}
