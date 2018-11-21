//
//  ButtonsPageViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 27/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class ButtonsPageViewController: BaseViewController {

    
    @IBOutlet var stackBGView: UIView!
    var lowerIndex = 0, upperIndex: Int = 0
    
    var alerts:[[String:AnyObject]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        addButtons(from: lowerIndex, to: upperIndex)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(stackBGView.frame.height)
    }
    
    func addButtons(from lowerIndex: Int, to upperIndex: Int){        
        
        let totalButtons = upperIndex - lowerIndex + 1
        let rows = (totalButtons/2) + (totalButtons % 2)
        var tag = lowerIndex
        print(stackBGView.frame.height)

        let rowHeight = stackBGView.frame.height/3.0
        let spaceAround:CGFloat = 5.0
        let itemHeight:CGFloat = (rowHeight - (2 * spaceAround))
        var ypos = spaceAround
        var index = 0
        for row in 1...rows{
            
            if totalButtons % 2 != 0 && row == 1{
                // show first button in first row
                
                let btn = addButtonView(withTag: tag, alert: alerts[index])
                btn.translatesAutoresizingMaskIntoConstraints = false;
                stackBGView.addSubview(btn)

                self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: stackBGView, attribute: .top, multiplier: 1.0, constant: spaceAround))
                self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: stackBGView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
                self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: stackBGView, attribute: .height, multiplier: 0.3, constant: -(2 * spaceAround)))
                self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1.3, constant: 0.0))
                tag += 1
                index += 1
                
            }
            else{
               // xpos = (stackBGView.frame.width - (2 * itemHeight))/3.0
                
                for item in 0...1{
                    
                    let btn = addButtonView(withTag: tag, alert: alerts[index])
                    btn.translatesAutoresizingMaskIntoConstraints = false;

                    stackBGView.addSubview(btn)

                    self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerX, relatedBy: .equal, toItem: stackBGView, attribute: .centerX, multiplier: (CGFloat(item) + 0.5), constant: 0.0))
                    if row == 1{
                        
                        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .top, relatedBy: .equal, toItem: stackBGView, attribute: .top, multiplier: 1, constant: spaceAround))

                    }
                    else if row == 3{
                        self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .bottom, relatedBy: .equal, toItem: stackBGView, attribute: .bottom, multiplier: 1, constant: -spaceAround))
                    }
                    else{
                    self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .centerY, relatedBy: .equal, toItem: stackBGView, attribute: .centerY, multiplier: CGFloat(row) * 0.5, constant: 0.0))
                    }

                    self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .height, relatedBy: .equal, toItem: stackBGView, attribute: .height, multiplier: 0.3, constant: -(2 * spaceAround)))
                    self.view.addConstraint(NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: btn, attribute: .height, multiplier: 1.3, constant: 0.0))
                    tag += 1
                    index += 1
                }
                
                ypos += itemHeight + (spaceAround)

            }
            
           
            
        }

    }
    
    private func addButtonView(withTag tag:Int, alert:[String:AnyObject]) -> MenuButton{
        
        print("alert - \(alert)")
        
        let menuButton = MenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //let menuButton = MenuButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //let menuButton = UIButton()
        menuButton.alertItem = alert
        menuButton.tag = tag
        menuButton.delegate = self
        return menuButton
    }
    
    private func makePhoneCall(phone:String){
        
        if phone.count > 0{
           
            if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url){
                
                UIApplication.shared.open(url, options:[:], completionHandler: nil)
            }
        }
    }
    
    //MarK: _ WebService calls
    private func sendAlert(itemid:Int64, profileId:Int64, message:String){
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if appdelegate.isInternetAvailable(){
            
        }
        else{
            showNoInternetAlert()
            return
        }
        
        guard let mobileNumber = UserDefaults.standard.value(forKey: AppKeys.VerifiedPhoneNumber) else { return  }
        guard let deviceid = UserDefaults.standard.value(forKey: AppKeys.DeviceToken) else { return  }
        
        guard let uniqueid = UserDefaults.standard.value(forKey: AppKeys.UniqueID) else { return  }
        
        var latitude = 0.0000, longitude = 0.0000
        
            if (UserDefaults.standard.value(forKey: AppKeys.isGPSSelected) as? Bool)!{
            latitude = appdelegate.currentLocation.coordinate.latitude
            longitude = appdelegate.currentLocation.coordinate.longitude
            }
            
        
        
       // showLoader()

        let dictAlert = [NetworkKeys.pItemID : itemid,
                         NetworkKeys.pProfileID : profileId,
                         NetworkKeys.pMobileNumber : mobileNumber,
                         NetworkKeys.pLatitude : latitude,
                         NetworkKeys.pLongitude : longitude,
                         NetworkKeys.pDeviceID : deviceid,
                         NetworkKeys.pDeviceType : NetworkValues.DeviceType,
                         NetworkKeys.pUniqueID : uniqueid,
                         NetworkKeys.pMessage : message,
                         NetworkKeys.pSubject : ""]
        let service = ServiceHandler()
        service.delegate = self
        service.sendAlertRequest(withDict: dictAlert as [String : AnyObject])
        
        print("dictAlert - \(dictAlert)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ButtonsPageViewController:AlertDelegate{
    
    func alertTapped(sender:MenuButton){
        
        var strAlert = "Are you sure you want to continue?"
        
        if let alert = sender.alertItem?["ConfirmationAlert"] as? String{
            
            strAlert = alert
        }
        
        let alert = UIAlertController.init(title: "", message: strAlert, preferredStyle: .alert)
        alert.view.tintColor = AppColors.bgBottomColor
        let alertAction = UIAlertAction(title: "Yes", style: .default) { (alertAction) in
            
            sender.isSelected = false
            
            guard let item = sender.alertItem else {return}
            
             guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            
            guard let itemid = item["ItemID"] as? Int64 else {return}
            
            guard let pid = appdelegate.currentProfileid as? Int64 else {return}


            self.sendAlert(itemid: itemid, profileId: pid, message: "")
            
            guard let phoneNum = item["PhoneNumber"] as? String else {return}

            self.makePhoneCall(phone: phoneNum)

        }
        
        let alertActionNo = UIAlertAction(title: "Cancel", style: .default) { (alertActionNo) in
            self.dismiss(animated: true, completion: nil)
            sender.isSelected = false

        }
        alert.addAction(alertAction)
        alert.addAction(alertActionNo)
        present(alert, animated: true, completion: nil)
        

    }
    
}

extension ButtonsPageViewController:ServiceHandler_Delegate{
    
    func unauthorized(alert: String) {
        showAlertToNavigateHome(title: "", message: alert)
    }
    
    func otherError(alert:String){
        //removeLoader()
       // sleep(UInt32(1.0))
        
        dismiss(animated: true) {
            self.showAlert(title: "", message: alert)

        }

    }
    func alertSent(response: [AnyHashable : AnyObject]) {
        
       // removeLoader()
        print("response - \(response)")
       // sleep(UInt32(1.0))
        dismiss(animated: true) {
           /* guard let dict = response["Response"] else { return  }
            guard let message = dict["Message"] else { return  }
            self.showAlert(title: "", message: message as! String)*/
        }

        
    }
    
    
}
