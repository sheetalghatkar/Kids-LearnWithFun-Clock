//
//  PaymentCostController.swift
//  Kids-LearnWithFun1
//
//  Created by Sheetal Ghatkar on 07/01/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit
import StoreKit
//import SwiftyStoreKit
class PaymentCostController: UIViewController ,SKProductsRequestDelegate, SKPaymentTransactionObserver,CustomLiceneProtocol {
    
    @IBOutlet weak var lblCostTitle: UILabel!
    @IBOutlet weak var btnRestore: UIButton!
    @IBOutlet weak var lblAlredyPurchased: UILabel!
    @IBOutlet weak var  widthHome: NSLayoutConstraint!

    //----------------------------------------
    //New
    @IBOutlet weak var viewBgYearly: UIView!
    
    @IBOutlet weak var viewYearly: UIView!
    @IBOutlet weak var viewMonthly: UIView!

    
    @IBOutlet weak var lblYearlyTitle: UILabel!
    @IBOutlet weak var lblYearlyRecurring: UILabel!
    @IBOutlet weak var lblYearlyPriceRecurring: UILabel!
    @IBOutlet weak var lblYearlyNonRecurring: UILabel!
    @IBOutlet weak var lblYearlyNonPriceRecurring: UILabel!
    @IBOutlet weak var btnRadioRecurringYearly: UIButton!
    @IBOutlet weak var btnRadioNonRecurringYearly: UIButton!

    @IBOutlet weak var lblMonthlyTitle: UILabel!
    @IBOutlet weak var lblMonthlyRecurring: UILabel!
    @IBOutlet weak var lblMonthlyPriceRecurring: UILabel!
    @IBOutlet weak var lblMonthlyNonRecurring: UILabel!
    @IBOutlet weak var lblMonthlyPriceNonRecurring: UILabel!
    @IBOutlet weak var btnMonthlyPayment: UIButton!
    @IBOutlet weak var btnRadioRecurringMonthly: UIButton!
    @IBOutlet weak var btnRadioNonRecurringMonthly: UIButton!
    
    @IBOutlet weak var lblPrivacyPolicy: UILabel!

    var licenseAgreementVC : CustomLiceneModelController?

    @IBOutlet weak var viewTrasperentDisabled: UIView!

    var selectedProductId = CommanCode.productId_Year_Auto_Recurring
    var isAutoRenewPurchase = true
    var selectedSubscriptionPrice = "$3.99"

    let defaults = UserDefaults.standard
    
    //Restore Status
    var restoreStatus = 0
    //0 Not purchased
    //1 Purchased
    //2 Error Occurred

    var product_ids = [CommanCode.productId_Year_Auto_Recurring,CommanCode.productId_Year_Non_Recurring,CommanCode.productId_Month_Auto_Recurring,CommanCode.productId_Month_Non_Recurring]
    
    /// <#Description#>
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        lblAlredyPurchased.text = "Already Purchased?"
        lblCostTitle.text = "Unlock Premium Features"
        btnRestore.setTitle("Restore", for: .normal)

        /*var textBuyOneTime = NSMutableAttributedString(string:"One-time Payment" + "    " + "$15")
        textBuyOneTime.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .bold),range: NSRange(location: 16, length: (textBuyOneTime.length - 16)))
        btnBuyOneTime.setAttributedTitle(textBuyOneTime, for: .normal)*/
                
        btnRestore.setTitleColor(CommanCode.paymentBtnTextColor, for: .normal)
        
        //Views
        viewBgYearly.backgroundColor = CommanCode.paymentModeBgColor
        
        //Buttons
        btnMonthlyPayment.setTitle("Buy", for: .normal)
        
        btnMonthlyPayment.setTitleColor(CommanCode.paymentBtnTextColor, for: .normal)
        
        
        lblAlredyPurchased.textColor = UIColor.white//CommanCode.paymentModeBgColor
        lblCostTitle.textColor = UIColor.white
//        lblAlredyPurchased.textColor = CommanCode.paymentBtnTextColor

