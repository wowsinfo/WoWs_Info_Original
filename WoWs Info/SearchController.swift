//
//  ViewController.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

// Lol, that's lots of delegates and data sources
class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameTableView: UITableView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var serverPicker: UIPickerView!

    var playerInfo = [[String]]()
    var selectedInfo = [String]()
    var searchLimit = 0
    var server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
    var modeIndex = 0
    
    let serverName = [NSLocalizedString("RU", comment: "Russia"), NSLocalizedString("EU", comment: "Europe"), NSLocalizedString("NA", comment: "North Amercia"), NSLocalizedString("ASIA", comment: "Asia")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Segmented controll
        let modeSegment = UISegmentedControl.init(items: ["Player", "Clan"])
        modeSegment.selectedSegmentIndex = 0
        modeSegment.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        self.navigationItem.titleView = modeSegment
   
        // Tableview setup
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        usernameTableView.separatorColor = UIColor.clear
        
        // Pickerview setup
        serverPicker.delegate = self
        serverPicker.delegate = self
        
        // Textfield setup
        username.delegate = self

        // Vary from 10 - 100
        searchLimit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        
        // Load server name
        getServerName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // Clean text
        username.text = ""
        // Reload tableview
        usernameTableView.reloadData()
    }
    
    func getServerName() {
        server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        username.placeholder = NSLocalizedString("SERVER", comment: "Server label") + " : \(ServerUrl.ServerName[server])"
    }
    
    // MARK: segmentedControl pressed
    func segmentedControlValueChanged(segment: UISegmentedControl) {
        // Clean text
        username.text = ""
        playerInfo = [[String]]()
        // Reload tableview
        usernameTableView.reloadData()
        
        // Change Mode
        modeIndex = segment.selectedSegmentIndex
    }
    
    // MARK: Load data into tableview
    func refreshTabelView() {
        DispatchQueue.main.async {
            self.usernameTableView.reloadData()
        };
    }
    
    func loadDataIntoTableview() {
        
        playerInfo.removeAll()
        self.refreshTabelView()
        
        let userInput = username.text!
        
        if modeIndex == 0 {
            // Player
            let player = PlayerInfomation(limit: searchLimit)
            if (player.isInputValid(input: userInput)) {
                player.getDataFromAPI(search: userInput, success: {success in
                    if !success.isEmpty {
                        self.playerInfo = success
                        // Refresh TableView
                        self.refreshTabelView()
                    }
                })
            }
        } else {
            // Clan
            ClanSearch().getClanList(clan: userInput) { (clan) in
                DispatchQueue.main.async {
                    self.playerInfo = clan
                    // Refresh TableView
                    self.refreshTabelView()
                }
            }
        }
        
        
    }
    
    // MARK: Button pressed
    @IBAction func serverBtnPressed(_ sender: UIButton) {
        
        username.resignFirstResponder()
        // Show our view
        self.pickerView.isHidden = false
        
        serverPicker.selectRow(server, inComponent: 0, animated: true)
        
    }
    
    @IBAction func doneBtnPressed(_ sender: UIButton) {
        
        // Save new server index
        let index = serverPicker.selectedRow(inComponent: 0)
        if index >= 0 && index < 4 {
            UserDefaults.standard.set(index, forKey: DataManagement.DataName.Server)
        }
        
        // Hide view and show keyboard
        self.pickerView.isHidden = true
        
        playerInfo.removeAll()
        
        // Remove old search
        self.username.text = ""
        
        DispatchQueue.main.async {
            self.usernameTableView.reloadData()
        };

        self.username.becomeFirstResponder()
        // Change textholder
        self.getServerName()
        
    }
    
    // MARK: UITextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss keyboard
        self.view.endEditing(true)
        
        // Request data here
        loadDataIntoTableview()
        
        return true
    }
    
    // MARK: PickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return serverName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return serverName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        // Change to a better font
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        
        if modeIndex == 0 {
            // Player
            cell.textLabel?.text = "\(playerInfo[indexPath.row][0])|\(playerInfo[indexPath.row][1])"
        } else {
            // Clan
            cell.textLabel?.text = "[\(playerInfo[indexPath.row][ClanSearch.dataIndex.tag])] \(playerInfo[indexPath.row][ClanSearch.dataIndex.name])"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Dismiss keyboard
        username.resignFirstResponder()
        
        if modeIndex == 0 {
            // Get Account details
            let selectedCell = tableView.cellForRow(at: indexPath)
            let accountInfo: String = (selectedCell?.textLabel?.text)!
            
            selectedInfo = accountInfo.components(separatedBy: "|")
            
            // Go to player info controller
            let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
            if isProVersion {
                performSegue(withIdentifier: "gotoAdvancedDetails", sender: [String]())
            } else {
                performSegue(withIdentifier: "gotoDetails", sender: [String]())
            }
        } else {
            performSegue(withIdentifier: "gotoClanInfo", sender: indexPath.row)
        }
        
    }
    
    // MARK: Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "gotoClanInfo" {
            // Pass data
            let destination = segue.destination as! ClanInfoController
            let index = sender as! Int
            destination.clanDataString = "\(playerInfo[index][ClanSearch.dataIndex.id]) | \(playerInfo[index][ClanSearch.dataIndex.memberCount]) | \(playerInfo[index][ClanSearch.dataIndex.name]) | \(playerInfo[index][ClanSearch.dataIndex.tag])"
        } else {
            let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
            if isProVersion {
                // Go to AdvancedInfoController
                let destination = segue.destination as! AdvancedInfoController
                destination.playerInfo = selectedInfo
            } else {
                // Go to PlayerInfoController
                let destination = segue.destination as! PlayerInfoController
                destination.playerInfo = selectedInfo
            }
        }
        
    }

}

