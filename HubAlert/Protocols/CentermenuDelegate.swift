//
//  CentermenuDelegate.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import Foundation
protocol CentermenuDelegate:AnyObject {
    func leftmenuTapped()
    func fetchedProfiles(profiles:[AnyObject])
    func loadProfile(profileId:Int64, alertId:Int64)
    func showLoading()
    func removeLoading()
}
