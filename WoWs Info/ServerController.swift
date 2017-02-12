//
//  ServerController.swift
//  WoWs Info
//
//  Created by Henry Quan on 4/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ServerController : UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get tag from cell and save it
        let selectedCell = tableView.cellForRow(at: indexPath)
        let tag = (selectedCell?.tag)!
        UserDefaults.standard.set(tag, forKey: DataManagement.DataName.Server)
        
        print("Tag is \(tag)")
        
        // Go back to Settings
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
