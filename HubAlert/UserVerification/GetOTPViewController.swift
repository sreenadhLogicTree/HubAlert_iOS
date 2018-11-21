//
//  GetOTPViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 24/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class GetOTPViewController: BaseViewController {

    @IBOutlet var txtFldPhonenumber: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        showGradientBackGround()
        addDoneButtonOnKeyboard()

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
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexspace = UIBarButtonItem(barButtonSystemItem:.flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(GetOTPViewController.doneButtonAction))
        done.tintColor = AppColors.bgBottomColor
        
        let items = NSMutableArray()
        items.add(flexspace)
        items.add(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        txtFldPhonenumber.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction()
    {
        txtFldPhonenumber.resignFirstResponder()
    }
    
    @IBAction func getOTPTapped(_ sender: Any) {
        
        txtFldPhonenumber.resignFirstResponder()
        verifyPhoneNumber()
        
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
    
    // MARK: - Network Call
    
    private func verifyPhoneNumber(){
        
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate  else {
            return
        }
        if appdelegate.isInternetAvailable(){
            
        }
        else{
            showNoInternetAlert()
            return
        }
        
        let phoneNumber = txtFldPhonenumber.text?.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.caseInsensitive, range: nil)
        if phoneNumber?.count != 10{
            
            showAlert(title: "Phone Number", message: "Invalid Phone Number")
            return
        }
        
        showLoader()
        let dict:[String:String] = ["pMobileNumber" : txtFldPhonenumber.text ?? ""]
        let services = ServiceHandler()
        services.delegate = self
        services.callForVerifyMobileNumberRequest(withDict: dict as [String : AnyObject])
        


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

extension GetOTPViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField == txtFldPhonenumber{
            
            return checkEnglishPhoneNumberFormat(string: string, str: str)
            
        }else{
            
            return true
        }
    }
    func checkEnglishPhoneNumberFormat(string: String?, str: String?) -> Bool{
        
        if string == ""{ //BackSpace
            
            return true
            
        }else if str!.count == 4{
            
            txtFldPhonenumber.text = txtFldPhonenumber.text! + "-"
            
        }else if str!.count == 8{
            
            txtFldPhonenumber.text = txtFldPhonenumber.text! + "-"
            
        }else if str!.count > 12{
            
            return false
        }
        
        return true
    }
}

extension GetOTPViewController:ServiceHandler_Delegate{
    
    func verifiedPhoneumber(response: [AnyHashable : AnyObject]) {
        //removeLoader()
        dismiss(animated: true) {
        UserDefaults.standard.set(response["Response"]?["Otp"] ?? "", forKey: AppKeys.OTPReceived)
        UserDefaults.standard.set(self.txtFldPhonenumber.text, forKey: AppKeys.VerifiedPhoneNumber)
        self.performSegue(withIdentifier: AppSegues.verifyOTP, sender: nil)
        }

    }
    
    func unauthorized(alert:String){
        dismiss(animated: true) {
            
        
        UserDefaults.standard.set(nil, forKey: AppKeys.OTPReceived)
        UserDefaults.standard.set(nil, forKey: AppKeys.OTPVerified)
        UserDefaults.standard.set(nil, forKey: AppKeys.VerifiedPhoneNumber)
        self.showAlert(title: "", message: alert)
    }

    }
    func otherError(alert:String){
        dismiss(animated: true) {

        self.showAlert(title: "", message: alert)
        }

    }


    
}
