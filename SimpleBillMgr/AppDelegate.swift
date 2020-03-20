//
//  AppDelegate.swift
//  SimpleBillMgr
//
//  Created by QPomelo on 2019/1/18.
//  Copyright © 2019 QPomelo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let INTERNAL_VERSION: Int = 3
    static var preferredCurrencyId: Int = 1
    static var theme: Theme = .light
    static var addCostType: AddCostType = .pressButton

    var effectView: UIVisualEffectView {
        let eView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        eView.alpha = 1
        eView.frame = UIScreen.main.bounds
        eView.tag = 114514
        return eView
    }
    
    // App 退入后台
    func applicationWillResignActive(_ application: UIApplication) {
        effectView.effect = UIBlurEffect(style: (AppDelegate.theme == .dark ? .dark : .light))
        UIApplication.shared.keyWindow?.addSubview(effectView)
    }
    
    // App 从后台返回
    func applicationDidBecomeActive(_ application: UIApplication) {
        let subViews = UIApplication.shared.keyWindow?.subviews
        for view in subViews! {
            if view.isKind(of: UIVisualEffectView.self) && view.tag == 114514 {
                UIView.animate(withDuration: 0.5, animations: {
                    view.removeFromSuperview()
                })
            }
        }
    }
    
    // 加载/初始化数据库
    func initSettings() {
        _ = DBInit.initDb()
        if Config.getConfig("darkMode") == nil {
            _ = Config.insertConfig(Config(name: "darkMode", value: "false"))
        } else {
            let config = Config.getConfig("darkMode")
            if config!.value == "true" {
                AppDelegate.theme = .dark
            }
        }
        if Config.getConfig("addCostType") == nil {
            _ = Config.insertConfig(Config(name: "addCostType", value: "pressButton"))
        } else {
            let config = Config.getConfig("addCostType")
            if config!.value == "sideDown" {
                AppDelegate.addCostType = .sideDown
            }
        }
        if Config.getConfig("lockPwd") == nil {
            _ = Config.insertConfig(Config(name: "lockPwd", value: ""))
        }
        if Config.getConfig("lockCanUseBiometric") == nil {
            _ = Config.insertConfig(Config(name: "lockCanUseBiometric", value: "true"))
        }
        
        
        
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == "AddCostIntent" {
            if #available(iOS 12.0, *) {
                if let intent = userActivity.interaction?.intent as? AddCostIntent {
                    
                }
            } else {
                // Fallback on earlier versions
            }
        }
        return false
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        initSettings()
        
        // let sboard = UIStoryboard(name: "Main", bundle: nil)
        let tBar = self.window?.rootViewController as! HomeTabBarViewController
        if shortcutItem.type == "bill.chart" {
            // tBar.pushViewController(mView, animated: true)
            tBar.selectedIndex = 0
        }
        if shortcutItem.type == "bill.in" {
            let costboard = UIStoryboard(name: "CostAdvanced", bundle: nil)
            tBar.selectedIndex = 1
            
            let costViewPVC = tBar.selectedViewController as! HomeSwitchPageViewController
            let costView = costViewPVC.selectVC as! HomeViewController
            
            
            let addView = costboard.instantiateViewController(withIdentifier: "UIViewController-8fh-V4-oCe") as! AddBillNavigationViewController
            
            addView.delegate = costView
            addView.lastPageScreenshot = UIApplication.shared.keyWindow!.asImage()
            
            costView.show(addView, sender: nil)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        initSettings()
        // print(UIDevice.modelName)
        return true
    }
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "Main", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelURL!)
        return managedObjectModel!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managedObjectModel)
        let sqliteURL = documentDir.appendingPathComponent("Main.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return persistentStoreCoordinator
    }()
    
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
    
    lazy var documentDir: URL = {
        let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return documentDir!
    }()

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

