//
//  ClanSearchController.swift
//  WoWs Info
//
//  Created by Henry Quan on 24/4/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ClanSearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    var clanInfo = [[String]]()
    let serverName = [NSLocalizedString("RU", comment: "Russia"), NSLocalizedString("EU", comment: "Europe"), NSLocalizedString("NA", comment: "North Amercia"), NSLocalizedString("ASIA", comment: "Asia")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Focus textfield
        searchTextField.becomeFirstResponder()
        
        // Setup tableview
        resultTableView.delegate = self
        resultTableView.dataSource = self
        resultTableView.separatorColor = UIColor.clear
        
        // Setup textfield
        searchTextField.delegate = self
        
        // Get server name
        getServerName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        resultTableView.reloadData()
    }
    
    // MARK: TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clanInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "ClanSearchCell", for: indexPath) as! ClanSearchCell
        
        // Setup label
        cell.clanResultLabel.text = "[\(clanInfo[indexPath.row][ClanSearch.dataIndex.tag])] \(clanInfo[indexPath.row][ClanSearch.dataIndex.name])"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Segue to ClanInfoController
        performSegue(withIdentifier: "gotoClanInfo", sender: indexPath.row)
    }
    
    // MARK: TextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss Keyboard
        self.view.endEditing(true)
        
        // Get data from API
        ClanSearch().getClanList(clan: searchTextField.text!) { (clan) in
            DispatchQueue.main.async {
                self.clanInfo = clan
                self.resultTableView.reloadData()
            }
        }
        
        return true
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoClanInfo" {
            // Pass data
            let destination = segue.destination as! ClanInfoController
            let index = sender as! Int
            destination.clanDataString = "\(clanInfo[index][ClanSearch.dataIndex.id]) | \(clanInfo[index][ClanSearch.dataIndex.memberCount]) | \(clanInfo[index][ClanSearch.dataIndex.name]) | \(clanInfo[index][ClanSearch.dataIndex.tag])"
        }
    }
    
    // MARK: Helper Function
    func getServerName() {
        let server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        searchTextField.placeholder = NSLocalizedString("SERVER", comment: "Server label") + " : \(ServerUrl.ServerName[server])"
    }

}
