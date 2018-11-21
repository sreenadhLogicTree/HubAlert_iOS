//
//  AppDelegate.swift
//  HubAlert
//
//  Created by Sreenadh G on 15/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import CoreLocation
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentProfileid:Int64?
    var currentModuleid:Int64?
    var currentModuleName:String?
    var currentAlertId:Int64?
    var generalAlertid:Int64?

    var locManager = CLLocationManager()
    var currentLocation: CLLocation {
        get{
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                return locManager.location ?? CLLocation(latitude: 0.0, longitude: 0.0)
            }
            
            return CLLocation(latitude: 0.0, longitude: 0.0)
        }
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
       // UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            
            if granted{
                
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()


                }
            }
            else{
                UserDefaults.standard.set("", forKey: AppKeys.DeviceToken)

            }
        }

        generateUniqueId()
        getAppData()
        locManager.requestWhenInUseAuthorization()
        
        if UserDefaults.standard.value(forKey: AppKeys.OTPVerified) != nil{
            
        let menuContainerVC = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "Container") as! ContainerViewController
            
        self.window?.rootViewController = menuContainerVC
            
        }
        
        UITextField.appearance().tintColor = AppColors.bgBottomColor
        UIPageControl.appearance().pageIndicatorTintColor = AppColors.lightGrayColor
        UIPageControl.appearance().currentPageIndicatorTintColor = AppColors.bgBottomColor
        
        guard let deviceToken = UserDefaults.standard.value(forKey: AppKeys.DeviceToken) else { return true }
        print("token - \(deviceToken)")
        return true
    }
    
   /* func registerForRichNotifications() {
        
        /*UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]) { (granted:Bool, error:Error?) in
            if error != nil {
                print(error?.localizedDescription)
            }
            if granted {
                print("Permission granted")
            } else {
                print("Permission not granted")
            }
        }*/
        
        //actions defination
        let action1 = UNNotificationAction(identifier: "action1", title: "View", options: [.foreground])
        let action2 = UNNotificationAction(identifier: "action2", title: "Cancel", options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "actionCategory", actions: [action1,action2], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
    }*/
    func loadPhoneNumberScreen(){
        let menuContainerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GetOTP") as! UINavigationController
        removeallpersistData()
        self.window?.rootViewController = menuContainerVC
    }
    private func removeallpersistData(){
        UserDefaults.standard.set(nil, forKey: AppKeys.OTPReceived)
        UserDefaults.standard.set(nil, forKey: AppKeys.OTPVerified)
        UserDefaults.standard.set(nil, forKey: AppKeys.VerifiedPhoneNumber)
    }
    
    func generateUniqueId(){
        
        if (UserDefaults.standard.value(forKey: AppKeys.UniqueID) != nil){
            
        } else{
            
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: AppKeys.UniqueID)
            
        }
        
    }
    
    func saveAppData(){
        
        UserDefaults.standard.set(currentModuleid, forKey: NetworkKeys.pUserModuleID)
        UserDefaults.standard.set(currentProfileid, forKey: NetworkKeys.pProfileID)
        UserDefaults.standard.set(currentModuleName, forKey: NetworkKeys.pModuleName)
        UserDefaults.standard.set(currentAlertId, forKey: NetworkKeys.pHubAlertID)


    }
    
    func getAppData(){
        
        if let mname = UserDefaults.standard.value(forKey: NetworkKeys.pModuleName) as? String{
            
            currentModuleName = mname
        }
        if let pid = UserDefaults.standard.value(forKey: NetworkKeys.pProfileID) as? Int64{
            
            currentProfileid = pid
        }
        if let mid = UserDefaults.standard.value(forKey: NetworkKeys.pUserModuleID) as? Int64{
            
            currentModuleid = mid
        }
        if let alertid = UserDefaults.standard.value(forKey: NetworkKeys.pHubAlertID) as? Int64{
            
            currentAlertId = alertid
        }
        
    }
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        UserDefaults.standard.set(deviceTokenString, forKey: AppKeys.DeviceToken)
        print("Token - \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("Error - \(error)")
        UserDefaults.standard.set("", forKey: AppKeys.DeviceToken)

        application.registerForRemoteNotifications()
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //save data
        
        saveAppData()
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        getAppData()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HubAlert")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



extension Data{
    
    var hexString:String{
        let hexString = map{ String(format: "%02.2hhx", $0)}.joined()
        return hexString
    }
}
