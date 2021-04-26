//
//  OtherAppsViewController.swift
//  Learn House Objects
//
//  Created by Sheetal Ghatkar on 30/03/21.
//  Copyright © 2021 sheetal shinde. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OtherAppsViewController: UIViewController,PayementForParentProtocol,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var tableOtherApps: UITableView!
    @IBOutlet weak var bgScreen: UIImageView!
    @IBOutlet weak var bgBottomScreen: UIImageView!

    private let appURLArray: NSArray = ["https://apps.apple.com/us/app/learn-nature/id1553868347","https://apps.apple.com/app/id1554806857","https://apps.apple.com/app/id1553674656"]
    private let appImagesArray: NSArray = ["LearnNatureIcon.png","LearnFoodIcon.png","LearnHouseIcon.png"]
    private let appNameArray: NSArray = ["Learn Nature","Learn Natural Food","Learn House Objects"]

    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var viewTransperent: UIView!

    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var paymentDetailVC : PaymentDetailViewController?
    var bannerView: GADBannerView!
    let defaults = UserDefaults.standard
//    var fontImageTitleLbl = UIFont(name: "ChalkboardSE-Bold", size: 24)
    var timer: Timer?
    var fromHomeClick = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let loaderGif = UIImage.gifImageWithName("Loading")
        imgViewLoader.image = loaderGif
        imgViewLoader.backgroundColor = UIColor.white
        imgViewLoader.layer.borderWidth = 1
        imgViewLoader.layer.borderColor = CommanCode.paymentBtnTextColor.cgColor

        if !(defaults.bool(forKey:"IsPrimeUser")) {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = CommanCode.Banner_AdUnitId
            bannerView.rootViewController = self
            bannerView.delegate = self
            if Reachability.isConnectedToNetwork() {
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
            } else {
                let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    if self.timer == nil {
                        self.timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.tableOtherApps.register(UINib.init(nibName: "OtherAppsTableViewCell", bundle: nil), forCellReuseIdentifier: "OtherAppsTableViewCell")
        self.tableOtherApps.backgroundColor = UIColor.clear

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(appURLArray[indexPath.row])")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appURLArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OtherAppsTableViewCell", for: indexPath) as? OtherAppsTableViewCell else {
        // we failed to get a PersonCell – bail out!
        fatalError("Unable to dequeue PersonCell.")
    }

        
        
//        cell.imageviewAppIcon!.image = appImagesArray[indexPath.row] as? UIImage

        cell.imageviewAppIcon!.image = UIImage(named: "\(appImagesArray[indexPath.row])")
        
        cell.backgroundColor = UIColor.clear
        let attributedLinkString = NSMutableAttributedString(string: "\(appURLArray [indexPath.row])", attributes:[NSAttributedString.Key.link: URL(string: "\(appURLArray [indexPath.row])")!])
        
        
        cell.lblAppIcon!.attributedText = attributedLinkString
        cell.lblAppName.text = appNameArray[indexPath.row] as! String



        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !defaults.bool(forKey:"IsPrimeUser") {
                if bannerView != nil {
                    if timer == nil {
                        if Reachability.isConnectedToNetwork() {
                            DispatchQueue.main.async {
                                self.bannerView.load(GADRequest())
                            }
                        } else {
                            let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                                if self.timer == nil {
                                    self.timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey:"IsPrimeUser") {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = true
                if bannerView != nil {
                    bannerView.removeFromSuperview()
                }
            }
        } else {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = false
            }
        }
    }
    
    // MARK: - User defined Functions
     
     @objc func alarmToLoadBannerAds(){
         print("Inside alarmToLoadBannerAds")
         if Reachability.isConnectedToNetwork() {
             if bannerView != nil {
                 print("Inside Load bannerView")
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
             }
         }
     }

     //Start Payment flow
     @IBAction func funcNoAds(_ sender: Any) {
         showPaymentScreen()
     }
     func stopTimer() {
         print("Inside stopTimer")
         if timer != nil {
             timer?.invalidate()
             timer = nil
         }
     }

     //Delegate method implementation
     func showPaymentCostScreen() {
         paymentDetailVC?.view.removeFromSuperview()
         let PaymentCostVC = PaymentCostController(nibName: "PaymentCostController", bundle: nil)
         self.navigationController?.pushViewController(PaymentCostVC, animated: true)
     }
     func showSubscriptionDetailScreen() {
     }

     func showPaymentScreen(){
         paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
         paymentDetailVC?.view.frame = self.view.bounds
         paymentDetailVC?.delegatePayementForParent = self
         self.view.addSubview(paymentDetailVC?.view ?? UIView())
     }
     
     func appstoreRateAndReview() {
     }
     
     func shareApp() {
         
     }

     @IBAction func funcGoToTestHome(_ sender: Any) {
        stopTimer()
        fromHomeClick = true
        navigationController?.popViewController(animated: true)
     }
    func funcHideLoader() {
        self.viewTransperent.isHidden = true
        self.imgViewLoader.isHidden = true
    }

}
extension OtherAppsViewController: GADBannerViewDelegate {
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
          // In iOS 11, we need to constrain the view to the safe area.
          positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
          // In lower iOS versions, safe area is not available so we use
          // bottom layout guide and view edges.
          positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
     }

    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
      // Position the banner. Stick it to the bottom of the Safe Area.
      // Make it constrained to the edges of the safe area.
      let guide = view.safeAreaLayoutGuide
      NSLayoutConstraint.activate([
        guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
        guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
        guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
      ])
    }

    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 0))
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 0))
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: bottomLayoutGuide,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 0))
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      print("adViewDidReceiveAd")
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
        }

    }

    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
      print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
      print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
      print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      print("adViewWillLeaveApplication")
    }
}

