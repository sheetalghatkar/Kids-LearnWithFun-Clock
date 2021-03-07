//
//  SubscriptionDetailsController.swift
//  Learn Nature
//
//  Created by Sheetal Ghatkar on 19/01/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit

class SubscriptionDetailsController: UIViewController {

    @IBOutlet weak var lblTitle: UILabel!
    //----------------------------------------
    //New
    @IBOutlet weak var viewSubscriptionBg: UIView!
    @IBOutlet weak var viewSubscription: UIView!

    @IBOutlet weak var lblSubscriptionTitle: UILabel!
    @IBOutlet weak var lblSubscriptionSubtitle: UILabel!
    @IBOutlet weak var lblSubscriptionPrice: UILabel!
    @IBOutlet weak var btnCancelSubscription: UIButton!
    @IBOutlet weak var heightPaymentDetail: NSLayoutConstraint!
    @IBOutlet weak var  widthHome: NSLayoutConstraint!

    var isNonRecurringSubscription = false
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Subscription Details"
        let getPurchaseDetails = self.defaults.value(forKey: "PurchaseDetails") as? [String:String]
        if getPurchaseDetails != nil {
            if(getPurchaseDetails!.count != 0) {
                if(getPurchaseDetails!["ProductId"] == CommanCode.productId_Year_Auto_Recurring) {
                    lblSubscriptionTitle.text = "Yearly Subscription"
                    lblSubscriptionSubtitle.text = "Recurring Payment"
                } else if (getPurchaseDetails!["ProductId"] == CommanCode.productId_Year_Non_Recurring) {
                    lblSubscriptionTitle.text = "Yearly Subscription"
                    lblSubscriptionSubtitle.text = "Non-Recurring Payment"
                } else if (getPurchaseDetails!["ProductId"] == CommanCode.productId_Month_Auto_Recurring) {
                    lblSubscriptionTitle.text = "Monthly Subscription"
                    lblSubscriptionSubtitle.text = "Recurring Payment"
                } else if (getPurchaseDetails!["ProductId"] == CommanCode.productId_Month_Non_Recurring) {
                    lblSubscriptionTitle.text = "Monthly Subscription"
                    lblSubscriptionSubtitle.text = "Non-Recurring Payment"
                }
                lblSubscriptionPrice.text = getPurchaseDetails?["SubscriptionPrice"]
            }
        }
        //Views
        viewSubscriptionBg.backgroundColor = CommanCode.paymentModeBgColor

        //Buttons
        btnCancelSubscription.setTitle("Manage Subscription", for: .normal)
        btnCancelSubscription.setTitleColor(CommanCode.paymentBtnTextColor, for: .normal)
        lblTitle.textColor = CommanCode.paymentBtnTextColor
        lblTitle.layer.shadowColor = UIColor.white.cgColor
        lblTitle.layer.shadowRadius = 1.0
        lblTitle.layer.shadowOpacity = 1.0
        lblTitle.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblTitle.layer.masksToBounds = false

        //Label
                
        self.viewSubscriptionBg.layer.shadowColor = UIColor.white.cgColor
        self.viewSubscriptionBg.layer.borderWidth = 2.5
        
        if isNonRecurringSubscription {
            self.heightPaymentDetail.constant = 115
            self.btnCancelSubscription.isHidden = true
        }
        if !(UIDevice.current.hasNotch) {
            widthHome.constant = 40
        }
    }
    
    @IBAction func funcCancelSubscriptionClick(_ sender: Any) {
        if Reachability.isConnectedToNetwork() {
            guard let urlStr = URL(string: "itms://apps.apple.com/account/subscriptions") else { return }
            UIApplication.shared.open(urlStr, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func funcHomeBtnClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
