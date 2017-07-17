//
//  FriendController.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class FriendController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var friendTableView: UITableView!
    @IBOutlet weak var modeSegment: UISegmentedControl!
    @IBOutlet weak var dashboardBtn: UIButton!
    
    var friendList = [String]()
    var tkList = [String]()
    var currPlayer = ""
    let isPro = UserDefaults.standard.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get data
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) != nil && user.object(forKey: DataManagement.DataName.tk) != nil {
            friendList = user.object(forKey: DataManagement.DataName.friend) as! [String]
            tkList = user.object(forKey: DataManagement.DataName.tk) as! [String]
        }
        currPlayer = user.string(forKey: DataManagement.DataName.UserName)!
        
        // Setup tableview
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.separatorColor = UIColor.clear
        
        // Round button for a perfect radius
        modeSegment.layer.cornerRadius = modeSegment.frame.height / 2
        modeSegment.layer.masksToBounds = true
        // Border
        modeSegment.layer.borderWidth = 1.0
        modeSegment.layer.borderColor = Theme.getCurrTheme().cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get data again
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) != nil && user.object(forKey: DataManagement.DataName.tk) != nil {
            friendList = user.object(forKey: DataManagement.DataName.friend) as! [String]
            tkList = user.object(forKey: DataManagement.DataName.tk) as! [String]
        }
        currPlayer = user.string(forKey: DataManagement.DataName.UserName)!
        
        // Update colour
        modeSegment.tintColor = Theme.getCurrTheme()
        modeSegment.layer.borderColor = Theme.getCurrTheme().cgColor
        dashboardBtn.backgroundColor = Theme.getCurrTheme()
        dashboardBtn.layer.cornerRadius = dashboardBtn.frame.width / 2
        dashboardBtn.layer.masksToBounds = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.friendTableView.reloadData()
    }
    
    // MARK: Button Pressed
    @IBAction func dashboardBtnPressed(_ sender: Any) {
        if !isPro {
            let pro = UIAlertController(title: NSLocalizedString("PRO_TITLE", comment: "Title"), message: NSLocalizedString("PRO_MESSAGE", comment: "Message"), preferredStyle: .alert)
            pro.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(pro, animated: true, completion: nil)
        } else if currPlayer != ">_<" {
            // Update server index
            let server = UserDefaults.standard.string(forKey: DataManagement.DataName.UserName)?.components(separatedBy: "|").last!
            UserDefaults.standard.set(Int(server!), forKey: DataManagement.DataName.Server)
            // Go to dashboard
            performSegue(withIdentifier: "gotoInfo", sender: currPlayer)
        }
    }
    
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 0 for friend
        if modeSegment.selectedSegmentIndex == 0 { return friendList.count }
        // 1 for tk
        if modeSegment.selectedSegmentIndex == 1 { return tkList.count }
        // 2 for currPlayer
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        // Better font
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        // Show indicator
        cell.accessoryType = .disclosureIndicator
        
        if modeSegment.selectedSegmentIndex == 0 {
            // Friend
            cell.textLabel?.text = friendList[indexPath.row]
            return cell
        }
        
        // Tk
        cell.textLabel?.text = tkList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Change server index
        UserDefaults.standard.set(Int(friendList[indexPath.row].components(separatedBy: "|")[2]), forKey: DataManagement.DataName.Server)
        if modeSegment.selectedSegmentIndex == 0 {
            performSegue(withIdentifier: "gotoInfo", sender: friendList[indexPath.row])
        } else if modeSegment.selectedSegmentIndex == 1 {
            performSegue(withIdentifier: "gotoInfo", sender: tkList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove from ist
            let index  = modeSegment.selectedSegmentIndex
            if index == 0 {
                // Friend
                friendList.remove(at: indexPath.row)
                UserDefaults.standard.set(friendList, forKey: DataManagement.DataName.friend)
            } else if index == 1 {
                // TK
                tkList.remove(at: indexPath.row)
                UserDefaults.standard.set(tkList, forKey: DataManagement.DataName.tk)
            }
            self.friendTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoInfo" {
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = (sender as! String).components(separatedBy: "|")
        }
    }
    
    // MARK: Segmented Control
    @IBAction func modeChanged(_ sender: Any) {
        if modeSegment.selectedSegmentIndex != 2 {
            self.friendTableView.reloadData()
        } else {
            // Move to friend list
            modeSegment.selectedSegmentIndex = 0
            self.friendTableView.reloadData()
        }
    }

}
