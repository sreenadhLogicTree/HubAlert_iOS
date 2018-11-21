//
//  ProfileHeaderView.swift
//  HubAlert
//
//  Created by Sreenadh G on 31/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class ProfileHeaderView: UITableViewHeaderFooterView {

    @IBOutlet var contntView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
       Bundle.main.loadNibNamed("ProfileHeaderView", owner: self, options: nil)
          addSubview(contntView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
