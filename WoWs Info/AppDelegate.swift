                        //
//  AppDelegate.swift
//  WoWs Info
//
//  Created by Henry Quan on 23/1/17.
//  Copyright © 2017 Henry Quan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-5048098651344514~3226630788")
        
        // Change status bar color
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let user = UserDefaults.standard
        // Prepare for userdefaults
        if user.object(forKey: DataManagement.DataName.FirstLaunch) == nil {
            
            print("First Launch!")
            user.set(true, forKey: DataManagement.DataName.FirstLaunch)
            user.set(3, forKey: DataManagement.DataName.Server)
            user.set(15, forKey: DataManagement.DataName.SearchLimit)
            user.set(">_<", forKey: DataManagement.DataName.UserName)
            // For future updates
            user.set(true, forKey: DataManagement.DataName.IsThereAds)
            user.set(true, forKey: DataManagement.DataName.IsAdvancedUnlocked)
        }
        
        // Setup tk and friend list
        if user.object(forKey: DataManagement.DataName.friend) == nil{
            // I am your friend
            user.set(["HenryQuan|2011774448|3"], forKey: DataManagement.DataName.friend)
            user.set([String](), forKey: DataManagement.DataName.tk)
        }
        
        // Setup languages
        if user.object(forKey: DataManagement.DataName.APILanguage) == nil {
            // Auto by default
            user.set(0, forKey: DataManagement.DataName.APILanguage)
            user.set(0, forKey: DataManagement.DataName.NewsLanague)
        }
        
        // In case a user does not have tk
        if user.object(forKey: DataManagement.DataName.tk) == nil {
            // Empty list
            user.set([String](), forKey: DataManagement.DataName.tk)
        }
        
        // Setup theme
        if user.object(forKey: DataManagement.DataName.theme) == nil {
            user.set(UIColor.RGB(red: 85, green: 163, blue: 255), forKey: DataManagement.DataName.theme)
        }
        
        // Whether user purchases or not
        if user.object(forKey: DataManagement.DataName.hasPurchased) == nil {
            user.set(false, forKey: DataManagement.DataName.hasPurchased)
            user.set(false, forKey: DataManagement.DataName.IsThereAds)
            user.set(false, forKey: DataManagement.DataName.IsAdvancedUnlocked)
        }
        
        // A little guard...
        if user.bool(forKey: DataManagement.DataName.hasPurchased) == false {
            user.set(false, forKey: DataManagement.DataName.IsThereAds)
            user.set(false, forKey: DataManagement.DataName.IsAdvancedUnlocked)
        }
        
        // Reset name
        if !user.bool(forKey: DataManagement.DataName.IsAdvancedUnlocked) {
            user.set(">_<", forKey: DataManagement.DataName.UserName)
        }
        
        // Setup Review and Share
        if user.object(forKey: DataManagement.DataName.didReview) == nil {
            user.set(false, forKey: DataManagement.DataName.didReview)
            user.set(false, forKey: DataManagement.DataName.didShare)
        }
        
        if user.bool(forKey: DataManagement.DataName.hasPurchased) {
            // This is pro version, unlocked
            user.set(true, forKey: DataManagement.DataName.didReview)
            user.set(true, forKey: DataManagement.DataName.didShare)
        }
        
        // Setup Github
        if user.object(forKey: DataManagement.DataName.gotoGithub) == nil {
            user.set(false, forKey: DataManagement.DataName.gotoGithub)
        }
        
        // Setup siren
        let siren = Siren.shared
        siren.alertType = .option
        // siren.debugEnabled = true
        siren.checkVersion(checkType: .immediately)
        
        // Setup remote notification
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
        let notificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(notificationSettings)
        
        // Shortcuts
        let news = UIApplicationShortcutItem(type: "com.yihengquan.WoWs-Info.News", localizedTitle: "NEWS".localised(), localizedSubtitle: "", icon: UIApplicationShortcutIcon.init(templateImageName: "News"), userInfo: nil)
        let wiki = UIApplicationShortcutItem(type: "com.yihengquan.WoWs-Info.Wiki", localizedTitle: "WIKI".localised(), localizedSubtitle: "", icon: UIApplicationShortcutIcon.init(templateImageName: "WikiBar"), userInfo: nil)
        let search = UIApplicationShortcutItem(type: "com.yihengquan.WoWs-Info.Search", localizedTitle: "SEARCH".localised(), localizedSubtitle: "", icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.search), userInfo: nil)
        let contact = UIApplicationShortcutItem(type: "com.yihengquan.WoWs-Info.Contact", localizedTitle: "CONTACT".localised(), localizedSubtitle: "", icon: UIApplicationShortcutIcon.init(templateImageName: "Dashboard"), userInfo: nil)
        UIApplication.shared.shortcutItems = [news, wiki, search, contact]
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Siren.shared.checkVersion(checkType: .daily)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo) 
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        // Go to search
        switch shortcutItem.type {
        case "com.yihengquan.WoWs-Info.News":
            TabBarController.index = 0
        case "com.yihengquan.WoWs-Info.Wiki":
            TabBarController.index = 1
        case "com.yihengquan.WoWs-Info.Search":
            TabBarController.index = 2
        case "com.yihengquan.WoWs-Info.Contact":
            TabBarController.index = 3
        default: break
        }
    }

}

