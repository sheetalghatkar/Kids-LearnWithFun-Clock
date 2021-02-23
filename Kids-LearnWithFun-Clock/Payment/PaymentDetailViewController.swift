//
//  PaymentDetailViewController.swift
//  Kids-LearnWithFun1
//
//  Created by Sheetal Ghatkar on 05/01/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit

protocol PayementForParentProtocol : class {
    func showPaymentCostScreen()
    func showSubscriptionDetailScreen()
    func appstoreRateAndReview()
    func shareApp()
}


class PaymentDetailViewController: UIViewController {
    @IBOutlet weak var viewPaymentFirst: UIView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgViewParent: UIImageView!
    @IBOutlet weak var lblViewPayment: UILabel!
    @IBOutlet weak var lblParentTitle: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblWrongAns: UILabel!
    @IBOutlet weak var stackView: UIStackView!

    
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    @IBOutlet weak var btnOption3: UIButton!
    @IBOutlet weak var btnOption4: UIButton!
    
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var viewPaymentCostDetails: UIView!
    @IBOutlet weak var lblCostInfo: UILabel!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnBuy: UIButton!

    weak var delegatePayementForParent : PayementForParentProtocol?

    var arrayQuestionTest = [[4,12,2],[9,10,0],[5,11,3],[7,9,2],[4,13,1],[7,8,0],[5,15,3],[2,14,1]]
    var arrayOptionTest = [[14,19,16,18],[19,12,21,16],[17,13,23,16],[17,19,16,24],[21,17,19,15],[15,18,10,20],[21,25,23,20],[17,16,21,22]]
    var fontOptionBtn = UIFont(name: "Noteworthy-Bold", size: 18)
    var random = 0
    var optionClicked = 0
    var showSubscriptionScreen = false
    var showHomeScreenRateReview = false
    var showHomeScreenShareApp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewPaymentFirst.backgroundColor =  UIColor.clear     //CommanCode.paymentDetailsBgColor
        viewPaymentCostDetails.backgroundColor = UIColor.clear     //CommanCode.paymentDetailsBgColor
        lblParentTitle.text = "Only For Parents"
        lblCostInfo.text = "Do you want to remove Ads for $2 ?"

        random = Int.random(in: 0 ..< arrayQuestionTest.count)
        lblQuestion.text = String(arrayQuestionTest[random][0]) + " + " + String(arrayQuestionTest[random][1])
        btnOption1.titleLabel?.font =  fontOptionBtn
        btnOption2.titleLabel?.font =  fontOptionBtn
        btnOption3.titleLabel?.font =  fontOptionBtn
        btnOption4.titleLabel?.font =  fontOptionBtn
        
        btnOption1.setTitle(String(arrayOptionTest[random][0]), for: .normal)
        btnOption2.setTitle(String(arrayOptionTest[random][1]), for: .normal)
        btnOption3.setTitle(String(arrayOptionTest[random][2]), for: .normal)
        btnOption4.setTitle(String(arrayOptionTest[random][3]), for: .normal)
        
        btnRestore.setTitle("Restore", for: .normal)
        btnCancel.setTitle("Cancel", for: .normal)
        btnBuy.setTitle("Buy", for: .normal)

        btnOption1.tag = 0
        btnOption2.tag = 1
        btnOption3.tag = 2
        btnOption4.tag = 3
        
        lblWrongAns.text = "Wrong Answer!!!"
    }
    @IBAction func funcBtnOption0(_ sender: UIButton) {
        optionClicked = sender.tag
        funcShowNextPaymentScreen()
    }
    @IBAction func funcBtnOption1(_ sender: UIButton) {
        optionClicked = sender.tag
        funcShowNextPaymentScreen()
    }
    @IBAction func funcBtnOption2(_ sender: UIButton) {
        optionClicked = sender.tag
        funcShowNextPaymentScreen()
    }
    @IBAction func funcBtnOption3(_ sender: UIButton) {
        optionClicked = sender.tag
        funcShowNextPaymentScreen()
    }
    @IBAction func funcRestore(_ sender: UIButton) {
    }
    @IBAction func funcCancel(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.dismiss(animated: false, completion: nil)
        }
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0.0
        })
    }
    @IBAction func funcBuy(_ sender: UIButton) {
    }

    func funcShowNextPaymentScreen() {
        if arrayQuestionTest[random][2] == optionClicked {
            if showHomeScreenRateReview {
                delegatePayementForParent?.appstoreRateAndReview()
            } else if showHomeScreenShareApp {
                delegatePayementForParent?.shareApp()
            } else if showSubscriptionScreen {
                delegatePayementForParent?.showSubscriptionDetailScreen()
            } else {
                delegatePayementForParent?.showPaymentCostScreen()
            }
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                self.btnClose.alpha = 0.0
            })
            UIView.transition(with: self.viewPaymentFirst, duration: 1, options: .transitionFlipFromBottom, animations: nil, completion: { (_) in
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.stackView.isHidden = true
                self.lblQuestion.isHidden = true
                self.lblParentTitle.isHidden = true
                self.imgViewParent.isHidden = true
                self.lblWrongAns.alpha = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.funcHidePaymentView(self)
            }
        }
    }

    @IBAction func funcHidePaymentView(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.dismiss(animated: false, completion: nil)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.0
        })
    }
}
