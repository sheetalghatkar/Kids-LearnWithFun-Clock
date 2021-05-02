//
//  ViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 09/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var imgViewGif: UIImageView!
    @IBOutlet weak var viewLearnClock: UIView!
    @IBOutlet weak var viewGuessClock: UIView!
    @IBOutlet weak var viewSetClock: UIView!
    @IBOutlet weak var viewPlayWithClock: UIView!
    @IBOutlet weak var viewTestClock: UIView!
    
    
    @IBOutlet weak var btnLearnClock: UIButton!
    @IBOutlet weak var btnGuessClock: UIButton!
    @IBOutlet weak var btnSetClock: UIButton!
    @IBOutlet weak var btnPlayWithClock: UIButton!
    @IBOutlet weak var btnTestClock: UIButton!
    
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnCancelSubscription: UIButton!
    var paymentDetailVC : PaymentDetailViewController?
    @IBOutlet weak var topToSoundBtn: NSLayoutConstraint!
    @IBOutlet weak var notificationSettingView: UIView!


    
    var btnFontStyle = UIFont.systemFont(ofSize: 25, weight: .bold)
    let btnTitleColor = UIColor.white
    let defaults = UserDefaults.standard
    var fontImageTitleLbl = UIFont(name: "ChalkboardSE-Bold", size: 24)
    let rateUsImg = UIImage(named: "RateUs.png")
    let shareAppImg = UIImage(named: "ShareApp.png")
    let updateAppImg = UIImage(named: "UpdateApp.png")
    let otherAppsImg = UIImage(named: "OtherApps.png")

    var player = AVAudioPlayer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var viewParentSetting: UIView!
    @IBOutlet weak var viewtransperent: UIView!
    
    var fromShareApp = false
    var isUpdateAvaible = false
    var bannerView: GADBannerView!
    var timer: Timer?


    @IBOutlet weak var floaty : Floaty!
        {
        didSet {
            floaty.buttonImage = UIImage(named: "map_hashtag_gray")
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
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
                self.timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
            }
        }
        if !(UIDevice.current.hasNotch) {
            topToSoundBtn.constant = -5
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        if appDelegate.IS_Sound_ON {
            playBackgroundMusic()
        } else {
            player.stop()
        }
    }
    func stopTimer() {
        //print("Inside stopTimer")
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    @objc func alarmToLoadBannerAds(){
//        print("Inside alarmToLoadBannerAds")
        if Reachability.isConnectedToNetwork() {
            if bannerView != nil {
             //   print("Inside Load bannerView")
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        player.stop()
        stopTimer()
    }
    func checkForAppUpdate() -> Bool {
        if Reachability.isConnectedToNetwork() {
            let infoDictionary = Bundle.main.infoDictionary
            let appID = infoDictionary!["CFBundleIdentifier"] as! String
            guard let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(appID)") else { return false }

            guard let data = try? Data(contentsOf: url) else {
              print("There is an error!")
              return false;
            }
            let lookup = (try? JSONSerialization.jsonObject(with: data , options: [])) as? [String: Any]
            if let resultCount = lookup!["resultCount"] as? Int, resultCount == 1 {
                if let results = lookup!["results"] as? [[String:Any]] {
                    if let appStoreVersion = results[0]["version"] as? String{
                        let currentVersion = infoDictionary!["CFBundleShortVersionString"]as! String
                        if !(appStoreVersion == currentVersion) {
                            print("Need to update [\(appStoreVersion) != \(currentVersion )]")
                            return true
                        }
                    }
                }
            }
            return false
        } else {
            return false
        }
    }
    func setUI() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            btnFontStyle = UIFont.systemFont(ofSize: 40, weight: .bold)
        }
        self.view.backgroundColor = CommanCode.APP_BACKGROUND_COLOR
        self.imgViewGif.image  = UIImage.gifImageWithName("ClockLearn")
        self.viewLearnClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewGuessClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewSetClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewPlayWithClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewTestClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        
        btnLearnClock.titleLabel?.font = btnFontStyle
        btnGuessClock.titleLabel?.font = btnFontStyle
        btnSetClock.titleLabel?.font = btnFontStyle
        btnPlayWithClock.titleLabel?.font = btnFontStyle
        btnTestClock.titleLabel?.font = btnFontStyle
        
        btnLearnClock.setTitleColor(btnTitleColor, for: .normal)
        btnGuessClock.setTitleColor(btnTitleColor, for: .normal)
        btnSetClock.setTitleColor(btnTitleColor, for: .normal)
        btnPlayWithClock.setTitleColor(btnTitleColor, for: .normal)
        btnTestClock.setTitleColor(btnTitleColor, for: .normal)
        
        
      /*  btnLearnClock.layer.shadowColor = UIColor.white.cgColor
        btnLearnClock.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnLearnClock.layer.shadowOpacity = 1.0
        btnLearnClock.layer.shadowRadius = 30.0
        btnLearnClock.layer.masksToBounds = false*/
        


        
        btnLearnClock.setTitle(NSLocalizedString("Learn Clock", comment: ""), for: .normal)
        btnGuessClock.setTitle(NSLocalizedString("Guess the Time", comment: ""), for: .normal)
        btnSetClock.setTitle(NSLocalizedString("Set the Time", comment: ""), for: .normal)
        btnPlayWithClock.setTitle(NSLocalizedString("Play with Clock", comment: ""), for: .normal)
        btnTestClock.setTitle(NSLocalizedString("Test Your Learning", comment: ""), for: .normal)
        btnTestClock.alpha = 0.8
        
        if defaults.bool(forKey:"PauseHomeSound") {
            self.btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        } else {
            self.btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        }
        viewParentSetting.backgroundColor = UIColor.black
        viewParentSetting.alpha = 0.4

        self.viewtransperent.isHidden = true
        self.viewParentSetting.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.clickTransperentView (_:)))
        self.viewParentSetting.addGestureRecognizer(gesture)
        self.floaty.floatingActionButtonDelegate = self
        self.floaty.addItem(icon: rateUsImg, handler: { [self]_ in
            self.floaty.close()
            self.appstoreRateAndReview()
           /* self.paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
            self.paymentDetailVC?.showHomeScreenRateReview = true
            self.showPaymentScreen()*/
        })
        self.floaty.addItem(icon: shareAppImg, handler: {_ in
            self.floaty.close()
            self.shareApp()
           /* self.paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
            self.paymentDetailVC?.showHomeScreenShareApp = true
            self.showPaymentScreen()
            self.floaty.close()*/
        })
        self.floaty.addItem(icon: otherAppsImg, handler: { [self]_ in
            self.floaty.close()
            let otherAppsVC = OtherAppsViewController(nibName: "OtherAppsViewController", bundle: nil)
            self.navigationController?.pushViewController(otherAppsVC, animated: true)
        })
        floaty.items[0].title = "Rate & Review"
        floaty.items[1].title = "Share App"
        floaty.items[2].title = "Our Other Apps"
        
        isUpdateAvaible = checkForAppUpdate()

        if isUpdateAvaible {
            notificationSettingView.layer.cornerRadius = notificationSettingView.frame.width/2
            notificationSettingView.backgroundColor = UIColor.red
            notificationSettingView.layer.borderWidth = 1.5
            notificationSettingView.layer.borderColor = UIColor.white.cgColor
            notificationSettingView.layer.shadowColor = UIColor.white.cgColor
            notificationSettingView.layer.shadowOpacity = 1.5
            notificationSettingView.layer.shadowOffset = CGSize.zero
            notificationSettingView.layer.shadowRadius = 9.0

            self.floaty.addItem(icon: updateAppImg, handler: {_ in
                self.floaty.close()
                self.redirectToAppStoreForUpdate()
            })
            floaty.items[3].title = "Update App"
        } else {
            notificationSettingView.isHidden = true
        }

        addWaveBackground(to :viewtransperent)

        addWaveBackground(to :viewtransperent)
        //-----------------------------------
    }
    func redirectToAppStoreForUpdate() {
        let components = URLComponents(url: CommanCode.app_AppStoreLink!, resolvingAgainstBaseURL: false)
        
        guard let writeReviewURL = components?.url else {
          return
        }
        UIApplication.shared.open(writeReviewURL)
    }

    @objc func appDidEnterBackground() {
        // stop counter
        floaty.close()
    }
    @objc func clickTransperentView(_ sender:UITapGestureRecognizer){
        self.viewtransperent.isHidden = true
        self.viewParentSetting.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        playBackgroundMusic()
        showHideAdsButton()
    }
    func playBackgroundMusic() {
        let path = Bundle.main.path(forResource: "ClockBgMusic", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if defaults.bool(forKey:"PauseHomeSound") {
                btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
                player.stop()
            } else {
                btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
                player.play()
            }

        } catch {
            print ("There is an issue with this code!")
        }
    }
    @IBAction func funcCancelSubscription(_ sender: Any) {
      /* if btnCancelSubscription.currentImage!.pngData() == (CommanCode.imgCancelSubscription).pngData() {
            btnCancelSubscription.setImage(CommanCode.imgCancelSubscription1, for: .normal)
        } else {
            btnCancelSubscription.setImage(CommanCode.imgCancelSubscription, for: .normal)
        }

        if fromShareApp {
            fromShareApp = false
        } else {*/
            paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
            paymentDetailVC?.showSubscriptionScreen = true
            showPaymentScreen()
       // }
    }


    func addWaveBackground(to view: UIView){
        let multipler = CGFloat(0.1)  //0.13
        var leftDrop : CGFloat = 0.0
        var leftInflexionX : CGFloat = 0.0
        var leftInflexionY : CGFloat = 0.0

        if isUpdateAvaible {
            leftDrop = 0.53 + multipler
            leftInflexionX = 0.53 + multipler
            leftInflexionY = 0.60 + multipler
        } else {
            leftDrop = 0.45 + multipler
            leftInflexionX = 0.45 + multipler
            leftInflexionY = 0.52 + multipler
        }
        var rightDrop : CGFloat = 0.0
        var rightInflexionX : CGFloat = 0.0
        var rightInflexionY : CGFloat = 0.0

        if isUpdateAvaible {
           rightDrop  = 0.43 +  multipler
           rightInflexionX = 0.73  +  multipler
           rightInflexionY = 0.28 + multipler
        } else {
            rightDrop = 0.37 +  multipler
            rightInflexionX = 0.65  +  multipler
            rightInflexionY = 0.20 + multipler
        }


          let backView = UIView(frame: view.frame)
          backView.backgroundColor = .clear
          view.addSubview(backView)
          let backLayer = CAShapeLayer()
          let path = UIBezierPath()
          path.move(to: CGPoint(x: 0, y: 0))
          path.addLine(to: CGPoint(x:0, y: view.frame.height * leftDrop))
          path.addCurve(to: CGPoint(x:250, y: view.frame.height * rightDrop),
                        controlPoint1: CGPoint(x: view.frame.width * leftInflexionX, y: view.frame.height * leftInflexionY),
                        controlPoint2: CGPoint(x: view.frame.width * rightInflexionX, y: view.frame.height * rightInflexionY+30))
//          path.addLine(to: CGPoint(x:225, y: 0))
        path.addLine(to: CGPoint(x:250, y: 0))

          path.close()
          backLayer.fillColor = CommanCode.settingBgColor.cgColor            
            //UIColor.blue.cgColor
          backLayer.path = path.cgPath
          backView.layer.addSublayer(backLayer)
    }
    @IBAction func funcNoAds(_ sender: Any) {
       paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
        paymentDetailVC?.showSubscriptionScreen = false
        showPaymentScreen()
    }

    func showHideAdsButton() {
        if defaults.bool(forKey:"IsPrimeUser") {
            if let _ = btnCancelSubscription, let _ = btnCancelSubscription {
                self.btnCancelSubscription.isHidden = false
                self.btnNoAds.isHidden = true
            }
        } else {
            if let _ = btnCancelSubscription, let _ = btnCancelSubscription {
                self.btnCancelSubscription.isHidden = true
                self.btnNoAds.isHidden = false
            }
        }
    }
    @IBAction func funcSound_ON_OFF(_ sender: Any) {
        if fromShareApp {
            fromShareApp = false
            if defaults.bool(forKey:"PauseHomeSound") {
                btnSound.setBackgroundImage(CommanCode.imgSoundOff1, for: .normal)
            } else {
                btnSound.setBackgroundImage(CommanCode.imgSoundOn1, for: .normal)
            }
        } else {
            if defaults.bool(forKey:"PauseHomeSound") {
                defaults.set(false, forKey: "PauseHomeSound")
                btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
                player.play()
            } else {
                defaults.set(true, forKey: "PauseHomeSound")
                btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
                player.stop()
            }
        }
    }
    //IBAction Learn Time
    @IBAction func funcLearnTime(_ sender: UIButton) {
//        let clockLearnVC = ShowClockViewController(nibName: "LearnViewController", bundle: nil)
//        self.navigationController?.pushViewController(clockLearnVC, animated: true)
        
        
        let clockLearnVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LearnViewController") as! LearnViewController
        self.navigationController?.pushViewController(clockLearnVC, animated: true)
        
       /* let alert = UIAlertController(title: "", message: CommanCode.comingSoonText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)*/

   }
    //IBAction Guess Time
    @IBAction func funcGuessTime(_ sender: UIButton) {
      /*  let guessVC = GuessTimeViewController(nibName: "GuessTimeViewController", bundle: nil)
        self.navigationController?.pushViewController(guessVC, animated: true)*/
        
        
       /* let pictureVC = GuessViewController(nibName: "GuessViewController", bundle: nil)
        self.navigationController?.pushViewController(pictureVC, animated: true)*/
        let pictureVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GuessViewController") as! GuessViewController
//        let setPictureVC = StoryboardsConstants.PicSoundViewStoryboard.getViewControllerInstance(identifier: "GuessViewController") as! GuessViewController
        self.navigationController?.pushViewController(pictureVC, animated: true)
    }
    //IBAction Set Time
    @IBAction func funcSetTime(_ sender: UIButton) {
        let timeViewC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SetTimeViewController") as! SetTimeViewController
        self.navigationController?.pushViewController(timeViewC, animated: true)
        
       /* let alert = UIAlertController(title: "", message: CommanCode.comingSoonText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)*/

    }
    //IBAction Match Time
    @IBAction func funcPlayWithClock(_ sender: UIButton) {
        let playClockVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayWithClockController") as! PlayWithClockController
        self.navigationController?.pushViewController(playClockVC, animated: true)
    }

    //IBAction Match Time
    @IBAction func funcTestTime(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: CommanCode.comingSoonText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController : FloatingActionButtonProtocol {
    
    func floatingActionOpen() {
        UIView.animate(withDuration: 0.5, animations: {
            self.btnSetting.transform = CGAffineTransform(rotationAngle: .pi * 0.999)
        })
        viewtransperent.isHidden = false
        viewParentSetting.isHidden = false
    }
    func floatingActionClose() {
        UIView.animate(withDuration: 0.5, animations: {
            self.btnSetting.transform = CGAffineTransform.identity
        })
        viewtransperent.isHidden = true
        viewParentSetting.isHidden = true
    }
}
extension ViewController : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")//It is working now! printed "finished"!
        playBackgroundMusic()
    }
}
extension ViewController : PayementForParentProtocol {
    //Delegate method implementation
    func showPaymentCostScreen() {
        paymentDetailVC?.view.removeFromSuperview()
        let paymentCostVC = PaymentCostController(nibName: "PaymentCostController", bundle: nil)
        self.navigationController?.pushViewController(paymentCostVC, animated: true)
    }
    
