//
//  CustomMessageDelegate.swift
//  HubAlert
//
//  Created by Sreenadh G on 02/11/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import Foundation
protocol CustomMessageDelegate:AnyObject {
    
    func send(with title:String, message:String, isFeedback:Bool)
}
