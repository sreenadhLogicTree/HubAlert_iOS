//
//  LeftmenuViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class LeftmenuViewController: UIViewController {

    @IBOutlet var tblViewuserModules: UITableView!
    var selectedIndexpath:IndexPath?
    var arrProfiles:[AnyObject] = []{
        
        didSet{
            tblViewuserModules.reloadData()
            
            if let index = selectedIndexpath{
                print("selectedIndexpath")
                selectedCell(at: index)
            }
            
        }
    }
    let tableheaderHeight:CGFloat = 70.0
    weak var delegate:LeftmenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
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

extension LeftmenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrProfiles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         guard let dictProfile:[String:AnyObject] = arrProfiles[section] as? [String:AnyObject] else {return 0}
        guard let modules:[AnyObject] = dictProfile["Modules"] as? [AnyObject] else {return 0}
        
        return modules.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableheaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       // let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "useraccountheader")
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableheaderHeight))
        
        guard let dictProfile:[String:AnyObject] = arrProfiles[section] as? [String:AnyObject] else {return view}
        
        guard let name = dictProfile["PName"] as? String else {return view}
        let xpos:CGFloat = 10.0
        let lblheight:CGFloat = 50.0
        let ypos:CGFloat = (tableheaderHeight - lblheight)/2.0
        let textlabel = UILabel(frame: CGRect(x: xpos, y: ypos, width: view.frame.width - (2 * xpos), height: lblheight))
        textlabel.layer.cornerRadius = lblheight/2.0
        textlabel.clipsToBounds = true
        textlabel.font = Fonts.Bold.of(style: UIFont.TextStyle.title1)
        textlabel.textColor = .white
        textlabel.text = name
        textlabel.backgroundColor = .clear
        textlabel.textAlignment = .left
        view.addSubview(textlabel)

        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppReuseIDs.leftMenuCell, for: indexPath)
        guard let dictProfile:[String:AnyObject] = arrProfiles[indexPath.section] as? [String:AnyObject] else {return cell}
        guard let modules:[AnyObject] = dictProfile["Modules"] as? [AnyObject] else {return cell}
        guard let module:[String:AnyObject] = modules[indexPath.row] as? [String:AnyObject] else {return cell}
        guard let moduleName = module["ModuleName"] as? String else {return cell}
        


        cell.textLabel?.text = "  "+moduleName
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font =  Fonts.Regular.of(style: UIFont.TextStyle.title2)
        cell.selectionStyle = .none
        
        
        guard let moduleId = module["UserModuleID"] as? Int64 else {return cell}
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {return cell}
        
        if moduleId == appdelegate.currentModuleid{
            
            select(cell: cell, index: indexPath)
            selectedIndexpath = indexPath
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedCell(at: indexPath)
        selectedProfileIndex(index: indexPath)
       
    }
    
    func selectedProfileIndex(index:IndexPath){
        
        guard let dictProfile:[String:AnyObject] = arrProfiles[index.section] as? [String:AnyObject] else {return }
        guard let modules:[AnyObject] = dictProfile["Modules"] as? [AnyObject] else {return }
        guard let module:[String:AnyObject] = modules[index.row] as? [String:AnyObject] else {return }
        guard let profileId = dictProfile["ProfileID"] as? Int64 else {return }
        
        guard let moduleId = module["UserModuleID"] as? Int64 else {return }
        guard let moduleName = module["ModuleName"] as? String else{return}
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.currentProfileid = profileId
        appdelegate.currentModuleid = moduleId
        appdelegate.currentModuleName = moduleName
        
        if let alertId = module["AlertID"] as? Int64{
            appdelegate.currentAlertId = alertId
        }
        
        self.delegate?.leftMenuitemTapped(isHideMenu: true, isShowNotifications: false)
    }
    
    func selectedProfile(profileId:Int64, alertId:Int64){
        
        //alerts.firstIndex(where: { $0["Type"] as? String == "117"})
        
        if let index = arrProfiles.firstIndex(where: { ($0["ProfileID"] as? Int64 == profileId)}){
            guard let modules = arrProfiles[index]["Modules"] as? [AnyObject] else {return}
            
            if let moduleIndex = modules.firstIndex(where: { ($0["AlertID"] as? Int64 == alertId)}){
                
                guard let moduleId = modules[moduleIndex]["UserModuleID"] as? Int64 else {return }
                
                guard let moduleName = modules[moduleIndex]["ModuleName"] as? String else{return}
                
                let appdelegate = UIApplication.shared.delegate as! AppDelegate
                appdelegate.currentProfileid = profileId
                appdelegate.currentModuleid = moduleId
                appdelegate.currentModuleName = moduleName
                
                if let alertId = modules[moduleIndex]["AlertID"] as? Int64{
                    appdelegate.currentAlertId = alertId
                }
                
                selectedCell(at: IndexPath(row: moduleIndex, section: index))
                
                self.delegate?.leftMenuitemTapped(isHideMenu: false, isShowNotifications: true)


            }
        }
    
        
    }
    func deselectCell(){
        guard let selected = selectedIndexpath else { return  }
        let selectedcell = tblViewuserModules.cellForRow(at: selected)
        //let selectedcell = tableView.dequeueReusableCell(withIdentifier: AppReuseIDs.leftMenuCell, for: selected)
        selectedcell?.textLabel?.textColor = .white
        selectedcell?.textLabel?.backgroundColor = .clear

    }
    func selectedCell(at index:IndexPath){
        guard let cell = tblViewuserModules.cellForRow(at: index) else{return}
        select(cell: cell, index: index)
                
    }
    func select(cell:UITableViewCell , index:IndexPath){
        deselectCell()
        cell.textLabel?.textColor = AppColors.bgBottomColor
        cell.textLabel?.layer.cornerRadius = 25.0
        cell.textLabel?.clipsToBounds = true
        cell.textLabel?.backgroundColor = .white
        selectedIndexpath = index
    }
}
