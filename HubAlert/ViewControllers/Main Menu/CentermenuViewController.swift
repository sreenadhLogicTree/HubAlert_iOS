//
//  CentermenuViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class CentermenuViewController: BaseViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet var addressView: UIView!
    @IBOutlet var addressheightConstraint: NSLayoutConstraint!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var gpsSwitch: UISwitch!
    @IBOutlet var lblModule: UILabel!
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var sendNotificationButton: UIButton!
    var buttonsPageController: MenuButtonsViewController?
    fileprivate var tapgesture:UITapGestureRecognizer?
    fileprivate var tapButton: UIButton?
    weak var delegate: CentermenuDelegate?
    var customAlertVC:CustomizedAlertController?
    
    @IBOutlet var rightMenuBtn: UIButton!
    @IBOutlet var pagecontrolHeightConstraint: NSLayoutConstraint!
    
    /*required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }*/
    
    var isShowingMenu:Bool = false{
        
        didSet{
            if isShowingMenu{
                addTapGesture()
            }
            else{
                removeTapGesture()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().delegate = self
        hidePageControl()

        // Do any additional setup after loading the view.
        /*if let buttonsPageController = buttonsPageController{
        buttonsPageController.designWith(buttons: 10)
        }*/
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getAlertModules()
        
        if let isgps = UserDefaults.standard.value(forKey: AppKeys.isGPSSelected) as? Bool
        {
        gpsSwitch.isOn = isgps
        }
        gpsPosition()
    }
    
    @IBAction func pageValueChanged(_ sender: UIPageControl) {
        
        
    }
    func addTapGesture(){
        
        if let tapbtn = tapButton {
            
            tapbtn.isHidden = false
        }
        else{
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
            //button.backgroundColor = .yellow
            button.addTarget(self, action: #selector(closeMenu(gesture:)), for: .touchUpInside)
            view.addSubview(button)
            tapButton = button
        }
        print("add Tapbutton")

       /*let tapgeture = UITapGestureRecognizer(target: self, action: #selector(closeMenu(gesture:)))
        view.addGestureRecognizer(tapgeture)
        tapgesture = tapgeture*/
    }
    
    func removeTapGesture(){
        guard let btn = tapButton else { return  }
        btn.isHidden = true
        print("removed Tapbutton")
       // btn.removeFromSuperview()
        /*guard let tapgesture = tapgesture else { return }
        view.removeGestureRecognizer(tapgesture)*/
    }
    
    @objc func closeMenu(gesture:UIButton){
        delegate?.leftmenuTapped()

    }
    
    func showSendNotification(){
        sendNotificationButton.isHidden = false
    }
    func hideSendNotification(){
        sendNotificationButton.isHidden = true
    }
    
    func showPageControl(){
        pagecontrolHeightConstraint.constant = 40.0
        pageControl.isHidden = false
        self.view.layoutIfNeeded()
    }
    
    func hidePageControl(){
        pagecontrolHeightConstraint.constant = 0.0
        pageControl.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    func getAlertsOfSelectedModule(isShowNotificationList:Bool){
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        guard let profileId = appdelegate.currentProfileid else { return  }
        guard let moduleId = appdelegate.currentModuleid else { return  }
        guard let moduleName = appdelegate.currentModuleName as? String else{return}
        lblModule.text = moduleName
        buttonsPageController?.removeallpages()

        buttonsPageController?.getAlerts(formoduleId: moduleId, profileID: profileId)
        
        if isShowNotificationList{
            showCurrentNotificationList()
        }
    }
    
    // MARK: - User Actions
    
    @IBAction func sendNotificationTapped(_ sender: UIButton) {
        //TODO RamaKrishna
        
        showSendFeedBackView(isFeedback: false)
        
        
    }
    @IBAction func GPSTapped(_ sender: UITapGestureRecognizer) {
        
        gpsSwitch.isOn = gpsSwitch.isOn ? false : true
        gpsPosition()
    }
    @IBAction func gpsChanged(_ sender: UISwitch) {
        
        gpsPosition()
    }
    private func gpsPosition(){
        
        if gpsSwitch.isOn{
            
            getAddressFromLatLon()
            
        }
        else{
            print("off location ")
            hideAddress()
            
        }
        
        UserDefaults.standard.set(gpsSwitch.isOn, forKey: AppKeys.isGPSSelected)
    }
    private func hideAddress(){
        
        addressView.isHidden = true
    
    }
    private func showAddress(){
        addressView.isHidden = false
        addressheightConstraint.constant = 50.0
        self.view.layoutIfNeeded()
        addressView.layoutIfNeeded()
    }
    func getAddressFromLatLon() {
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
         let location = appdelegate.currentLocation
        print("location - \(location)")
        
        if appdelegate.isInternetAvailable(){
            
        }
        else{
            showNoInternetAlert()
            return
        }

    let ceo: CLGeocoder = CLGeocoder()
    
    
    ceo.reverseGeocodeLocation(location, completionHandler:
    {(placemarks, error) in
    if (error != nil)
    {
    print("reverse geodcode fail: \(error!.localizedDescription)")
    }
    let pm = placemarks! as [CLPlacemark]
    
    if pm.count > 0 {
    let pm = placemarks![0]
    print(pm.country)
    print(pm.locality)
    print(pm.subLocality)
    print(pm.thoroughfare)
    print(pm.postalCode)
    print(pm.subThoroughfare)
    var addressString : String = ""
    if pm.subLocality != nil {
    addressString = addressString + pm.subLocality! + ", "
    }
    if pm.thoroughfare != nil {
    addressString = addressString + pm.thoroughfare! + ", "
    }
    if pm.locality != nil {
    addressString = addressString + pm.locality! + ", "
    }
    if pm.administrativeArea != nil {
    addressString = addressString + pm.administrativeArea! + ", "
    }
    if pm.postalCode != nil {
    addressString = addressString + pm.postalCode! + " "
    }
    
    
    print(addressString)
        DispatchQueue.main.async {
            self.lblAddress.text = addressString
            self.showAddress()
        }
    }
    })
    
    }
    
    @IBAction func leftMenuTapped(_ sender: UIButton) {
        delegate?.leftmenuTapped()
    }
    
    @IBAction func rightmenuTapped(_ sender: UIButton) {
        
        //TODO - RamaKrishna
        
//        showSendFeedBackView()
        //showNotificationsSentList()
        
    }
    
    private func showCurrentNotificationList(){
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
            
            guard let profileid = appdelegate.currentProfileid else {return}
            guard let hubAlertid = appdelegate.currentAlertId else {return}
            guard let userModuleid = appdelegate.currentModuleid else {return}
            
            showNotificationsSentList(profileId: profileid, hubAlertId: hubAlertid, userModuleId: userModuleid)
        }
    }
    
    private func showNotificationsSentList(profileId:Int64, hubAlertId:Int64, userModuleId:Int64) {
        
      //  let notif = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "NotificationActivity") as! NotificationActivityViewController
        
        let nav = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "NotificationVC") as! UINavigationController
        let notif = nav.viewControllers[0] as! NotificationActivityViewController

        
        notif.alertId = hubAlertId
        notif.profileId = profileId
        notif.userModuleId = userModuleId
        
        notif.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        nav.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)

        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true) {
            
        }
    }
    
    private func showSendFeedBackView(isFeedback:Bool)
    {
        /*let customAlert: CustomizedAlertController? = CustomizedAlertController(nibName: "CustomizedAlertController", bundle: Bundle.main)
        guard let custAlert = customAlert else {
            return
        }
        let customAlert:Cus*/
        
        //self.performSegue(withIdentifier: "customMessage", sender: self)
        
        let customAlert = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "customAlert") as! CustomizedAlertController
        customAlert.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        customAlert.delegate = self
        customAlert.view.bounds = view.bounds
        customAlert.isFeedback = isFeedback
        view.addSubview(customAlert.view)
        customAlertVC = customAlert
        
    }
    
    private func sendAlert(subject:String, message:String){
        
        
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
        var profileid:Int64
        
        
            if gpsSwitch.isOn{
            latitude = appdelegate.currentLocation.coordinate.latitude
            longitude = appdelegate.currentLocation.coordinate.longitude
            }
            profileid = appdelegate.currentProfileid!
            
        showLoader()
        
        let dictAlert = [NetworkKeys.pItemID : appdelegate.generalAlertid,
                         NetworkKeys.pProfileID : profileid,
                         NetworkKeys.pMobileNumber : mobileNumber,
                         NetworkKeys.pLatitude : latitude,
                         NetworkKeys.pLongitude : longitude,
                         NetworkKeys.pDeviceID : deviceid,
                         NetworkKeys.pDeviceType : NetworkValues.DeviceType,
                         NetworkKeys.pUniqueID : uniqueid,
                         NetworkKeys.pMessage : message,
                         NetworkKeys.pSubject : subject]
        let service = ServiceHandler()
        service.delegate = self
        service.sendAlertRequest(withDict: dictAlert as [String : AnyObject])
    }
    
    private func sendFeedback(subject:String, message:String){
        
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if appdelegate.isInternetAvailable(){
            
        }
        else{
            showNoInternetAlert()
            return
        }
        
        guard let mobileNumber = UserDefaults.standard.value(forKey: AppKeys.VerifiedPhoneNumber) else { return  }
       
        let profileid = appdelegate.currentProfileid!
        
            showLoader()
            
            let dictAlert = [
                             NetworkKeys.pProfileID : profileid,
                             NetworkKeys.pMobileNumber : mobileNumber,
                             NetworkKeys.pMessage : message,
                             NetworkKeys.pSubject : subject]
            let service = ServiceHandler()
            service.delegate = self
            service.sendFeedbackRequest(withDict: dictAlert as [String : AnyObject])
        
    }
    
    //MARK: - Notification Receiving
    private func scheduleLocalNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Cocoacasts"
        notificationContent.subtitle = "Local Notifications"
        notificationContent.body = "In this tutorial, you learn how to schedule local notifications with the User Notifications framework."
        
        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "buttonsScroll"{
            
            buttonsPageController = (segue.destination as! MenuButtonsViewController)
            buttonsPageController?.menupageControl = pageControl
            
        }
        else if segue.identifier == "popoversegue"{
            
            let popoverVC = segue.destination as! RightmenuViewController
            popoverVC.modalPresentationStyle = .popover
            popoverVC.popoverPresentationController!.delegate = self
            //popoverVC.popoverPresentationController?.sourceRect = rightMenuBtn.frame
            popoverVC.delegate = self
        }
        else if segue.identifier == "customMessage"{
            
            let customVC = segue.destination as! CustomizedAlertController
            /*customVC.modalPresentationStyle = .popover
            customVC.popoverPresentationController!.delegate = self*/
            customVC.delegate = self
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func isPreviousSelectedProfileExisting(profiles:[AnyObject])->(Bool){
        
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
            
            guard let pid = appdelegate.currentProfileid else{return false}
            guard let mid = appdelegate.currentModuleid else{return false}
            
            if pid > Int64(0) && mid > Int64(0) {
                
                if let index = profiles.firstIndex(where: { $0["ProfileID"] as? Int64 == pid}){
                    
                    guard let modules = profiles[index]["Modules"] as? [[AnyHashable:AnyObject]] else {return false}
                    if modules.firstIndex(where: { $0["UserModuleID"] as? Int64 == mid}) != nil{return true}
                 
                }
               
            }
            
        }
        
        return false
    }
    

    
    //MARK: - Network Calls
    private func getAlertModules(){
        
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else{return}
        if appdel.isInternetAvailable(){
        }
        else{
            showNoInternetAlert()
            return
        }
        
        delegate?.showLoading()
        let mobileNumber = UserDefaults.standard.value(forKey: AppKeys.VerifiedPhoneNumber) as! String
        var deviceID:String
        if UserDefaults.standard.value(forKey: AppKeys.DeviceToken) != nil{
            deviceID = UserDefaults.standard.value(forKey: AppKeys.DeviceToken) as! String
        }
        else{
            deviceID = ""
        }
        let uniqueID = UserDefaults.standard.value(forKey: AppKeys.UniqueID) as! String
        
        let dictRequest:[String : String] = [NetworkKeys.pMobileNumber: mobileNumber,
                                             NetworkKeys.pDeviceID : deviceID,
                                             NetworkKeys.pDeviceType : NetworkValues.DeviceType,
                                             NetworkKeys.pUniqueID : uniqueID,
                                             NetworkKeys.pAppVersion : NetworkValues.Appversion]
        let serviceHandler = ServiceHandler()
        serviceHandler.delegate = self
        serviceHandler.getAlertModulesRequest(withDict: dictRequest as [String : AnyObject])
    }
    
   

}

