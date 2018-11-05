//
//  AppDelegate.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 5/10/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var ref: DatabaseReference!
    var dues = [DueStruct]()
    var username = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//        ref = Database.database().reference()
//        ref.child("Dues").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get due value
//            let myDues = snapshot.value as? [[String: Any]]
//            for due in myDues!{
//                let name = due["name"] as? String ?? ""
//                let cost = due["cost"] as? Float ?? 0.00
//                let dueDate = due["dueDate"] as? String ?? "00-00-0000"
//                let late = due["late"] as? Bool ?? false
//                let description = due["description"] as? String ?? ""
//                self.dues.insert(DueStruct(name: name, cost: cost, dueDate: dueDate, late: late, description: description), at: 0)
//            }
//        }) { (error) in
//            print(error.localizedDescription)
//        }
        
       return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    

}

