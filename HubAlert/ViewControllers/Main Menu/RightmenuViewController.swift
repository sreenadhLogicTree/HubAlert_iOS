//
//  RightmenuViewController.swift
//  HubAlert
//
//  Created by Sreenadh G on 02/11/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class RightmenuViewController: UIViewController {

    @IBOutlet var tblOptions: UITableView!
    var delegate:RightMenuDelegate?
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

extension RightmenuViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppReuseIDs.rightMenuCell, for: indexPath)
        if indexPath.row == 0{
            cell.textLabel?.text = RightmenuOptions.NotificationActiivty
            cell.imageView?.image = UIImage(named: "Activity")
        }
        else if indexPath.row == 1{
            cell.textLabel?.text = RightmenuOptions.Feedback
            cell.imageView?.image = UIImage(named: "Feedback")


        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        dismiss(animated: true, completion:{
            
            self.delegate?.selectedOption(index: indexPath.row)

        })
    }
}
