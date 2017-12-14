//
//  AppDelegate.swift
//  BBSLocation
//
//  Created by Gayan dias on 12/13/17.
//  Copyright © 2017 Gayan dias. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
let appDelegate = UIApplication.shared.delegate as! AppDelegate

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shortcutItem: UIApplicationShortcutItem?
    var navicontroller:UINavigationController?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.0)
        
        // Quick action
        var performShortcutDelegate = true
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            
            self.shortcutItem = shortcutItem
            
            performShortcutDelegate = false
        }

        
        // Override point for customization after application launch.
        return performShortcutDelegate
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("Application did become active")
        
        //guard let shortcut = shortcutItem else { return }
        
        print("- Shortcut property has been set")
        
        //self.handleShortcut(shortcut)
        
        self.shortcutItem = nil
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    //MARK: - Quick action
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem) )
    }
    
    /*
     Handel 3D funtion
     */
    @available(iOS 9.0, *)
    func handleShortcut( _ shortcutItem:UIApplicationShortcutItem ) -> Bool {
        
        var succeeded = false
        
        if( shortcutItem.type == "be.thenerd.appshortcut.search-candidate" ) {
            
            self.showCityListConroller(isSearch: true)
            
            succeeded = true
        }
        return succeeded
    }
    
    /*
     NAvigate to the city view list controller
     */
    func showCityListConroller(isSearch: Bool? = false) {
        let candidateStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let rootViewController = candidateStoryboard.instantiateViewController(withIdentifier: "BBCCityView")  as? BBCCityViewController
        //rootViewController?.viewModel = BBCityViewModel(isCandidateSearch: true)
        let navigation = UINavigationController(rootViewController: rootViewController!)
        appDelegate.window?.rootViewController = navigation
    }
}

