//
//  AppDelegate.swift
//  PlayTube
//
//  Created by Adnan Basar on 24/12/2016.
//  Copyright © 2016 Adnan Basar. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import Fabric
import Crashlytics
import Material

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
   
        Fabric.with([Crashlytics.self])
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }catch (let error as NSError) {
            dump(error)
        }
        
        
        let bottomNavigationController = AppBottomNavigationController(viewControllers:
            [ AppSnackbarController(rootViewController:SearchController(rootViewController: SearchRootController())),
              FavoritesController(rootViewController: FavoritesRootController()),
              PlayerController(rootViewController: PlayerRootController.sharedInstance),
              //ListController()
              SettingsController(rootViewController: SettingsRootController())
            ])
        bottomNavigationController.selectedIndex = 0
    
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = bottomNavigationController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }

    
    private func setupFirebase(){
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        dump("applicationDidEnterBackground!")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

