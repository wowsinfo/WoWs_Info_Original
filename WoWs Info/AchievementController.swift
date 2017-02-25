//
//  AchievementController.swift
//  WoWs Info
//
//  Created by Henry Quan on 25/2/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import SDWebImage

private let reuseIndetifier = "AchievementCell"

class AchievementController: UICollectionViewController {

    @IBOutlet var achievementCollection: UICollectionView!
    var achievement: [[String]]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        achievementCollection.delegate = self
        achievementCollection.dataSource = self
        
        // Get all achievement
        achievement = Achievements.getAchievementInformation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Collection view
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievement.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.achievementCollection.dequeueReusableCell(withReuseIdentifier: reuseIndetifier, for: indexPath) as! AchievementCell
        
        var url: URL!
        if achievement[indexPath.row][Achievements.dataIndex.hidden] == "0" {
            url = URL(string: achievement[indexPath.row][Achievements.dataIndex.image])!
        } else {
            url = URL(string: achievement[indexPath.row][Achievements.dataIndex.image_disable])!
        }
        
        cell.achievementImage.sd_setImage(with: url)
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: achievement[indexPath.row][Achievements.dataIndex.name], message: achievement[indexPath.row][Achievements.dataIndex.description], preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}
