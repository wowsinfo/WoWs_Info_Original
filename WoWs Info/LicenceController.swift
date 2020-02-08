//
//  LicenceController.swift
//  WoWs Info
//
//  Created by Henry Quan on 1/7/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SafariServices

class LicenceController: UITableViewController, SFSafariViewControllerDelegate {

    let LicenceList = ["SwiftyJson",
                       "Siren",
                       "Charts\n   Copyright 2016 Daniel Cohen Gindi & Philipp Jahoda\n   Licensed under the Apache License",
                       "SDWebImage\n   Copyright (c) 2009-2017 Olivier Poitrey\n   Licensed under the MIT License",
                       "Kanna\n   Copyright (c) 2014 - 2015 Atsushi Kiwaki (@_tid_)\n   Licensed under the MIT License"]
    let websites = ["https://github.com/SwiftyJSON/SwiftyJSON",
                    "https://github.com/ArtSabintsev/Siren",
                    "https://github.com/danielgindi/Charts",
                    "https://github.com/rs/SDWebImage",
                    "https://github.com/tid-kijyun/Kanna"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Tableview
        self.tableView.estimatedRowHeight = 50
        self.tableView.separatorColor = UIColor.clear
        self.tableView.rowHeight = UITableView.automaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LicenceList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = LicenceList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let website = SFSafariViewController(url: URL(string: self.websites[indexPath.row])!)
        website.modalPresentationStyle = .overFullScreen
        website.delegate = self
        // Change it to black
        UIApplication.shared.statusBarStyle = .default
        self.present(website, animated: true, completion: nil)
        
        // Deselect this cell
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Safari
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        // CHange it back
        UIApplication.shared.statusBarStyle = .lightContent
        controller.dismiss(animated: true, completion: nil)
    }

}
