//
//  VerifyOTPViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class VerifyOTPViewController: BaseViewController {

    @IBOutlet var txtFldOTP: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        showGradientBackGround()
        
        //showAlert(title: "OTP", message: UserDefaults.standard.value(forKey: AppKeys.OTPReceived) as! String)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChange), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        let flexspace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(GetOTPViewController.doneButtonAction))
        
        let items = NSMutableArray()
        items.add(flexspace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        txtFldOTP.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        txtFldOTP.resignFirstResponder()
    }
    
    
    //MARK: KEYBOARD RELATED METHODS
    @objc func keyboardFrameChange(notification: Notification){
        
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect).size.height
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! CGFloat
        UIView.animate(withDuration:TimeInterval(duration)) {
            
            var center = self.view.center
            if notification.name == UIResponder.keyboardWillShowNotification{
                center.y = self.view.frame.height/2.0 - (keyboardHeight/2.0)
            }
            else{
                center.y = self.view.frame.height/2.0
            }
            
            self.view.center = center
            
        }
        
    }


    @IBAction func verifyTapped(_ sender: UIButton) {
        
        if txtFldOTP.text?.count == 0{
            showAlert(title: "OTP", message: "Enter OTP")
            return
        }
        if txtFldOTP.text == UserDefaults.standard.value(forKey: AppKeys.OTPReceived) as? String
        {
            UserDefaults.standard.set(txtFldOTP.text, forKey: AppKeys.OTPVerified)
            performSegue(withIdentifier: AppSegues.showMainMenu, sender: self)
        }
        else{
            showAlert(title: "OTP", message: "Enter valid OTP")
            return
        }
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
