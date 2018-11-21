//
//  MenuButton.swift
//  HubAlert
//
//  Created by Sreenadh G on 29/10/18.
//  Copyright © 2018 Logictree. All rights reserved.
//

import UIKit

class MenuButton: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var contentview: UIView!
    
    @IBOutlet var imgAlert: UIImageView!
    @IBOutlet var lblAlertTitle: UILabel!
     var isSelected: Bool{
        didSet{
            if isSelected{
                contentview.backgroundColor = AppColors.bgBottomColor
            }
            else{
                contentview.backgroundColor = AppColors.lightGrayColor

            }
        }
        
    }
    var alertItem:[String:AnyObject]?{
        didSet{
            self.lblAlertTitle.text = self.alertItem?["Title"] as? String
            downloadImage()
        }
    }
    var delegate:AlertDelegate?
    
    override init(frame: CGRect) {
        self.isSelected = false
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isSelected = false
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    
    private func downloadImage(){
        guard let imageUrl = alertItem?["Icon"] as? String else { return  }
        guard let url = URL(string: imageUrl) else { return  }
        
        imgAlert.load(url: url)
    }
    
    
    @IBAction func alertTapped(_ sender: UITapGestureRecognizer) {
        
        isSelected = isSelected ? false : true
        
        if isSelected{
            
                delegate?.alertTapped(sender: self)
            
        }
        
        
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("MenuButton", owner: self, options: nil)
        addSubview(contentview)
        contentview.bounds = self.bounds
        contentview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        isSelected = false
    }
    
    

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func notificationload(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.image = self?.image!.withRenderingMode(.alwaysTemplate)
                        self?.tintColor = .white
                    }
                }
            }
        }
    }
}
