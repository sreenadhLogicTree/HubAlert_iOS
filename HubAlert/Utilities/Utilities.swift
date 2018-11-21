//
//  Utilities.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import Foundation
import UIKit

enum AppStoryboard: String{
    
    case Main = "Main"
    case Menu = "Menu"
    
    var instance: UIStoryboard{
        
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
}

//Mark: Fonts

enum Fonts: String{
    case Regular = "Roboto-Regular"
    case Medium = "Roboto-Medium"
    case Bold = "Roboto-Bold"
    case Thin = "Roboto-Thin"
    
    func of(style: UIFont.TextStyle) -> UIFont {
        let preferred = UIFont.preferredFont(forTextStyle:style).pointSize
        
        return (UIFont(name: self.rawValue, size: preferred))!
        
    }

}


