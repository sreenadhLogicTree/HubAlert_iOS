//
//  BaseViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 15/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    static var NewFrame: CGRect!
    static var SafeGuide: UILayoutGuide!
    
    var loader:UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        BaseViewController.NewFrame = self.view.safeAreaLayoutGuide.layoutFrame
        BaseViewController.SafeGuide = self.view.safeAreaLayoutGuide
    }
    
    func showGradientBackGround(){
        let bgLayer = CAGradientLayer()
        bgLayer.frame = view.bounds
        bgLayer.colors = [AppColors.bgTopColor.cgColor, AppColors.bgBottomColor.cgColor]
        self.view.layer.insertSublayer(bgLayer, at: 0)
        self.view.backgroundColor = AppColors.bgTopColor
        
        print("safeInsets - \(self.view.safeAreaInsets)")
    }
    
    func showAlert(title:String, message:String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true) {
            
        }
    }
    
    func showAlertToNavigateHome(title:String, message:String){
        
        let Alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            Alert.dismiss(animated: true, completion: nil)
            
            let appdelegate = UIApplication.shared.delegate as? AppDelegate
            appdelegate?.loadPhoneNumberScreen()
            
        }
        Alert.addAction(action)
        
        self.present(Alert, animated: true) {
            
        }
    }
    
    func showLoader(){
        
        let alrt = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .gray
        loadingIndicator.startAnimating();
        
        alrt.view.addSubview(loadingIndicator)
        present(alrt, animated: true, completion: nil)
        loader = alrt
        return
        
        /*if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
            appdelegate.window?.rootViewController?.present(alrt, animated: true, completion: nil)
        loader = alrt
        }*/

    }
    
    func removeLoader(){
        
        loader?.dismiss(animated: true, completion: nil)

    }
    
    func showNoInternetAlert(){
        
        var noInternetMsg:String = AlertMessages.offline
        
        if let strmsg = UserDefaults.standard.value(forKey: AlertTitles.offline) as? String{
            
            noInternetMsg = strmsg
        }
        
        showAlert(title: "", message: noInternetMsg)

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
