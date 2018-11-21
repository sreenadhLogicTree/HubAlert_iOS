//
//  MenuButtonsViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 27/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class MenuButtonsViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    var menupageControl:UIPageControl?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.height - 50, width: view.frame.width, height: 50.0))
        pageControl.backgroundColor = .yellow
        
        pageControl.currentPageIndicatorTintColor = AppColors.bgBottomColor
        view.addSubview(pageControl)*/
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func designWith(alerts:[AnyObject]){
        
        pages.removeAll()
        guard var alerts = alerts as? [[String:AnyObject]] else { return  }
        
        guard let appdel = UIApplication.shared.delegate as? AppDelegate else{return}
    
        guard let centerVC = self.parent as? CentermenuViewController else {return}
        
        if let index = alerts.firstIndex(where: { $0["Type"] as? String == "117"}){
            
            
            let dict = alerts[index]
            appdel.generalAlertid = dict["ItemID"] as! Int64

            alerts.remove(at: index)
            centerVC.showSendNotification()
            
            
        }
        else{
            centerVC.hideSendNotification()
        }
        
        let buttons = alerts.count
        var noofpages = (buttons/6)
        
        if buttons % 6 != 0{
            noofpages += 1
        }
        
        var lowerIndex , upperIndex : Int
        
        for page in 1...noofpages{
            
            let buttonsDisplayVC = self.storyboard?.instantiateViewController(withIdentifier: "buttonspage") as! ButtonsPageViewController
            
            lowerIndex = ((page - 1) * 6 + 1)
            upperIndex =  ((page - 1) * 6 + 6)
            
            if page == noofpages && (buttons % 6 > 0) {
                
                upperIndex =  ((page - 1) * 6 + (buttons % 6))
                
            }
            
            buttonsDisplayVC.lowerIndex = lowerIndex
            buttonsDisplayVC.upperIndex = upperIndex
            
            //print("Alerts count - \(alerts) , \(lowerIndex), \(upperIndex)")
            buttonsDisplayVC.alerts = Array(alerts[lowerIndex-1...upperIndex-1])
            
            pages.append(buttonsDisplayVC)
            
            
        }
        
        print("count - \(pages.count)")
        
        self.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        self.delegate = self
        self.dataSource = self
        

        if pages.count > 1{
            
            centerVC.showPageControl()
            centerVC.pageControl.numberOfPages = pages.count

        }
        else{
            centerVC.hidePageControl()
            centerVC.pageControl.numberOfPages = 0


        }
        centerVC.pageControl.isUserInteractionEnabled = false
        
      /*  pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)*/
        
        
    }
    
    func showLoader(){
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func removeLoader(){
        
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //MARK: - Service Calls
    func removeallpages(){
        pages.removeAll()
        pages.append(UIViewController.init())
        self.setViewControllers(pages, direction: .forward, animated: true, completion: nil)
        self.delegate = self
        self.dataSource = self
    }
    func getAlerts(formoduleId:Int64, profileID:Int64){
        
        let mobileNumber = UserDefaults.standard.value(forKey: AppKeys.VerifiedPhoneNumber) as! String
        
        let dictRequest:[String : AnyObject] = [NetworkKeys.pMobileNumber: mobileNumber as AnyObject,
                                                NetworkKeys.pUserModuleID : formoduleId as AnyObject,
                                                NetworkKeys.pProfileID : profileID as AnyObject]
        let serviceHandler = ServiceHandler()
        serviceHandler.delegate = self
        serviceHandler.getAlertsRequest(withDict: dictRequest)
    }
    // MARK: - PageViewController Delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else {return nil}
        
        //pageControl.currentPage = index
        var preIndex = index - 1
        
        if preIndex < 0{
            return nil
            //preIndex = pages.count - 1
        }
        menupageControl?.currentPage = preIndex

        return pages[preIndex] as UIViewController
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = pages.firstIndex(of: viewController) else {return nil}
       // pageControl.currentPage = index

        let nextIndex = index + 1
        
        if nextIndex >= pages.count{
            return nil
            //nextIndex = 0
        }
        
        menupageControl?.currentPage = nextIndex
        
        return pages[nextIndex] as UIViewController
        
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        
        return 0
       
    }
    
   /* func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        return 0

        
    }*/


}

//Mark : - Network callbacks

extension MenuButtonsViewController:ServiceHandler_Delegate{
    
    func unauthorized(alert: String) {
        
        guard let centerVC = self.parent as? CentermenuViewController else {return}
        centerVC.showAlertToNavigateHome(title: "", message: alert)
    }
    
    func otherError(alert:String){
        guard let centerVC = self.parent as? CentermenuViewController else {return}
        centerVC.showAlert(title: "", message: alert)
        
        removeallpages()

    }

    
    func alerts(response:[AnyHashable : AnyObject]){
        print("response - \(response)")
        
        guard let alerts = response["Response"] as? [AnyObject] else { return  }
        
        if alerts.count > 0{
            
            designWith(alerts: alerts)
        }
        

    }

}



