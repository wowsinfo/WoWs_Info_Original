//
//  CNShipController.swift
//  WoWs Info
//
//  Created by Henry Quan on 11/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage

class CNShipController: UIViewController ,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var shipTable: UITableView!
    var shipData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        shipTable.delegate = self
        shipTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shipData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = shipTable.dequeueReusableCell(withIdentifier: "CNShipCell", for: indexPath) as! CNShipCell
        
        let index = indexPath.row
        cell.typeImage.image = Shipinformation.getImageWithType(type: shipData[index][ChineseServer.ShipDataIndex.shipType])
        cell.battleLabel.text = shipData[index][ChineseServer.ShipDataIndex.battle]
        cell.rankLabel.text = shipData[index][ChineseServer.ShipDataIndex.rank]
        cell.damageLabel.text = shipData[index][ChineseServer.ShipDataIndex.damage]
        cell.winrateLabel.text = shipData[index][ChineseServer.ShipDataIndex.winrate]
        cell.expLabel.text = shipData[index][ChineseServer.ShipDataIndex.exp]
        cell.fragLabel.text = shipData[index][ChineseServer.ShipDataIndex.frag]
        cell.killDeathLabel.text = shipData[index][ChineseServer.ShipDataIndex.killDeath]
        cell.shipImage.sd_setImage(with: URL(string: shipData[index][ChineseServer.ShipDataIndex.shipImage])!)
        cell.nameLabel.text = shipData[index][ChineseServer.ShipDataIndex.shipTierName]

        // Set up a border colour
        cell.contentView.layer.borderWidth = 1.25
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        cell.contentView.layer.borderColor = Theme.getCurrTheme().cgColor
        
        return cell
    }

}
