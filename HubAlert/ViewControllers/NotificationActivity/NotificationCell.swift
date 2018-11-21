//
//  NotificationCell.swift
//  HubAlert
//
//  Created by Sreenadh G on 03/11/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet var lblDate: UILabel!
    @IBOutlet var imgAlertType: UIImageView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblAlertName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var imgLocation: UIImageView!
    
    var dictNotification:[String:AnyObject] = [:]{
        
        didSet{
            updateUserInterface()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUserInterface(){
        
        if let strName = dictNotification["Name"] as? String{
            self.lblAlertName.text = strName
        }
        
        if let sentDate = dictNotification["DateSent"] as? String{
            setFormattedDate(strDate: sentDate)
        }
        
        var strAddress: String? = ""
        if let strAdd = dictNotification["Location"] as? String{
            if strAdd.count > 0{
                strAddress = strAddress! + strAdd
                imgLocation.isHidden = false
            }
            else{
                imgLocation.isHidden = true
            }
            
        }
        else{
            imgLocation.isHidden = true
        }
        
        if let sentBy = dictNotification["SendBy"] as? String{
            strAddress = strAddress! + "\n\nSent By:" + sentBy
        }
        
        lblAddress.text = strAddress
        
        guard let imageUrl = dictNotification["Icon"] as? String else { return }
        
        if imageUrl.count > 0{
            loadAlertImage(imageurl: imageUrl)
        }
        
    }
    
    private func setFormattedDate(strDate:String){
        
            let dateitems = formattedDateTime(strDate: strDate)
            
            lblTime.text = dateitems.1
            
            if dateitems.0.count > 2{
                
                let amountText = NSMutableAttributedString.init(string: dateitems.0)
                
                print("amountText - \(amountText)")
                // set the custom font and color for the 0,1 range in string
                amountText.setAttributes([NSAttributedString.Key.font: Fonts.Medium.of(style: .title1),
                                          ],
                                         range: NSMakeRange(0, 2))
                amountText.setAttributes([NSAttributedString.Key.font: Fonts.Medium.of(style: .title2),
                                          ],
                                         range: NSMakeRange(2, 2))
                lblDate.attributedText = amountText
                
            }
            else{
                lblDate.text = dateitems.0
            }
            
    }
    
    private func formattedDateTime(strDate:String) ->(String, String){
        
        print("@@@@ date - \(strDate)")
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy hh:mm:ss a"
        
        guard let dateTime = dateFormat.date(from: strDate) else{return ("", "")}
        dateFormat.dateFormat = "dd \n MMM "
        print("Date - \(dateTime)")
        
        let strDate = dateFormat.string(from: dateTime)
        
        dateFormat.dateFormat = "hh:mm a"
        dateFormat.amSymbol = "AM"
        dateFormat.pmSymbol = "PM"
        
        let strTime = dateFormat.string(from: dateTime)
        
        return(strDate.uppercased(),strTime)
    }
    
    private func loadAlertImage(imageurl:String){
        
        guard let url = URL(string: imageurl) else { return  }
        
        imgAlertType.notificationload(url: url)
        
    }

}
