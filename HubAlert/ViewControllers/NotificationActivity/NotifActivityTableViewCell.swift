//
//  NotifActivityTableViewCell.swift
//  HubAlertSample
//
//  Created by Thirupathi on 26/10/18.
//  Copyright © 2018 Rama Krishna. All rights reserved.
//

import UIKit

class NotifActivityTableViewCell: UITableViewCell {
    
    var dateView: UIView = {
       let aView = UIView()
        aView.backgroundColor = AppUsabilities.dateViewColor
        return aView
    }()
    var RemainingcontentView: UIView = {
       let aView = UIView()
        aView.backgroundColor = AppUsabilities.remainingContentViewColor
        return aView
    }()
    
    var cellView: UIView = {
        let aView = UIView()
        aView.backgroundColor = .clear
        aView.layer.masksToBounds = true
        aView.layer.cornerRadius = 5.0
        return aView
    }()
    
    var lblDate: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = AppUsabilities.dateFont
        return lbl
    }()
    
    var lblMonth: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.font = AppUsabilities.monthFont
        return lbl
    }()
    
    var lblTypeName: UILabel = {
        
        let lbl: UILabel = UILabel()
        lbl.font = AppUsabilities.TypeTitleFont
        lbl.textColor = AppUsabilities.TypeTitleFontColor
        return lbl
    }()
    
    var lblAddress: UILabel = {
        
        let lbl: UILabel = UILabel()
        lbl.font = AppUsabilities.addressFont
        lbl.textColor = .white
        lbl.numberOfLines = 3
        return lbl
    }()
    
    var lblTime: UILabel = {
        
        let lbl: UILabel = UILabel()
        lbl.font = AppUsabilities.timeFont
        lbl.textColor = .white
        lbl.textAlignment = .right
        
        return lbl
    }()
    
    var TypeImgV: UIImageView = {
       
        let imgV: UIImageView = UIImageView()
        imgV.backgroundColor = .clear
        
        return imgV
    }()
    
    var GPSImgV: UIImageView = {
        
        let imgV: UIImageView = UIImageView()
        imgV.backgroundColor = .clear
        imgV.image = #imageLiteral(resourceName: "GPS")
        imgV.isHidden = true
        
        return imgV
    }()
    
    func loadCell()
    {
        
        self.backgroundColor = .white
        
        
        dateView.addSubview(lblDate)
        dateView.addSubview(lblMonth)
        cellView.addSubview(dateView)
        
        RemainingcontentView.addSubview(TypeImgV)
        RemainingcontentView.addSubview(lblTypeName)
        RemainingcontentView.addSubview(lblTime)
        RemainingcontentView.addSubview(lblAddress)
        RemainingcontentView.addSubview(GPSImgV)
        cellView.addSubview(RemainingcontentView)
        self.addSubview(cellView)
        
    }
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}