    func showSubscriptionDetailScreen() {
        paymentDetailVC?.view.removeFromSuperview()
        let paymenSubscriptionVC = SubscriptionDetailsController(nibName: "SubscriptionDetailsController", bundle: nil)
        self.navigationController?.pushViewController(paymenSubscriptionVC, animated: true)
    }

    func showPaymentScreen(){
        paymentDetailVC?.view.frame = self.view.bounds
        paymentDetailVC?.delegatePayementForParent = self
        self.view.addSubview(paymentDetailVC?.view ?? UIView())
    }
    
    func appstoreRateAndReview() {
        paymentDetailVC?.view.removeFromSuperview()
        var components = URLComponents(url: CommanCode.app_AppStoreLink!, resolvingAgainstBaseURL: false)
        components?.queryItems = [
          URLQueryItem(name: "action", value: "write-review")
        ]
        guard let writeReviewURL = components?.url else {
          return
        }
        UIApplication.shared.open(writeReviewURL)
    }
    func updateApp() {
        let components = URLComponents(url: CommanCode.app_AppStoreLink!, resolvingAgainstBaseURL: false)
        
        guard let writeReviewURL = components?.url else {
          return
        }
        UIApplication.shared.open(writeReviewURL)
    }
    
    func shareApp() {
        paymentDetailVC?.view.removeFromSuperview()
        let activityViewController = UIActivityViewController(
            activityItems: [CommanCode.app_AppStoreLink!],
          applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
             print(success ? "SUCCESS!" : "FAILURE")
            self.fromShareApp = true
            self.btnSound.sendActions(for: .touchUpInside)
        }
        self.present(activityViewController, animated: true, completion: nil)
    }
}
extension ViewController: GADBannerViewDelegate {
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
        if let visibleViewCtrl = UIApplication.shared.keyWindow?.visibleViewController {
            if(visibleViewCtrl.isKind(of: GuessViewController.self)){
                if timer == nil {
                   // print("adViewDidReceiveAd Success")
                    timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                }
            }
        }
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      //print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
     // print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
     // print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
     // print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      //print("adViewWillLeaveApplication")
    }
}
