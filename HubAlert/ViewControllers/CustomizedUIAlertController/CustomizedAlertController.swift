//
//  CustomizedAlertController.swift
//  HubAlertSample
//
//  Created by Thirupathi on 01/11/18.
//  Copyright © 2018 Rama Krishna. All rights reserved.
//
import Foundation
import UIKit



class CustomizedAlertController: BaseViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @IBOutlet var msgLblTop: NSLayoutConstraint!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var subjectLine: UIView!
    @IBOutlet weak var MessageLine: UIView!
    
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var subjectLbl: UILabel!
    
    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    private var isToEditTextView: Bool = false
    
    var isFeedback = false
    var delegate: CustomMessageDelegate?
    var txtViewPlaceHolder:UILabel?
    
    let subjectLength = 20
    let msglength = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.isToEditTextView = true
        
        
        messageTextView.textColor = .gray
        
        self.subjectLbl.textColor = AppColors.bgBottomColor
        self.messageLbl.textColor = AppColors.bgBottomColor

        //messageLbl.isHidden = false
        
        let lblTxtViewPlaceHolder = UILabel(frame: CGRect(x: messageTextView.frame.origin.x, y: messageTextView.frame.origin.y, width: messageTextView.frame.width, height: 50.0))
        lblTxtViewPlaceHolder.text = "Message"
        lblTxtViewPlaceHolder.textColor = .lightGray
        lblTxtViewPlaceHolder.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lblTxtViewPlaceHolder)
        
        NSLayoutConstraint.activate(
            [
                lblTxtViewPlaceHolder.heightAnchor.constraint(equalToConstant: 50.0),
                lblTxtViewPlaceHolder.widthAnchor.constraint(equalTo: messageTextView.widthAnchor, constant: 0.0),
                lblTxtViewPlaceHolder.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor, constant: 5.0),
                lblTxtViewPlaceHolder.topAnchor.constraint(equalTo: messageTextView.topAnchor, constant: 10.0)]
        )
        
        txtViewPlaceHolder = lblTxtViewPlaceHolder
        
       
       /* let alertViewLayer = self.alertView.layer
        alertViewLayer.masksToBounds = true
        alertViewLayer.cornerRadius = 30.0*/
     
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        self.view.removeFromSuperview()
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        
        if isFeedback == true{
            
            if subjectTextField.text?.count == 0{
                showAlert(title: "", message: "Enter your subject")
                return
                
            }
        }
        if messageTextView.text.count == 0{
            
            showAlert(title: "", message: "Enter your message")
            return
        }
        
        if delegate != nil{
            
            delegate?.send(with: subjectTextField.text!, message: messageTextView.text, isFeedback: isFeedback)
        }
        
        
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CustomizedAlertController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.subjectLine.backgroundColor = .orange
        self.subjectLbl.isHidden = false
        
        
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        return (textField.text?.count)! + string.count <= subjectLength
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField.text?.isEmpty)!
        {
            self.subjectLbl.isHidden = true
        } else {
            self.subjectLbl.isHidden = false
        }
        
        self.subjectLine.backgroundColor = .gray
        
    }
    
}

extension CustomizedAlertController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        if isToEditTextView {
            textView.text = ""
            textView.textColor = UIColor.black
            self.messageLbl.isHidden = false
            isToEditTextView = false
            
        }
        txtViewPlaceHolder?.isHidden = true
        self.MessageLine.backgroundColor = AppColors.bgBottomColor
        self.messageLbl.textColor = AppColors.bgBottomColor

        
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
        
        return (textView.text?.count)! + text.count <= msglength

        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            self.messageLbl.isHidden = true
            isToEditTextView = true
            txtViewPlaceHolder?.isHidden = false

        } else {
            self.messageLbl.isHidden = false

        }

        self.MessageLine.backgroundColor = .gray
        

    }
    
}
