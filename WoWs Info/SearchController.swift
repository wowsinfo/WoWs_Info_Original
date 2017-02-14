//
//  ViewController.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameTableView: UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var playerInfo = [[String]]()
    var selectedInfo = [String]()
    var searchLimit = 0
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
   
        usernameTableView.delegate = self
        usernameTableView.dataSource = self
        
        searchLimit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        
        let server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        username.placeholder = "Server : \(ServerUrl.ServerName[server])"
        
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
    
    func refreshTabelView() {
        DispatchQueue.main.async {
            self.usernameTableView.reloadData()
        };
    }
    
    func loadDataIntoTableview() {
        
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
        
    }
    
    @IBAction func usernameChanged(_ sender: UITextField) {
        
        // Cancel last request if user types really quick
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(loadDataIntoTableview), object: usernameTableView)
        
        // Load data into tableview if user pauses for 0.25 seconds
        self.perform(#selector(loadDataIntoTableview), with: usernameTableView, afterDelay: 0.5)
        
    }
    
    
    @IBAction func searchBtnPressed(_ sender: UIButton) {
        
        if (username.text?.characters.count)! >= 3 {
            // Load data into tableview
            loadDataIntoTableview()
            
            // Dismiss Keyboard
            username.resignFirstResponder()
            
            // Wait for 0.1 second
            usleep(100000)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        if (!playerInfo.indices.contains(indexPath.row)) {
            cell.textLabel?.text = "Unknown Error"
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
        if accountInfo == "Unknown Error" {
            return
        }
        
        selectedInfo = accountInfo.components(separatedBy: "|")
        
        // Go to player info controller
        let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
        if !isProVersion {
            performSegue(withIdentifier: "gotoAdvancedDetails", sender: [String]())
        } else {
            performSegue(withIdentifier: "gotoDetails", sender: [String]())
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Change text to "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
        let isProVersion = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
        if !isProVersion {
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

