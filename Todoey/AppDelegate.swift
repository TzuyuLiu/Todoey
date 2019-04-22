//
//  AppDelegate.swift
//  Todoey
//
//  Created by 劉子瑜 on 2019/4/18.
//  Copyright © 2019 劉子瑜. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print("did Finish Launching With Options")
        
        //print(Realm.Configuration.defaultConfiguration.fileURL);
        

        //Realm initalization
        do{
            _ = try Realm()     //沒有使用到的參數可以用_代替

        }catch{
            print("Error initialising new relam, \(error)")
        }

        
        return true
    }
}