        //Label
        lblYearlyTitle.text = "Yearly Subscription"
        lblYearlyRecurring.text = "Recurring Payment"
        lblYearlyPriceRecurring.text = "$3.99"
        lblYearlyNonRecurring.text = "Non-Recurring Payment"
        lblYearlyNonPriceRecurring.text = "$5.99"
        
        lblMonthlyTitle.text = "Monthly Subscription"
        lblMonthlyRecurring.text = "Recurring Payment "
        lblMonthlyPriceRecurring.text = "$0.49"
        lblMonthlyNonRecurring.text = "Non-Recurring Payment"
        lblMonthlyPriceNonRecurring.text = "$0.99"
        
//        self.viewBgYearly.layer.shadowColor = UIColor.white.cgColor
//        self.viewBgYearly.layer.borderWidth = 2.5
        
//        self.viewBgMonthly.layer.shadowColor = UIColor.black.cgColor
//        self.viewBgMonthly.layer.borderWidth = 1.5
        
        if !(UIDevice.current.hasNotch) {
            widthHome.constant = 40
        }
        viewTrasperentDisabled.isHidden = false
        licenseAgreementVC = CustomLiceneModelController(nibName: "CustomLiceneModelController", bundle: nil)
        licenseAgreementVC?.delegateCustomLicene = self
        self.view.addSubview(licenseAgreementVC?.view ?? UIView())
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.privacyLinkClicked(sender:)))
        lblPrivacyPolicy.isUserInteractionEnabled = true
        lblPrivacyPolicy.addGestureRecognizer(tap)
        
        lblCostTitle.layer.shadowColor = UIColor.black.cgColor
        lblCostTitle.layer.shadowRadius = 3.0
        lblCostTitle.layer.shadowOpacity = 1.0
        lblCostTitle.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblCostTitle.layer.masksToBounds = false
        
        
        lblAlredyPurchased.layer.shadowColor = UIColor.black.cgColor
        lblAlredyPurchased.layer.shadowRadius = 3.0
        lblAlredyPurchased.layer.shadowOpacity = 1.0
        lblAlredyPurchased.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblAlredyPurchased.layer.masksToBounds = false
    }
    
    func removeViewFromApp() {
        viewTrasperentDisabled.isHidden = true
        licenseAgreementVC?.view.removeFromSuperview()
    }

    @IBAction func funcRadioRecurringYearlyClick(_ sender: Any) {
        if btnRadioRecurringYearly.currentImage!.pngData() == (CommanCode.imageRadioUncheck!).pngData() {
            btnRadioRecurringYearly.setImage(CommanCode.imageRadioCheck, for: .normal)
            btnRadioNonRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioNonRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            selectedProductId = CommanCode.productId_Year_Auto_Recurring
            selectedSubscriptionPrice = "$3.99"
            isAutoRenewPurchase = true
        }
    }
    @IBAction func funcRadioNonRecurringYearlyClick(_ sender: Any) {
        if btnRadioNonRecurringYearly.currentImage!.pngData() == (CommanCode.imageRadioUncheck!).pngData() {
            btnRadioNonRecurringYearly.setImage(CommanCode.imageRadioCheck, for: .normal)
            btnRadioRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioNonRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            selectedProductId = CommanCode.productId_Year_Non_Recurring
            selectedSubscriptionPrice = "$5.99"
            isAutoRenewPurchase = false
        }
    }
    
    @IBAction func funcRadioRecurringMonthlyClick(_ sender: Any) {
        if btnRadioRecurringMonthly.currentImage!.pngData() == (CommanCode.imageRadioUncheck!).pngData() {
            btnRadioRecurringMonthly.setImage(CommanCode.imageRadioCheck, for: .normal)
            btnRadioNonRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioNonRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            selectedProductId = CommanCode.productId_Month_Auto_Recurring
            selectedSubscriptionPrice = "$0.49"
            isAutoRenewPurchase = true
        }
    }
    @IBAction func funcRadioNonRecurringMonthlyClick(_ sender: Any) {
        if btnRadioNonRecurringMonthly.currentImage!.pngData() == (CommanCode.imageRadioUncheck!).pngData() {
            btnRadioNonRecurringMonthly.setImage(CommanCode.imageRadioCheck, for: .normal)
            btnRadioRecurringMonthly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            btnRadioNonRecurringYearly.setImage(CommanCode.imageRadioUncheck, for: .normal)
            selectedProductId = CommanCode.productId_Month_Non_Recurring
            selectedSubscriptionPrice = "$0.99"
            isAutoRenewPurchase = false
        }
    }
    @IBAction func funcHomeBtnClick(_ sender: Any) {
       self.navigationController?.popViewController(animated: true)
    }
    @IBAction func funcPaymentBtnClick(_ sender: Any) {
        self.viewTrasperentDisabled.isHidden = false
        if Reachability.isConnectedToNetwork() {
            buyConsumable()
        } else {
          let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
          // add an action (button)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
              self.viewTrasperentDisabled.isHidden = true
          }))
          self.present(alert, animated: true, completion: nil)
      }
    }
    
    @IBAction func funcRestoreBtnClick(_ sender: Any) {
        self.viewTrasperentDisabled.isHidden = false
        if Reachability.isConnectedToNetwork() {
            print("Restore clicked.")
            let appleValidator = AppleReceiptValidator(service: CommanCode.environment, sharedSecret: CommanCode.secretKey)
            let iCount = 0
            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                switch result {
                case .success(let receipt):
                    self.getPurchaseResult(getProductCount: iCount, getReceipt: receipt)
                case .error(let error):
                    print("Receipt verification failed: \(error)")
                    self.viewTrasperentDisabled.isHidden = true
                    let alert = UIAlertController(title: "Something went wrong. Please try after some time.", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        } else {
          let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
          // add an action (button)
          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
              self.viewTrasperentDisabled.isHidden = true
          }))
          self.present(alert, animated: true, completion: nil)
      }
    }
    
    func getPurchaseResult(getProductCount : Int, getReceipt: ReceiptInfo) {
        let getProductId = self.product_ids[getProductCount]
        var subscriptionType = SubscriptionType.autoRenewable

        // Verify the purchase of a Subscription
        if (getProductId == CommanCode.productId_Month_Non_Recurring) {
            subscriptionType = SubscriptionType.nonRenewing(validDuration: 3600 * 24 * 30)
        
        } else if (getProductId == CommanCode.productId_Year_Non_Recurring) {
            subscriptionType = SubscriptionType.nonRenewing(validDuration: 3600 * 24 * 365)
        }
            
        let purchaseResult = SwiftyStoreKit.verifySubscription(
            ofType: subscriptionType, // or .nonRenewing (see below)
            productId: getProductId,
            inReceipt: getReceipt)
            
        switch purchaseResult {
        case .purchased(let expiryDate, let items):
            var getProductPrice = ""
            if(getProductId == CommanCode.productId_Year_Auto_Recurring) {
                getProductPrice = "$3.99"
            } else if(getProductId == CommanCode.productId_Year_Non_Recurring) {
                getProductPrice = "$5.99"
            } else if(getProductId == CommanCode.productId_Month_Auto_Recurring) {
                getProductPrice = "$0.49"
            } else if(getProductId == CommanCode.productId_Month_Non_Recurring) {
                getProductPrice = "$0.99"
            }
            let getReceiptItem = items[0] as ReceiptItem
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let pucrhaseDateString = formatter.string(from: getReceiptItem.purchaseDate as Date)
            let originalPurchasedDateString = formatter.string(from: getReceiptItem.originalPurchaseDate as Date)
            
            var subscriptionExpirationDateString = ""
            if getReceiptItem.subscriptionExpirationDate != nil {
                subscriptionExpirationDateString = formatter.string(from: getReceiptItem.subscriptionExpirationDate! as Date)
            }
            var expirationDateString = ""
            expirationDateString = formatter.string(from: expiryDate as Date)

            var cancelDateString = ""
            if getReceiptItem.cancellationDate != nil {
                cancelDateString = formatter.string(from: getReceiptItem.cancellationDate! as Date)
            }
            let dictPurchaseDetail = [
                "ProductId": getProductId,
                //"iSAutoRenew": self.isAutoRenewPurchase,
                "OriginalPurchasedDate": originalPurchasedDateString,
                "PurchasedDate": pucrhaseDateString,
                "ExpirationDate": expirationDateString,
                "CancellationDate": cancelDateString,
                "SubscriptionExpirationDate": subscriptionExpirationDateString,
                "SubscriptionPrice":getProductPrice
            ] as [String:Any]
            self.defaults.set(dictPurchaseDetail, forKey: "PurchaseDetails")
            self.defaults.set(true, forKey: "IsPrimeUser")
            self.viewTrasperentDisabled.isHidden = true
            let alert = UIAlertController(title: "", message: "Product restored successfully.", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)

        case .expired(let expiryDate, let items):
            print("\(getProductId) is expired since \(expiryDate)\n\(items)\n")
            if getProductCount == 3 {
                self.viewTrasperentDisabled.isHidden = true
                self.defaults.set(false, forKey: "IsPrimeUser")
                let alert = UIAlertController(title: "", message: "No active subscription found.", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.getPurchaseResult(getProductCount: getProductCount+1, getReceipt: getReceipt)
            }
        case .notPurchased:
            print("The user has never purchased \(getProductId)")
            if getProductCount == 3 {
                self.viewTrasperentDisabled.isHidden = true
                self.defaults.set(false, forKey: "IsPrimeUser")
                let alert = UIAlertController(title: "", message: "No active subscription found.", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                self.getPurchaseResult(getProductCount: getProductCount+1, getReceipt: getReceipt)
            }
        }
    }
}

extension PaymentCostController {
    func buyConsumable(){
        print("About to fetch the products");
        // We check that we are allow to make the purchase.
        if (SKPaymentQueue.canMakePayments())
        {
            let productsRequest = SKProductsRequest(productIdentifiers: Set(self.product_ids))
            productsRequest.delegate = self
            productsRequest.start()
            print("Fething Products")
        }else{
            print("can't make purchases");
        }
    }
    
    // Helper Methods
    
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple")
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
        
    }
    

    // Delegate Methods for IAP
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("got the request from Apple")
        var isProductFound = false
        let count : Int = response.products.count
        if (count>0) {
            print("Success@@@@@@@")
            for getProductId in response.products {
                let validProduct: SKProduct = getProductId as SKProduct
                if (validProduct.productIdentifier == selectedProductId) {
                    isProductFound = true
                    print(validProduct.localizedTitle)
                    print(validProduct.localizedDescription)
                    print(validProduct.price)
                    buyProduct(product: validProduct)
                }
            }
            if !isProductFound {
                print("Product not found.")
            }
        } else {
            print("Nothing")
        }
    }
    
    
    func request(request: SKRequest!, didFailWithError error: NSError!) {
        print("La vaina fallo");
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("Received Payment Transaction Response from Apple");
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .purchased:
                    print("Product Purchased");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    self.verifyReciptOfPayment(getProductId: selectedProductId, getProductPrice: selectedSubscriptionPrice)
                    let alert = UIAlertController(title: "", message: "Payment transaction Successful..", preferredStyle: UIAlertController.Style.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    }))
                    break;
                case .failed:
                    print("Purchased Failed");
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    self.navigationController?.popViewController(animated: true)
                    let alert = UIAlertController(title: "", message: "Payment transaction failed. Please Try again.", preferredStyle: UIAlertController.Style.alert)
                    self.viewTrasperentDisabled.isHidden = true
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    }))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    break;
                case .restored:
                    print("Already Purchased")
                    //self.verifyReciptOfPayment()
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                default:
                    break;
               }
            }
          }
      
        
        
        }
    func verifyReciptOfPayment(getProductId : String, getProductPrice : String) {
            let appleValidator = AppleReceiptValidator(service: CommanCode.environment, sharedSecret: CommanCode.secretKey)
            
            SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
                switch result {
                case .success(let receipt):
                    let productId = getProductId
                    var subscriptionType = SubscriptionType.autoRenewable

                    // Verify the purchase of a Subscription
                    if (getProductId == CommanCode.productId_Month_Non_Recurring) {
                        subscriptionType = SubscriptionType.nonRenewing(validDuration: 3600 * 24 * 30)
                    
                    } else if (getProductId == CommanCode.productId_Year_Non_Recurring) {
                        subscriptionType = SubscriptionType.nonRenewing(validDuration: 3600 * 24 * 365)
                    }
                        
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: subscriptionType, // or .nonRenewing (see below)
                        productId: productId,
                        inReceipt: receipt)
                        
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        let getReceiptItem = items[0] as ReceiptItem
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let pucrhaseDateString = formatter.string(from: getReceiptItem.purchaseDate as Date)
                        let originalPurchasedDateString = formatter.string(from: getReceiptItem.originalPurchaseDate as Date)
                        var subscriptionExpirationDateString = ""
                        if getReceiptItem.subscriptionExpirationDate != nil {
                            subscriptionExpirationDateString = formatter.string(from: getReceiptItem.subscriptionExpirationDate! as Date)
                        }
                        var expirationDateString = ""
                        expirationDateString = formatter.string(from: expiryDate as Date)

                        var cancelDateString = ""
                        if getReceiptItem.cancellationDate != nil {
                            cancelDateString = formatter.string(from: getReceiptItem.cancellationDate! as Date)
                        }
                        let dictPurchaseDetail = [
                            "ProductId": getProductId,
                            //"iSAutoRenew": self.isAutoRenewPurchase,
                            "OriginalPurchasedDate": originalPurchasedDateString,
                            "PurchasedDate": pucrhaseDateString,
                            "ExpirationDate": expirationDateString,
                            "CancellationDate": cancelDateString,
                            "SubscriptionExpirationDate": subscriptionExpirationDateString,
                            "SubscriptionPrice":getProductPrice
                        ] as [String:Any]
                        self.defaults.set(dictPurchaseDetail, forKey: "PurchaseDetails")
                        self.defaults.set(true, forKey: "IsPrimeUser")
                        self.viewTrasperentDisabled.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    case .expired(let expiryDate, let items):
                        print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                        self.defaults.set(false, forKey: "IsPrimeUser")
                        self.viewTrasperentDisabled.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    case .notPurchased:
                        print("The user has never purchased \(productId)")
                        self.defaults.set(false, forKey: "IsPrimeUser")
                        self.viewTrasperentDisabled.isHidden = true
                        self.navigationController?.popViewController(animated: true)
                    }
                case .error(let error):
                    print("Receipt verification failed: \(error)")
                    self.viewTrasperentDisabled.isHidden = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        //If an error occurs, the code will go to this function
        func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
            print("transactions restored error")
            self.viewTrasperentDisabled.isHidden = true
            let alert = UIAlertController(title: "", message: "Unable to restore now. Please try after some time", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            }))
            self.present(alert, animated: true, completion: nil)

            //Handle Error
        }
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
            for transaction in queue.transactions {
                let t: SKPaymentTransaction = transaction
                let prodID = t.payment.productIdentifier as String
                if prodID == "product ID" {
                    print("action for restored")
                    queue.finishTransaction(t)
                    //code here what to restore
            }
        }
    }
    //Step 1 Call from button Restore Purchase
    func restore() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()

    }
    
    @objc func privacyLinkClicked(sender:UITapGestureRecognizer) {
        openUrl(urlStr: "https://mobiapps360.com/privacy")
    }

    func openUrl(urlStr: String!) {
        if let url = URL(string:urlStr), !url.absoluteString.isEmpty {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

}
