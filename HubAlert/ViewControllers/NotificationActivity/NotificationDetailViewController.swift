//
//  NotificationDetailViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 05/11/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class NotificationDetailViewController: UIViewController {
    @IBOutlet var lblSubject: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblMsg: UILabel!
    
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblSentBy: UILabel!
    @IBOutlet var lblSentOn: UILabel!
    
    @IBOutlet var lblName: UILabel!
    var dictDetail:[String:Any]?{
        
        didSet{
            lblSubject.text = dictDetail?["Subject"] as? String
            lblMsg.text = dictDetail?["Message"] as? String
            lblAddress.text = dictDetail?["Location"] as? String
            lblSentBy.text = dictDetail?["SendBy"] as? String
            lblSentOn.text = dictDetail?["DateSent"] as? String
            lblName.text = dictDetail?["Name"] as? String

            if lblAddress.text?.count == 0{
                lblLocation.isHidden = true
            }
            if lblMsg.text?.count == 0{
                //Just to set some height for msg label
                lblMsg.text = " "
            }
            

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeTapped(_ sender: UIButton) {
        
        navigationController?.dismiss(animated: true, completion: nil)
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
