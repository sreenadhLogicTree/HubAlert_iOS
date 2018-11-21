//
//  NotificationActivityViewController.swift
//  HubAlertSample
//
//  Created by Thirupathi on 26/10/18.
//  Copyright © 2018 Rama Krishna. All rights reserved.
//

import UIKit

class NotificationActivityViewController: BaseViewController {

    @IBOutlet var tblNotifications: UITableView!
    var arrNotifications:[AnyObject] = []
    var alertId:Int64?
    var profileId:Int64?
    var userModuleId:Int64?

    @IBOutlet var whiteViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if arrNotifications.count == 0{
        getNotificationsList()
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK - NetworkCalls
    func getNotificationsList()
    {
        
       guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if appdelegate.isInternetAvailable(){
            
        }
        else{
            showNoInternetAlert()
            return
        }
        
        guard let mobileNumber = UserDefaults.standard.value(forKey: AppKeys.VerifiedPhoneNumber) else { return  }
        
        guard let profileid = self.profileId else {return}
        guard let alertid = self.alertId else {return}
        guard let moduleId = self.userModuleId else {return}
        
            showLoader()
            
            let dictAlert = [
                NetworkKeys.pProfileID : profileid,
                NetworkKeys.pMobileNumber : mobileNumber,
                NetworkKeys.pUserModuleID : moduleId,
                NetworkKeys.pHubAlertID : alertid]
            let service = ServiceHandler()
            service.delegate = self
            service.getNotifications(withDict: dictAlert as [String : AnyObject])
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "NotificationDetail"{
            let detailVC = segue.destination as? NotificationDetailViewController
            detailVC?.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
            detailVC?.dictDetail = arrNotifications[(tblNotifications.indexPathForSelectedRow?.row)!] as? [String : Any]

        }
    }
    

}

extension NotificationActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "NotificationDetail", sender: self)
    }
    
}

extension NotificationActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
            return arrNotifications.count
       
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppReuseIDs.notificationCell, for: indexPath) as! NotificationCell
        
        cell.dictNotification = arrNotifications[indexPath.row] as! [String:AnyObject]
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            perform(#selector(resetTableheight), with: nil, afterDelay: 1.0)
        }
        
        return cell
    }
    
    @objc func resetTableheight(){
        
        
        print("tblcontent2 - \(tblNotifications.contentSize)")
        if tblNotifications.contentSize.height < tblNotifications.frame.height{
         whiteViewBottomConstraint.constant += tblNotifications.frame.height - tblNotifications.contentSize.height
         view.layoutIfNeeded()
         }
    }
    
}

extension NotificationActivityViewController: ServiceHandler_Delegate {
    func unauthorized(alert: String) {
        
        showAlertToNavigateHome(title: "", message: alert)
    }
    
    func otherError(alert: String) {
        
        dismiss(animated: true) {
            
            self.showAlert(title: "", message: alert)

        }

    }
    
    func alertsReceived(response:[AnyHashable : AnyObject]) {
        
        
        removeLoader()
        guard let notifications:[AnyObject] = response["Response"] as? [AnyObject] else {
            
            return
        }
        
        self.arrNotifications = notifications
        self.tblNotifications.reloadData()
        
        view.layoutSubviews()
        
        print("tblcontent1 - \(tblNotifications.contentSize)")

        
    }
    
    
        
    
}


struct AppUsabilities {
    
    //static let serviceUrl: String = "http://mservice.logictree.it/HubAlert/api/"//Live
    static let serviceUrl: String = "http://stmservice.logictree.it/HubAlert/api/"//Stage
    
    static let cellViewYpos: CGFloat = 10.0
    static let cellViewHeight: CGFloat = 110.0
    static let TotalCellHeight: CGFloat = 120.0//cellViewYpos+cellViewHeight
    
    static let cellViewXpos: CGFloat = 15.0
    
    static let activityViewYPOS: CGFloat = 100.0
    static let constantLead: CGFloat = 20.0
    static let constantVGap: CGFloat = 20.0
    
    static let tblYpoS: CGFloat = 50.0
    
    static let remainingContentViewColor: UIColor = UIColor(red: 239.0/255.0, green: 56.0/255.0, blue: 91.0/255.0, alpha: 1.0)
    static let dateViewColor: UIColor = UIColor(red: 217.0/255.0, green: 50.0/255.0, blue: 83.0/255.0, alpha: 1.0)
    
    static let dateLblWidth: CGFloat = 45.0;
    static let dateLblHeight: CGFloat = 35.0;
    static let monthLblWidth: CGFloat = 45.0;
    static let monthLblHeight: CGFloat = 30.0;
    
    static let dateFont: UIFont = UIFont(name: "Helvetica Neue", size: 35.0)!
    static let monthFont: UIFont = UIFont(name: "Helvetica Neue", size: 20.0)!
    
    static let TypeTitleFont: UIFont = UIFont(name: "Helvetica Neue", size: 25.0)!
    static let addressFont: UIFont = UIFont(name: "Helvetica Neue", size: 14.0)!
    static let timeFont: UIFont = UIFont(name: "Helvetica Neue", size: 10.0)!
    static let TypeTitleFontColor: UIColor = UIColor(red: 255.0/255.0, green: 153.0/255.0, blue: 171.0/255.0, alpha: 1.0)
    
    //Remove following
    static let AssignDynamic1: String = "04"
    static let AssignDynamic2: String = "SEP"
    static let numberOfCells: Int = 40
    
}

class NotifActivityType: NSObject {
    
    //NA means NotificationActivity
    var TitleFor_NA: String!
    var AddressFor_NA: String!
    var ImgUrlFor_NA: String!
    var DateFor_NA: Date!
    var isGPSHiddenFor_NA: Bool = true
    
    //Remove following
    override init() {
        self.TitleFor_NA = "MEDICAL EMERGENCY"
        self.AddressFor_NA = "6060 Sunrise vista drive, suite 3500 Citrus heights, CA 95610."
        self.ImgUrlFor_NA = "https://www.uspdhub.com/Upload/ComingSoonIcons/480x800.png?time=20181016112329259"
        self.DateFor_NA = Date()
        self.isGPSHiddenFor_NA = false
    }
    
}
