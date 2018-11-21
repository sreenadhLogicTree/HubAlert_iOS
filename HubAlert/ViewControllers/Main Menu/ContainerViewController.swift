//
//  ContainerViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class ContainerViewController: BaseViewController {

    @IBOutlet var leftmenuWidthConstraint: NSLayoutConstraint!
    @IBOutlet var centerMenuLeadConstraint: NSLayoutConstraint!
    
    var leftmenuVC:LeftmenuViewController?
    var centerMenuVC:CentermenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
     func showOrHidemenu(){
       
        self.centerMenuLeadConstraint.constant = self.centerMenuLeadConstraint.constant > 0.0 ? 0.0 : self.leftmenuWidthConstraint.multiplier * self.view.frame.width
        
        updateMenuState()
       
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutSubviews()

        }) { (animationComplete) in
            
        }
        

    }
    
    private func updateMenuState(){
        if self.centerMenuLeadConstraint.constant > 0.0{
            self.centerMenuVC?.isShowingMenu = true
            self.leftmenuVC?.tblViewuserModules.reloadData()
        }
        else{
            self.centerMenuVC?.isShowingMenu = false
            
        }
    }
    
    @objc private func swipeCenterVeiw(swipegesture:UISwipeGestureRecognizer){
        
        print("Swipe Gesture")
        switch swipegesture.direction {
            
        case .left: closeMenu()
            
        case .right: showMenu()
            
        default: break
            
        }
    }
    
    @objc private func panCenterVeiw(_ pangesture:UIPanGestureRecognizer){
        
        print("Pan Gesture")

        let upperBound = self.leftmenuWidthConstraint.multiplier * self.view.frame.width
        let translation = pangesture.translation(in: self.view)
        if let view = pangesture.view{
            
            let xpos = self.centerMenuLeadConstraint.constant + translation.x
            
            if xpos >= 0.0 && xpos <= upperBound{
                
                if pangesture.state == .ended{
                    
                    if xpos < upperBound/2.0{
                        
                        self.centerMenuLeadConstraint.constant = 0.0
                    }
                    else{
                        self.centerMenuLeadConstraint.constant = upperBound
                    }
                }
                else{
                    self.centerMenuLeadConstraint.constant = xpos

                }
                
                updateMenuState()
                
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
                    
                    view.layoutIfNeeded()

                }, completion: nil)

            }
            

        }
        
        pangesture.setTranslation(.zero, in: self.view)
    }
    private func closeMenu(){
        
        if self.centerMenuLeadConstraint.constant > 0.0{
            showOrHidemenu()
        }
    }
    private func showMenu(){
        
        if self.centerMenuLeadConstraint.constant == 0.0{
            showOrHidemenu()
        }
    }
    
    private func addSwipeGesture(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeCenterVeiw))
        self.centerMenuVC?.view.addGestureRecognizer(swipe)
    }
    private func addPanGesture(){
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(panCenterVeiw))
        self.centerMenuVC?.view.addGestureRecognizer(pangesture)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "centermenuID"{
            guard let centerMenuVC = segue.destination as? CentermenuViewController else {return}
            centerMenuVC.delegate = self
            self.centerMenuVC = centerMenuVC
            addPanGesture()
            //addSwipeGesture()
        }
        else if segue.identifier == "leftmenu"{
            guard let leftmenuVC = segue.destination as? LeftmenuViewController else {return}
            leftmenuVC.delegate = self
            self.leftmenuVC = leftmenuVC
        }
        
    }
    
}

extension ContainerViewController: CentermenuDelegate{
    
    func leftmenuTapped() {
        
        showOrHidemenu()
        
    }
    
    func showLoading(){
        
        showLoader()
    }
    func removeLoading(){
        
        removeLoader()
    }
    func fetchedProfiles(profiles:[AnyObject]){
        
        leftmenuVC?.arrProfiles = profiles
    }
    
    func loadProfile(profileId:Int64,  alertId:Int64){
        
        leftmenuVC?.selectedProfile(profileId: profileId, alertId: alertId)
    }


}

extension ContainerViewController: LeftmenuDelegate{
    
    func leftMenuitemTapped(isHideMenu:Bool, isShowNotifications:Bool) {
        
        if isHideMenu{
            showOrHidemenu()
        }
        
        centerMenuVC?.getAlertsOfSelectedModule(isShowNotificationList: isShowNotifications)
    }
}


