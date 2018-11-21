//
//  AppConstants.swift
//  HubAlert
//
//  Created by Sreenadh G on 15/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import Foundation
import UIKit

struct AppColors {
    static let bgTopColor = UIColor(red: 241.0/255, green: 100.0/255, blue: 65.0/255, alpha: 1.0)
    static let bgBottomColor = UIColor(red: 239.0/255, green: 57.0/255, blue: 90.0/255, alpha: 1.0)
    
    static let lightGrayColor = UIColor(red: 233.0/255, green: 233.0/255, blue: 233.0/255, alpha: 1.0)

}
struct AppKeys {
    static let UniqueID = "UniqueID"
    static let DeviceToken = "DeviceToken"
    static let VerifiedPhoneNumber = "VerifiedNumber"
    static let OTPReceived = "OTPReceived"
    static let OTPVerified = "OTPVerified"
    static let isGPSSelected = "isGPSSelected"

}
struct AppSegues {
    //Segue Identifiers
    static let verifyOTP = "verifyOTP"
    static let showMainMenu = "showMainMenu"

    
}
struct AppReuseIDs{
    static let leftMenuCell = "useraccountcell"
    static let rightMenuCell = "rightOptioncell"
    static let notificationCell = "notificationcell"

    

}
struct RightmenuOptions{
    static let NotificationActiivty = "Notification Activity"
    static let Feedback = "Developer Feedback"
    
}
struct NetworkUtil {
    //static let serviceUrl: String = "http://mservice.logictree.it/HubAlert/api/Hubalert/"//Live
    static let serviceUrl: String = "http://stmservice.logictree.it/HubAlert/api/Hubalert/"//Stage
}

struct NetworkKeys {
    
    static let pMobileNumber = "pMobileNumber"
    static let pDeviceID = "pDeviceID"
    static let pDeviceType = "pDeviceType"
    static let pUniqueID = "pUniqueID"
    static let pAppVersion = "pAppVersion"

    static let pUserModuleID = "pUserModuleID"
    static let pProfileID = "pProfileID"
    
    static let pItemID = "pItemID"
    static let pLatitude = "pLatitude"
    static let pLongitude = "pLongitude"
    static let pMessage = "pMessage"
    static let pSubject = "pSubject"
    static let pHubAlertID = "pHubAlertID"

    static let pModuleName = "pModuleName"


    
}

struct NetworkValues {
    static let DeviceType = "iphone"
    static let Appversion = "1.0"

}


struct AlertTitles {
    static let offline = "Offline"
}
struct AlertMessages {
    static let offline = "No internet connection"
}
