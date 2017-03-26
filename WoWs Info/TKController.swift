//
//  TKController.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/3/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class TKController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tkTableView: UITableView!
    var tkList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        
        let user = UserDefaults.standard
        if user.object(forKey: DataManagement.DataName.tk) != nil {
            tkList = user.object(forKey: DataManagement.DataName.tk) as! [String]
        }
        
        tkTableView.delegate = self
        tkTableView.dataSource = self
        tkTableView.separatorColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 230/255, green: 106/255, blue: 1, alpha: 1.0)
        tkTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tkList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tkList[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(Int(tkList[indexPath.row].components(separatedBy: "|")[2]), forKey: DataManagement.DataName.Server)
        performSegue(withIdentifier: "gotoTKInfo", sender: tkList[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoTKInfo" {
            let destination = segue.destination as! AdvancedInfoController
            destination.playerInfo = (sender as! String).components(separatedBy: "|")
        }
    }

}
