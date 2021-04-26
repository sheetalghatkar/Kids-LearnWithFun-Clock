//
//  OtherAppsTableViewCell.swift
//  Learn House Objects
//
//  Created by Sheetal Ghatkar on 30/03/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit

class OtherAppsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageviewAppIcon: UIImageView!
    @IBOutlet weak var lblAppIcon: UILabel!
    @IBOutlet weak var lblAppName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var btnGetNow: UIButton!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageviewAppIcon.layer.cornerRadius = 10.0
        self.imageviewAppIcon.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.linkClicked(sender:)))
        lblAppIcon.isUserInteractionEnabled = true
        viewContainer.addGestureRecognizer(tap)
        btnGetNow.setTitle("Get Now", for: .normal)
        btnGetNow.setTitleColor(UIColor.white, for: .normal)
        self.btnGetNow.backgroundColor = CommanCode.settingBgColor
            
            //UIColor(red: (88/255), green: (173/255), blue: (203/255), alpha: 1.0)
        lblAppName.textColor = CommanCode.settingBgColor
            //UIColor(red: (88/255), green: (173/255), blue: (203/255), alpha: 1.0)
        viewContainer.backgroundColor = UIColor.white
        self.lblAppName.backgroundColor = UIColor.clear
        
        viewContainer.layer.cornerRadius = 10

        // border
        viewContainer.layer.borderWidth = 0.5
        viewContainer.layer.borderColor = UIColor.black.cgColor

        // shadow
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOffset = CGSize(width: 3, height: 3)
        viewContainer.layer.shadowOpacity = 0.7
        viewContainer.layer.shadowRadius = 4.0
        viewContainer.layer.masksToBounds = false
        
        self.btnGetNow.layer.masksToBounds = false
        self.btnGetNow.layer.cornerRadius = 8.0
        self.btnGetNow.layer.shadowColor = UIColor.black.cgColor
        self.btnGetNow.layer.shadowPath = UIBezierPath(roundedRect: self.btnGetNow.bounds, cornerRadius: self.btnGetNow.layer.cornerRadius).cgPath
        self.btnGetNow.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.btnGetNow.layer.shadowOpacity = 0.5
        self.btnGetNow.layer.shadowRadius = 1.0

    }
    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @objc func linkClicked(sender:UITapGestureRecognizer) {
        sender.view?.alpha = 0.5
        openUrl(urlStr: lblAppIcon.text)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            //Bring's sender's opacity back up to fully opaque.
            sender.view?.alpha = 1.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