extension CentermenuViewController:ServiceHandler_Delegate{
    
    func unauthorized(alert: String) {
        showAlertToNavigateHome(title: "", message: alert)
    }
    func otherError(alert:String){
        showAlert(title: "", message: alert)
        
    }
    
    func alertModules(response:[AnyHashable : AnyObject]){
        
        delegate?.removeLoading()
        
        print("response - \(response)")
        guard let dictModules = response["Response"] as? AnyObject else {
            
            return
        }
        
        guard let profiles:[AnyObject] = dictModules["Modules"] as? [AnyObject] else{
            return
        }
        
        if profiles.count > 0{
            
            delegate?.fetchedProfiles(profiles: profiles)
            
            var profileId:Int64?, moduleid:Int64?
            
            if isPreviousSelectedProfileExisting(profiles: profiles){
                
                if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
                 profileId = appdelegate.currentProfileid
                    moduleid = appdelegate.currentModuleid
                lblModule.text = appdelegate.currentModuleName
                }
            }
            else{
                
                let dict = profiles[0]
                guard let pId = dict["ProfileID"] as? Int64 else{return}
                guard let modules:[[AnyHashable:AnyObject]] = dict["Modules"] as? [[AnyHashable:AnyObject]] else{return}
                
                if modules.count > 0{
                    let module = modules[0]
                    guard let mId = module["UserModuleID"] as? Int64 else{return}
                    guard let alertId = module["AlertID"] as? Int64 else{return}
                    guard let moduleName = module["ModuleName"] as? String else{return}
                    
                    moduleid = mId
                    profileId = pId
                    
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.currentProfileid = profileId
                    appdelegate.currentModuleid = moduleid
                    appdelegate.currentModuleName = moduleName
                    appdelegate.currentAlertId = alertId
                    lblModule.text = moduleName
                    
                }
            }
            
            guard let pid = profileId else{return}
            guard let mid = moduleid else{return}

            buttonsPageController?.getAlerts(formoduleId: mid, profileID: pid)

        }
        
