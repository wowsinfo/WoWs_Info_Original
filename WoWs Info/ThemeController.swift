//
//  ThemeController.swift
//  WoWs Info
//
//  Created by Henry Quan on 5/6/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit

class ThemeController: UICollectionViewController {

    @IBOutlet var ColourCollectionView: UICollectionView!
    let ColourGroup = [UIColor.RGB(red: 68, green: 192, blue: 255), // Blue
                       UIColor.RGB(red: 49, green: 153, blue: 218),
                       UIColor.RGB(red: 85, green: 163, blue: 255),
                       UIColor.RGB(red: 10, green: 86, blue: 143),
        
                       UIColor.RGB(red: 242, green: 71, blue: 56), // Red
                       UIColor.RGB(red: 255, green: 109, blue: 107),
                       UIColor.RGB(red: 231, green: 75, blue: 61),
                       UIColor.RGB(red: 191, green: 86, blue: 135),
        
                       UIColor.RGB(red: 63, green: 145, blue: 76), // Green
                       UIColor.RGB(red: 44, green: 204, blue: 114),
                       UIColor.RGB(red: 43, green: 105, blue: 80),
                       
                       UIColor.RGB(red: 163, green: 107, blue: 242),// Purple
                       UIColor.RGB(red: 194, green: 122, blue: 210),
                       UIColor.RGB(red: 109, green: 116, blue: 242),
        
                       UIColor.RGB(red: 171, green: 119, blue: 84), // Brown
                       UIColor.RGB(red: 201, green: 161, blue: 134),
        
                       UIColor.RGB(red: 242, green: 145, blue: 61), // Orange
                       UIColor.RGB(red: 254, green: 152, blue: 58),
                       
                       UIColor.RGB(red: 57, green: 57, blue: 62), // Black
                       UIColor.RGB(red: 150, green: 164, blue: 166) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make it fit on all devices
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width / 4, height: view.frame.size.width / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        ColourCollectionView.collectionViewLayout = layout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: CollectionViewData
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ColourGroup.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UserDefaults.standard.set(ColourGroup[indexPath.row], forKey: DataManagement.DataName.theme)
        UINavigationBar.appearance().barTintColor = self.ColourGroup[indexPath.row]
        UITabBar.appearance().tintColor = self.ColourGroup[indexPath.row]
        _ = self.navigationController?.popToRootViewController(animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThemeCell", for: indexPath)
        cell.backgroundColor = ColourGroup[indexPath.row]
        return cell
    }

}
