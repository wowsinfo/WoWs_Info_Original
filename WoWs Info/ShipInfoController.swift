//
//  ShipInfoController.swift
//  WoWs Info
//
//  Created by Henry Quan on 26/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage
import AudioToolbox

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
        let divider = CGFloat(Int(self.view.frame.width / 150) + 1)
        layout.itemSize = CGSize(width: self.view.frame.width / divider, height: self.view.frame.width / divider)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        shipCollection.collectionViewLayout = layout
        
        if Shipinformation.ShipJson == nil {
            _ = self.navigationController?.popToRootViewController(animated: true)
        } else {
            allInfo = Ships.getShipInformation(shipJson: Shipinformation.ShipJson)
            ships = allInfo
        }
        
        self.title = "\(allInfo.count)"
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
        if ships.count > 0 {
            if let url = URL(string: ships[indexPath.row][Ships.dataIndex.image]) {
                // Sometimes it wont work properly
                cell.shipImage.sd_setImage(with: url)
            }
            
            cell.shipNameLabel.text = ships[indexPath.row][Ships.dataIndex.name]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Request data here
        performSegue(withIdentifier: "gotoShipDetail", sender: indexPath.row)
    }
    
    @IBAction func resetBtnPressed(_ sender: Any) {
        // Empty
        ships = allInfo
        DispatchQueue.main.async {
            self.shipCollection.reloadData()
        }
        
        AudioServicesPlaySystemSound(1520)
        searchTextField.text = ""
        searchTextField.becomeFirstResponder()
    }
    
    // In order to make it clean and tidy
    func filterShip() {
        if allInfo.count > 0 {
            let filterText = searchTextField.text!
            
            if filterText == "" {
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
                    // Find ship with name
                    if ship[Ships.dataIndex.name].lowercased().contains(filterText.lowercased()) {
                        ships.append(ship)
                    }
                }
            }
            
            // Update table now
            DispatchQueue.main.async {
                self.title = "\(self.ships.count)"
                self.shipCollection.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "gotoShipDetail" {
            let destination = segue.destination as! ShipDetailController
            destination.shipID = ships[sender as! Int][Ships.dataIndex.shipID]
            destination.imageURL = ships[sender as! Int][Ships.dataIndex.image]
            destination.shipName = ships[sender as! Int][Ships.dataIndex.name]
            destination.shipType = ships[sender as! Int][Ships.dataIndex.type]
            destination.shipTier = ships[sender as! Int][Ships.dataIndex.tier]
        }
        
    }
    
    // MARK: Ship Type
    @IBAction func filterDD(_ sender: UIButton) {
        if allInfo.count > 0 {
            // Clean
            ships = [[String]]()
            
            for ship in allInfo {
                if ship[Ships.dataIndex.type] == "Destroyer" {
                    ships.append(ship)
                }
            }
            
            // Update table now
            DispatchQueue.main.async {
                self.shipCollection.reloadData()
            }
        }
        
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func filterCA(_ sender: UIButton) {
        if allInfo.count > 0 {
            // Clean
            ships = [[String]]()
            
            for ship in allInfo {
                if ship[Ships.dataIndex.type] == "Cruiser" {
                    ships.append(ship)
                }
            }
            
            // Update table now
            DispatchQueue.main.async {
                self.shipCollection.reloadData()
                self.title = "\(self.ships.count)"
            }
        }
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func filterBB(_ sender: UIButton) {
        if allInfo.count > 0 {
            // Clean
            ships = [[String]]()
            
            for ship in allInfo {
                if ship[Ships.dataIndex.type] == "Battleship" {
                    ships.append(ship)
                }
            }
            
            // Update table now
            DispatchQueue.main.async {
                self.shipCollection.reloadData()
                self.title = "\(self.ships.count)"
            }
        }
        AudioServicesPlaySystemSound(1520)
    }
    
    @IBAction func filterCV(_ sender: UIButton) {
        if allInfo.count > 0 {
            // Clean
            ships = [[String]]()
            
            for ship in allInfo {
                if ship[Ships.dataIndex.type] == "AirCarrier" {
                    ships.append(ship)
                }
            }
            
            // Update table now
            DispatchQueue.main.async {
                self.shipCollection.reloadData()
                self.title = "\(self.ships.count)"
            }
        }
        AudioServicesPlaySystemSound(1520)
    }
    

}
