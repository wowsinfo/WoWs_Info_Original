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
    @IBOutlet weak var sortBtn: UIButton!
    var shipData = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup TableView
        shipTable.delegate = self
        shipTable.dataSource = self
        shipTable.separatorColor = UIColor.clear
        // Setup Button
        sortBtn.backgroundColor = Theme.getCurrTheme()
        // Setup Title
        self.title = "\(shipData.count)艘战舰"
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
        var rank = shipData[index][ChineseServer.ShipDataIndex.rank]
        if rank == "0" { rank = "无" }
        cell.rankLabel.text = rank
        cell.damageLabel.text = shipData[index][ChineseServer.ShipDataIndex.damage]
        cell.winrateLabel.text = shipData[index][ChineseServer.ShipDataIndex.winrate]
        cell.expLabel.text = shipData[index][ChineseServer.ShipDataIndex.exp]
        cell.fragLabel.text = shipData[index][ChineseServer.ShipDataIndex.frag]
        cell.killDeathLabel.text = shipData[index][ChineseServer.ShipDataIndex.killDeath]
        cell.shipImage.sd_setImage(with: URL(string: shipData[index][ChineseServer.ShipDataIndex.shipImage])!)
        cell.nameLabel.text = shipData[index][ChineseServer.ShipDataIndex.shipTierName]
        // Setup Personal Rating
        let ratingIndex = Int(shipData[index][ChineseServer.ShipDataIndex.rating].components(separatedBy: "|").last!)!
        cell.prLabel.textColor = PersonalRating.ColorGroup[ratingIndex]
        cell.prLabel.text = PersonalRating.Comment[ratingIndex]

        // Set up a border colour
        cell.contentView.layer.borderWidth = 1.25
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.layoutMargins = UIEdgeInsetsMake(10, 10, 10, 10)
        cell.contentView.layer.borderColor = Theme.getCurrTheme().cgColor
        
        return cell
    }
    
    // MARK: Button Pressed
    @IBAction func sortBtnPressed(_ sender: Any) {
        let sort = UIAlertController(title: "排序", message: "选择战舰排列顺序", preferredStyle: .actionSheet)
        sort.addAction(UIAlertAction(title: "战舰排名", style: .default, handler: { (action) in
            // Sort array
            self.shipData.sort(by: {
                let rankIndex = ChineseServer.ShipDataIndex.rank
                var first = Int($0[rankIndex])!
                if first == 0 { first = 99999 }
                var second = Int($1[rankIndex])!
                if second == 0 { second = 99999 }
                return first < second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "战斗数", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let battleIndex = ChineseServer.ShipDataIndex.battle
                let first = Int($0[battleIndex].components(separatedBy: " ").first!)!
                let second = Int($1[battleIndex].components(separatedBy: " ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "胜率", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let winrateIndex = ChineseServer.ShipDataIndex.winrate
                let first = Double($0[winrateIndex].components(separatedBy: "% ").first!)!
                let second = Double($1[winrateIndex].components(separatedBy: "% ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "经验", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let expIndex = ChineseServer.ShipDataIndex.exp
                let first = Int($0[expIndex].components(separatedBy: " ").first!)!
                let second = Int($1[expIndex].components(separatedBy: " ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "伤害", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let damageIndex = ChineseServer.ShipDataIndex.damage
                let first = Int($0[damageIndex].components(separatedBy: " ").first!)!
                let second = Int($1[damageIndex].components(separatedBy: " ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "杀死比", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let killDeathIndex = ChineseServer.ShipDataIndex.killDeath
                let first = Double($0[killDeathIndex].components(separatedBy: " ").first!)!
                let second = Double($1[killDeathIndex].components(separatedBy: " ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "平均击杀", style: .default, handler: { (action) in
            self.shipData.sort(by: {
                let killIndex = ChineseServer.ShipDataIndex.frag
                let first = Double($0[killIndex].components(separatedBy: " ").first!)!
                let second = Double($1[killIndex].components(separatedBy: " ").first!)!
                return first > second
            })
            self.updateData()
        }))
        sort.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        sort.popoverPresentationController?.sourceView = self.view
        sort.modalPresentationStyle = .overFullScreen
        self.present(sort, animated: true, completion: nil)
    }
    
    func updateData() {
        // Scroll to top
        self.shipTable.setContentOffset(CGPoint.zero, animated: true)
        // Reload data
        self.shipTable.reloadData()
    }
    

}