        guard let nointernetmsg = dictModules["NoInternet"] as? String else{return}
        UserDefaults.standard.setValue(nointernetmsg, forKey: AlertTitles.offline)
    }
    
    func alertSent(response: [AnyHashable : AnyObject]) {
        
        // removeLoader()
        print("response - \(response)")
        // sleep(UInt32(1.0))
        dismiss(animated: true) {
        
        self.customAlertVC?.view.removeFromSuperview()
        guard let dict = response["Response"] else { return  }
        guard let message = dict["Message"] else { return  }
        self.showAlert(title: "", message: message as! String)
        }

        /*dismiss(animated: true) {
            
        }*/
    }
    
    func feedbackSent(response: [AnyHashable : AnyObject]) {
        
        print("response - \(response)")
        dismiss(animated: true) {

        self.customAlertVC?.view.removeFromSuperview()

        guard let dict = response["Response"] else { return  }
        guard let message = dict["Message"] else { return  }
        self.showAlert(title: "", message: message as! String)
        }
        /*dismiss(animated: true) {
            
        }*/
    }
    
}

extension CentermenuViewController:CustomMessageDelegate{
    
    func send(with title: String, message: String, isFeedback: Bool) {
        
        if isFeedback{
            //calling 'Feedback' service
            sendFeedback(subject: title, message: message)

        }
        else{
            //calling 'Send Notification' service
            sendAlert(subject: title, message: message)
            
        }
    }
}

extension CentermenuViewController:RightMenuDelegate{
    
    func selectedOption(index: Int) {
        switch index {
        case 0:
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
                
                guard let profileid = appdelegate.currentProfileid else {return}
                guard let hubAlertid = appdelegate.currentAlertId else {return}
                guard let userModuleid = appdelegate.currentModuleid else {return}

            showNotificationsSentList(profileId: profileid, hubAlertId: hubAlertid, userModuleId: userModuleid)
            }
        default:
            showSendFeedBackView(isFeedback: true)
        }
    }
}

extension CentermenuViewController:UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
            if let dict = response.notification.request.content.userInfo as? [String : Any]{
                
                if let pid = dict["agencyId"] as? String{
                    
                    if let aid = dict["HAID"] as? String{
                     
                        delegate?.loadProfile(profileId: Int64(pid)!, alertId: Int64(aid)!)
                    
                    }
                }
                
            }
        completionHandler()
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound, .badge])

    }
}
