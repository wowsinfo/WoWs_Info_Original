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
    let ColourGroup = [UIColor.RGB(red: 85, green: 163, blue: 255),
                       UIColor.RGB(red: 242, green: 71, blue: 56),
                       UIColor.RGB(red: 163, green: 107, blue: 242),
                       UIColor.RGB(red: 57, green: 57, blue: 62),
                       UIColor.RGB(red: 242, green: 145, blue: 61),
                       UIColor.RGB(red: 171, green: 119, blue: 84),
                       UIColor.RGB(red: 109, green: 116, blue: 242),
                       UIColor.RGB(red: 10, green: 86, blue: 143),
                       UIColor.RGB(red: 63, green: 145, blue: 76),
                       UIColor.RGB(red: 191, green: 86, blue: 135),
                       UIColor.RGB(red: 43, green: 105, blue: 80)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make it fit on all devices
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: view.frame.size.width / 4, height: view.frame.size.width / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
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
