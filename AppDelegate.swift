//
//  AppDelegate.swift
//  login
//
//  Created by Nguyen Thanh Long on 2019/04/29.
//  Copyright © 2019 Nguyen Thanh Long. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
  var backgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var oldBackgroundTaskID: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    var timer: Timer?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
     //UIApplication.shared.setMinimumBackgroundFetchInterval(500)
        return true
    }
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    func application(_ application: UIApplication,
                     performFetchWithCompletionHandler completionHandler:
                     @escaping (UIBackgroundFetchResult) -> Void) {
       
        
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
      backgroundTaskID = application.beginBackgroundTask {
                 [weak self] in
                 application.endBackgroundTask((self?.backgroundTaskID)!)
                 self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
             }

             timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
                 self.oldBackgroundTaskID = self.backgroundTaskID

                 // 新しいタスクを登録
                 self.backgroundTaskID = application.beginBackgroundTask() { [weak self] in
                     application.endBackgroundTask((self?.backgroundTaskID)!)
                     self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
                 }
                 // 前のタスクを削除
                 application.endBackgroundTask(self.oldBackgroundTaskID)
             })
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
             timer?.invalidate()
            application.endBackgroundTask(self.backgroundTaskID)
        }
        
        func applicationWillTerminate(_ application: UIApplication) {
            // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        }
        
        
        
}

