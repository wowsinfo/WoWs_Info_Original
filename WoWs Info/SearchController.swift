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
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var serverPicker: UIPickerView!

    var playerInfo = [[String]]()
    var selectedInfo = [String]()
    var searchLimit = 0
    var server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
    
    let serverName = [NSLocalizedString("RU", comment: "Russia"), NSLocalizedString("EU", comment: "Europe"), NSLocalizedString("NA", comment: "North Amercia"), NSLocalizedString("ASIA", comment: "Asia")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        // Tableview setup
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        usernameTableView.separatorColor = UIColor.clear
        
        self.title = ""
        username.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        // Pickerview setup
        serverPicker.delegate = self
        serverPicker.delegate = self

        searchLimit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        
        getServerName()
        
    }
    
    // When user is back to this view clean last search text
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
        username.text = ""
        usernameTableView.reloadData()
        
        // Popup keyboard after view is loaded
        username.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func getServerName() {
        
        server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        username.placeholder = NSLocalizedString("SERVER", comment: "Server label") + " : \(ServerUrl.ServerName[server])"
        
    }
    
    // MARK: Load data into tableview
    func refreshTabelView() {
        DispatchQueue.main.async {
            self.usernameTableView.reloadData()
        };
    }
    
    func loadDataIntoTableview() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        playerInfo.removeAll()
        self.refreshTabelView()
        
        let userInput = username.text!
        
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
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    // MARK: UITextfield
    @IBAction func usernameChanged(_ sender: UITextField) {
        
        // Cancel last request if user types really quick
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadDataIntoTableview), object: usernameTableView)
        
        // Load data into tableview if user pauses for 0.25 seconds
        self.perform(#selector(loadDataIntoTableview), with: usernameTableView, afterDelay: 0.5)
        
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
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        if (username.text?.characters.count)! >= 3 {
            // Load data into tableview
            loadDataIntoTableview()
            
            // Dismiss Keyboard
            username.resignFirstResponder()
        }
        
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
        
        if (!playerInfo.indices.contains(indexPath.row)) {
            cell.textLabel?.text = NSLocalizedString("UNKNOWN_ERROR", comment: "Unknown error label")
        }
        else {
            cell.textLabel?.text = "\(playerInfo[indexPath.row][0])|\(playerInfo[indexPath.row][1])"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Dismiss keyboard
        username.resignFirstResponder()
        
        // Get Account details
        let selectedCell = tableView.cellForRow(at: indexPath)
        let accountInfo: String = (selectedCell?.textLabel?.text)!
        
        if accountInfo == NSLocalizedString("UNKNOWN_ERROR", comment: "Unknown error label") {
            return
        }
        
        selectedInfo = accountInfo.components(separatedBy: "|")
        
        // Go to player info controller
        let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
        if isProVersion {
            performSegue(withIdentifier: "gotoAdvancedDetails", sender: [String]())
        } else {
            performSegue(withIdentifier: "gotoDetails", sender: [String]())
        }
        
    }
    
    // MARK: Prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = NSLocalizedString("BACK", comment: "Back label")
        navigationItem.backBarButtonItem = backItem
        
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

