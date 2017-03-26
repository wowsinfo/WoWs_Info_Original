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
    var friendList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 35/255, green: 135/255, blue: 1, alpha: 1.0)
        
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.friend) != nil {
            friendList = user.object(forKey: DataManagement.DataName.friend) as! [String]
        }
        
        friendTableView.delegate = self
        friendTableView.dataSource = self
        friendTableView.separatorColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 35/255, green: 135/255, blue: 1, alpha: 1.0)
        friendTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = friendList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(Int(friendList[indexPath.row].components(separatedBy: "|")[2]), forKey: DataManagement.DataName.Server)
        performSegue(withIdentifier: "gotoFriendInfo", sender: friendList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoFriendInfo" {
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = (sender as! String).components(separatedBy: "|")
        }
    }

}
