//
//  LeftmenuProtocol.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import Foundation

protocol LeftmenuDelegate: AnyObject {
    
    func leftMenuitemTapped(isHideMenu:Bool, isShowNotifications:Bool) 

}
