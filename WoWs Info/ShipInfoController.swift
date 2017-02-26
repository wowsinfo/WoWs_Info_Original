//
//  ShipInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 26/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage

class ShipInfoController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var shipCollection: UICollectionView!
    var allInfo = [[String]]()
    var ships = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shipCollection.delegate = self
        shipCollection.dataSource = self
        
        searchTextField.delegate = self
        
        // Make it fit on all devices
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        shipCollection.collectionViewLayout = layout
        
        allInfo = Ships.getShipInformation()
        ships = allInfo
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        filterShip()
        
        // Scroll to top
        DispatchQueue.main.async {
            self.shipCollection.setContentOffset(CGPoint.zero, animated: true)
        }
        
        return true
    }
    
    // MARK: Collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ships.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.shipCollection.dequeueReusableCell(withReuseIdentifier: "ShipCell", for: indexPath) as! ShipCell
        if let url = URL(string: ships[indexPath.row][Ships.dataIndex.image]) {
            // Sometimes it wont work properly
            cell.shipImage.sd_setImage(with: url)
        }
        
        cell.shipNameLabel.text = ships[indexPath.row][Ships.dataIndex.name]
        
        return cell
    }
    
    
    // In order to make it clean and tidy
    func filterShip() {
        
        let filterText = searchTextField.text!
        
        if filterText == "" {
            // Empty
            ships = allInfo
            DispatchQueue.main.async {
                self.shipCollection.reloadData()
            }
            return
        }
        
        // Clean it
        ships = [[String]]()
        
        if let tier = Int(filterText) {
            // Tier
            if tier > 0 && tier <= 10 {
                for ship in allInfo {
                    if Int(ship[Ships.dataIndex.tier]) == tier {
                        ships.append(ship)
                    }
                }
            }
        } else {
            for ship in allInfo {
                switch filterText {
                case "dd":
                    if ship[Ships.dataIndex.type] == "Destroyer" {
                        ships.append(ship)
                    }
                case "bb":
                    if ship[Ships.dataIndex.type] == "Battleship" {
                        ships.append(ship)
                    }
                case "ca":
                    if ship[Ships.dataIndex.type] == "Cruiser" {
                        ships.append(ship)
                    }
                case "cv":
                    if ship[Ships.dataIndex.type] == "AirCarrier" {
                        ships.append(ship)
                    }
                default:
                    // Find ship with name
                    if ship[Ships.dataIndex.name].lowercased().contains(filterText.lowercased()) {
                        ships.append(ship)
                    }
                }
            }
        }
        
        // Update table now
        DispatchQueue.main.async {
            self.shipCollection.reloadData()
        }
        
    }
    

}
