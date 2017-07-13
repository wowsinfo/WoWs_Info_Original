//
//  ViewController.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import GoogleMobileAds

// Lol, that's lots of delegates and data sources
class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, GADBannerViewDelegate, GADRewardBasedVideoAdDelegate {

    @IBOutlet weak var showAdsConstraint: NSLayoutConstraint!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var usernameTableView: UITableView!
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var serverPicker: UIPickerView!
    @IBOutlet weak var serverSelectionBtn: UIButton!
    
    var playerInfo = [[String]]()
    var selectedInfo = [String]()
    var searchLimit = 0
    var server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
    var modeIndex = 0
    
    let serverName = [NSLocalizedString("RU", comment: "Russia"), NSLocalizedString("EU", comment: "Europe"), NSLocalizedString("NA", comment: "North Amercia"), NSLocalizedString("ASIA", comment: "Asia")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased)
        
        // Show Github if havent seen it yet
        if !UserDefaults.standard.bool(forKey: DataManagement.DataName.gotoGithub) {
            print("Show Github Message")
            let github = UIAlertController(title: "GITHUB_TITLE".localised(), message: "GITHUB_MESSAGE".localised(), preferredStyle: .alert)
            github.addAction(UIAlertAction(title: ">_<", style: .default, handler: { (Github) in
                UIApplication.shared.openURL(URL(string: "https://github.com/HenryQuan/WoWs_Info_IOS")!)
            }))
            self.present(github, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: DataManagement.DataName.gotoGithub)
        }
        
        // Whether ads should be shown
        if isPro {
            // Adjust constraint
            showAdsConstraint.constant -= 50
            bannerView.removeFromSuperview()
        } else {
            // Load ads
            bannerView.adSize = kGADAdSizeSmartBannerPortrait
            bannerView.adUnitID = "ca-app-pub-5048098651344514/4703363983"
            bannerView.rootViewController = self
            bannerView.delegate = self
            let request = GADRequest()
            request.testDevices = [kGADSimulatorID]
            bannerView.load(request)
        }
        
        // Load rating
        ShipRating().loadExpctedJson()
        
        // Setup Segmented controll
        let modeSegment = UISegmentedControl.init(items: [NSLocalizedString("PLAYER_SEGMENT", comment: "Player"), NSLocalizedString("CLAN_SEGMENT", comment: "Clan")])
        // Round button for a perfect radius
        modeSegment.layer.cornerRadius = modeSegment.frame.height / 2
        modeSegment.layer.masksToBounds = true
        // Border
        modeSegment.layer.borderWidth = 1.0
        modeSegment.layer.borderColor = UIColor.white.cgColor
        // 3 / 4 size
        modeSegment.frame.size.width = self.view.frame.width / 4 * 3
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
        
        // Setup pointLabel
        if isPro {
            pointLabel.frame.size.height = 0
            pointLabel.removeFromSuperview()
        } else {
            pointLabel.text = "POINT_SYSTEM".localised() + ": \(PointSystem.getCurrPoint())"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Change theme for serverSelectionbtn
        serverSelectionBtn.backgroundColor = Theme.getCurrTheme()
        serverSelectionBtn.layer.cornerRadius = serverSelectionBtn.frame.width / 5
        serverSelectionBtn.layer.masksToBounds = true
        
        // Clean text
        username.text = ""
        // Reload tableview
        usernameTableView.reloadData()

        // Reload search limit
        searchLimit = UserDefaults.standard.integer(forKey: DataManagement.DataName.SearchLimit)
        
        // Reload server
        getServerName()
        
        // Check if user needs to watch a video ads
        if !UserDefaults.standard.bool(forKey: DataManagement.DataName.hasPurchased) && PointSystem.getCurrPoint() < 1 {
            GADRewardBasedVideoAd.sharedInstance().delegate = self
            if GADRewardBasedVideoAd.sharedInstance().isReady {
                GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
            }
        }
    }
    
    func getServerName() {
        server = UserDefaults.standard.integer(forKey: DataManagement.DataName.Server)
        username.placeholder = NSLocalizedString("SERVER", comment: "Server label") + " : \(ServerUrl.ServerName[server])"
    }
    
    // MARK: ADS
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        // Adjust constraint
        showAdsConstraint.constant -= 50
        bannerView.removeFromSuperview()
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        // Add 3 points
        PointSystem(index: PointSystem.DataIndex.AD).addPoint()
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
            UIView.transition(with: self.view, duration: 0.25, options: .curveEaseIn, animations: {
                self.usernameTableView.reloadData()
                self.usernameTableView.reloadRows(at: self.usernameTableView.indexPathsForVisibleRows!, with: .automatic)
            })
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
    
    @IBAction func textChanged(_ sender: Any) {
        
        // Cancel it if text keep changing
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        // Request data here
        self.perform(#selector(loadDataIntoTableview), with: nil, afterDelay: 0.75)
        
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
        // Show indicator
        cell.accessoryType = .disclosureIndicator
        
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
            performSegue(withIdentifier: "gotoAdvancedDetails", sender: [String]())
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
        } else if segue.identifier == "gotoAdvancedDetails" {
            // Go to AdvancedInfoController
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = selectedInfo
        }
        
    }

}

