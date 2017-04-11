//
//  WikiDataController.swift
//  WoWs Info
//
//  Created by Henry Quan on 6/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage

class WikiDataController: UITableViewController {

    var dataType: Int!
    var dataString = [[String]]()
    
    let upgrade = 0;
    let flag = 1;
    let camouflage = 2;
    let skill = 3;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Automatic resizing
        self.tableView.separatorColor = UIColor.clear
        self.tableView.estimatedRowHeight = 200.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // Get data according to dateType
        switch dataType {
            // Gonna do all these 4 in one viewcontroller
            case upgrade:
                dataString = Upgrade.getUpgradeInformation()
                // Sort by price
                dataString.sort(by: {Int($0[Upgrade.dataIndex.price])! < Int($1[Upgrade.dataIndex.price])!})
                break
            case flag:
                print("01")
                break
            case camouflage:
                print("012")
                break
            case skill:
                print("0123")
                break
            default:
                break
        }
        
        self.title = "\(dataString.count)"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataString.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiDataCell", for: indexPath) as! WikiDataCell
        cell.upgradeIdLabel.text = dataString[indexPath.row][Upgrade.dataIndex.id]
        cell.upgradeNameLabel.text = dataString[indexPath.row][Upgrade.dataIndex.name]
        cell.upgradeImage.sd_setImage(with: URL(string: dataString[indexPath.row][Upgrade.dataIndex.image])!)
        cell.upgradePriceLabel.text = dataString[indexPath.row][Upgrade.dataIndex.price]
        cell.upgradeDescriptionLabel.text = dataString[indexPath.row][Upgrade.dataIndex.description]
        return cell
    }

}
