//
//  PaymentDetailViewController.swift
//  Kids-LearnWithFun1
//
//  Created by Sheetal Ghatkar on 05/01/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit

protocol CustomLiceneProtocol : class {
    func removeViewFromApp()
}

class CustomLiceneModelController: UIViewController {

    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblLicenseTitle: UILabel!
    @IBOutlet weak var txtViewLicenseInfo: UITextView!
    weak var delegateCustomLicene : CustomLiceneProtocol?
    @IBOutlet weak var  heightView: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblLicenseTitle.text = "End User License Agreement"
        //Buttons
        btnOk.setTitle("Ok", for: .normal)
        btnOk.setTitleColor(CommanCode.paymentBtnTextColor, for: .normal)
        heightView.constant = UIScreen.main.bounds.height * 0.9
        let texViewString = "Auto-Renewable Subscriptions \n\nA. Payment will be charged to your iTunes account at confirmation of purchase and will automatically renew (at the duration/price selected) unless auto-renew is turned off at least 24 hrs before the end of the current subscription period.\n\nB. Account will be charged for renewal 24-hours prior to the end of the current subscription period. Current subscription can not be cancelled during the active subscription period; however, you can manage your subscription and/or turn off auto-renewal by visiting your iTunes Account Settings after purchase.\n\nNon-Renewable Subscriptions\n\nA. Payment will be charged to your iTunes account at confirmation of purchase.\n\nB. Your current subscription benefits will be terminated at the end of the current subscription period. Current subscription can not be cancelled during the active subscription period."
        
        let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: texViewString)
        
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular),range: NSRange(location: 0, length:texViewAttrString.length))
        
        if UIScreen.main.bounds.height < 700 {
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14, weight: .regular),range: NSRange(location: 0, length:texViewAttrString.length))
        } else if UIScreen.main.bounds.height < 820 {
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16, weight: .regular),range: NSRange(location: 0, length:texViewAttrString.length))
        } else {
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18, weight: .regular),range: NSRange(location: 0, length:texViewAttrString.length))
        }
        
        texViewAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white,range: NSRange(location: 0, length:texViewAttrString.length))


        let textAutoRenewable = NSMutableAttributedString(string:"Auto-renewable Subscriptions")
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold),range: NSRange(location: 0, length:textAutoRenewable.length))
        
        let textNonRenewable = NSMutableAttributedString(string:"Non-renewable Subscriptions")
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18, weight: .semibold),range: NSRange(location: 582, length:textNonRenewable.length))
        
        txtViewLicenseInfo.attributedText = texViewAttrString
        txtViewLicenseInfo.isScrollEnabled = false
        txtViewLicenseInfo.isEditable = false
        txtViewLicenseInfo.isUserInteractionEnabled = false
        
        lblLicenseTitle.layer.shadowColor = UIColor.black.cgColor
        lblLicenseTitle.layer.shadowRadius = 3.0
        lblLicenseTitle.layer.shadowOpacity = 1.0
        lblLicenseTitle.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblLicenseTitle.layer.masksToBounds = false
    }
    
    @IBAction func funcOK(_ sender: UIButton) {
        delegateCustomLicene?.removeViewFromApp()
    }
}
