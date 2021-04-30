//
//  LearnViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 26/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class LearnViewController: UIViewController,CAAnimationDelegate {
    @IBOutlet weak var viewClocket : LearnClocket!
    @IBOutlet weak var viewExtend: UIView!
    @IBOutlet weak var viewParent: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnPlayAgain: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var trailingTitleLbl: NSLayoutConstraint!
    @IBOutlet weak var imgVwComplexTime: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topConstraintDoneBtn: NSLayoutConstraint!
    @IBOutlet weak var widthViewParent: NSLayoutConstraint!
    @IBOutlet weak var imgViewLearnGif: UIImageView!
    @IBOutlet weak var textViewFeatures: UITextView!

    var paymentDetailVC : PaymentDetailViewController?
    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var viewTransperent: UIView!
    @IBOutlet weak var topLblNote: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime1: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime2: NSLayoutConstraint!
    @IBOutlet weak var topDoneBtn: NSLayoutConstraint!
    
    @IBOutlet weak var imgViewFeatureBg: UIImageView!
    @IBOutlet weak var viewFeatureBg: UIView!
    @IBOutlet weak var heightFeatureView: NSLayoutConstraint!


    let defaults = UserDefaults.standard
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var player = AVAudioPlayer()
    //Sound flags
    var fromComplexTextSound = true
    var fromSet = false
    var fromHour = false
    var fromHalfPast = false
    var fromQuarterPast = false
    var fromQuarterTo = false
    var fromPast = false
    var fromTo = false
    var fromDigit = false

    var digitClock = 1
    var previousLevel_1 = true // To set sound play preference
    var iCountQuestionArray = 0
    var levelNumber = 1
    var currentIndex = 0
    var subIndex = 1
    let fontTime = UIFont(name: "ChalkboardSE-Bold", size: 25)
//    let fontTime = UIFont.boldSystemFont(ofSize: 30)

    var fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 30)

    var clockTitle = " o'clock "
    var minuteTitle = " minutes"
    var fontLevel = UIFont(name: "System-Bold", size: 30)
    var levelCompleteVC : LevelSelectionlViewController?
    var arraylevel1CorrectAnsCnt : [Int] = []
    var arraylevel2CorrectAnsCnt : [Int] = []
    var isLevel1Cross = false
    var isLevel2Cross = false
    
    var arrayDesc =  ["ClockDial","HourHand","MinuteHand","SecondHand","Oclock","Past","To"]
    
    var arrayDescImg =  ["ClockDial","HourHand","MinuteHand","SecondHand","Oclock","Past","To"]

    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    var timer: Timer?
    var fromHomeClick = false
    var clickCount = 0
    var setComplexTextRadioPreference = false
    override var prefersStatusBarHidden: Bool {
        return true
    }
    let myShadow = NSShadow()
    var attrs: [NSAttributedString.Key: Any]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle.text = "Learn Clock"
        lblTitle.textColor = UIColor.white   //CommanCode.paymentBtnTextColor
        lblTitle.layer.shadowColor = UIColor.black.cgColor
        lblTitle.layer.shadowRadius = 1.0
        lblTitle.layer.shadowOpacity = 1.0
        lblTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
        lblTitle.layer.masksToBounds = false
        if UIScreen.main.bounds.height < 750 {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 27)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 45)
        }

        lblTitle.font = fontLblTime
        
        let loaderGif = UIImage.gifImageWithName("Loading")
        imgViewLoader.image = loaderGif
        imgViewLoader.backgroundColor = UIColor.white
        imgViewLoader.layer.borderWidth = 1
        imgViewLoader.layer.borderColor =
            CommanCode.paymentBtnTextColor.cgColor
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        }
        //---------------------------------------------------------
        //Initial Clock value set
        btnBackward.isHidden = true
        viewClocket.levelNumber = 1
//        playSet()
        if defaults.bool(forKey:"IsPrimeUser") {
            self.trailingTitleLbl.constant = -50
        } else {
            self.trailingTitleLbl.constant = 40
        }
        let strNote = "# Tap clock hands to move"
        let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string:strNote)
        
//        viewClocket.setLocalTime(hour: 3, minute: 150, second: 1)
        print("######Device size:",UIScreen.main.bounds.height)
        widthViewParent.constant = CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT

        viewExtend.layer.cornerRadius = widthViewParent.constant/2
        
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
//        static var hourAngleArray: [Double] = [3.14,2.60,2.07,1.56,1.05,0.55,-0.02,-0.56,-1.04,-1.60,-2.10,-2.60]

//        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(0.10), duration: 0.0)
//        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(-9.3), duration: 0.0)
        //0.55 - 4
        //-1.55 - 12
        //-5.20 - 5
        //-9.0 - 9
        //1.57 - 6
        //
        
        
        playSound()
        
        textViewFeatures.backgroundColor = UIColor.clear
        viewFeatureBg.layer.cornerRadius = 15.0
        viewFeatureBg.layer.shadowOffset = CGSize(width: 4, height: 4)
        viewFeatureBg.layer.shadowColor = UIColor.black.cgColor
        viewFeatureBg.layer.shadowRadius = 4
        viewFeatureBg.layer.shadowOpacity = 4.0
        viewFeatureBg.layer.masksToBounds = false
        
        imgViewFeatureBg.layer.cornerRadius = 15.0
        imgViewFeatureBg.clipsToBounds = true
        imgViewFeatureBg.layer.masksToBounds = true
        imgViewFeatureBg.layer.borderColor = UIColor.red.cgColor
        imgViewFeatureBg.layer.borderWidth = 1.0
        myShadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        myShadow.shadowColor = UIColor.clear

        textViewStyle()
        textViewFeatures.attributedText = CommanCode.learnClock_Array[currentIndex]
        viewClocket.setLocalTime(hour: CommanCode.guessTimeArray[1][0], minute: CommanCode.guessTimeArray[1][1], second: 1)

    }
    func playSound() {
        if currentIndex == 5 {
            heightFeatureView.constant = 265
        } else {
            heightFeatureView.constant = 220
        }
        self.btnPlayAgain.alpha = 0.2
        self.btnPlayAgain.isUserInteractionEnabled = false
        if currentIndex == 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.300) {
                self.play_1(getInt: 1)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.gifOOOO(strGif: "LearnClock1_1", repeatCount : 4.5)
            }
        } else if currentIndex == 1 {
            play_1(getInt: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.gifOOOO(strGif: "LearnClock2", repeatCount : 50)
            }
        } else if currentIndex == 2 {
            play_1(getInt: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.gifOOOO(strGif: "LearnClock3", repeatCount : 50)
            }
        } else if currentIndex == 3 {
            play_1(getInt: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.gifOOOO(strGif: "LearnClock4", repeatCount : 50)
            }
        } else if currentIndex == 4 {
            play_1(getInt: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.imgViewLearnGif.image = UIImage(named: "Clock5.png")
            }
        } else if currentIndex == 5 {
            play_1(getInt: 1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) {
                self.imgViewLearnGif.layer.removeAllAnimations()
                self.gifOOOO(strGif: "LearnClock6", repeatCount : 20)
            }
        }
    }
    
    func textViewStyle() {
        var descFont = CGFloat(22)
        attrs = [
            .font: UIFont.systemFont(ofSize: descFont, weight: .regular),
            .foregroundColor: UIColor.white,
            .shadow: myShadow
        ]

        if (UIScreen.main.bounds.height < 820) && !(UIDevice.current.userInterfaceIdiom == .pad) {
            descFont = 17
             attrs = [
                .font: UIFont.systemFont(ofSize: descFont, weight: .regular),
                .foregroundColor: UIColor.white,
                .shadow: myShadow
            ]
        }
        
        for iCount in 0 ..< CommanCode.learnClockAnimation_Array.count {
            var strTextViewTemp = NSMutableAttributedString(string:CommanCode.learnClockAnimation_Array[iCount], attributes: attrs)
            if iCount == 0 {
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 13, length:10))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 52, length:9))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 63, length:11))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 79, length:11))
            } else if iCount == 1 {
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 14, length:9))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 48, length:5))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 81, length:5))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 120, length:8))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 142, length:5))
            } else if iCount == 2 {
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 13, length:11))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 53, length:4))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 85, length:7))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 127, length:10))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 151, length:6))
            } else if iCount == 3 {
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 13, length:11))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 47, length:7))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 91, length:10))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 115, length:8))
            } else if iCount == 4 {
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 12, length:11))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 51, length:5))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 73, length:7))
            } else if iCount == 5 {
//                descFont = CGFloat(18)
//                attrs = [
//                    .font: UIFont.systemFont(ofSize: descFont, weight: .regular),
//                    .foregroundColor: UIColor.white,
//                    .shadow: myShadow
//                ]
//                if (UIScreen.main.bounds.height < 820) && !(UIDevice.current.userInterfaceIdiom == .pad) {
//                    descFont = 17
//                     attrs = [
//                        .font: UIFont.systemFont(ofSize: descFont, weight: .regular),
//                        .foregroundColor: UIColor.white,
//                        .shadow: myShadow
//                    ]
//                }
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 18, length:4))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 61, length:18))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 110, length:13))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 155, length:10))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 196, length:10))
                strTextViewTemp.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: descFont, weight: .bold),range: NSRange(location: 238, length:10))




            }
            CommanCode.learnClock_Array.append(strTextViewTemp)
        }
    }
    func gifOOOO(strGif: String, repeatCount: Float){
        let jeremyGif = UIImage.gifImageWithName(strGif)

        // Uncomment the next line to prevent stretching the image
        // imageView.contentMode = .ScaleAspectFit
        // Uncomment the next line to set a gray color.
        // You can also set a default image which get's displayed
        // after the animation
        // imageView.backgroundColor = UIColor.grayColor()

        // Set the images from the UIImage
        imgViewLearnGif.animationImages = jeremyGif?.images
        // Set the duration of the UIImage
        imgViewLearnGif.animationDuration = jeremyGif!.duration
        // Set the repetitioncount
//        imgViewLearnGif.animationRepeatCount = 50
        // Start the animation
        imgViewLearnGif.startAnimating()
        // CAKeyframeAnimation.values are expected to be CGImageRef,
        // so we take the values from the UIImage images
        var values = [CGImage]()
        for image in jeremyGif!.images! {
            values.append(image.cgImage!)
        }

        // Create animation and set SwiftGif values and duration
        let animation = CAKeyframeAnimation(keyPath: "contents")
        animation.calculationMode = CAAnimationCalculationMode.discrete
        animation.duration = jeremyGif!.duration
        animation.values = values
        // Set the repeat count
        animation.repeatCount = repeatCount
        // Other stuff
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        // Set the delegate
        animation.delegate = self
        imgViewLearnGif.layer.add(animation, forKey: "animation")

    }
//    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
//        if flag {
//            print("Animation finished")
//        }
//    }

    func showLevelCompleteScreen(level1Cross : Bool){
        if level1Cross {
            isLevel1Cross = true
        } else  {
            isLevel2Cross = true
        }
        self.view.isUserInteractionEnabled = true
        levelCompleteVC = LevelSelectionlViewController(nibName: "LevelSelectionlViewController", bundle: nil)
        levelCompleteVC?.view.frame = self.view.bounds
        levelCompleteVC?.isLevel1Cross = level1Cross
        levelCompleteVC?.delegatelevelCompleteVC = self
        self.view.addSubview(levelCompleteVC?.view ?? UIView())
    }
    

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey:"IsPrimeUser") {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = true
                if bannerView != nil {
                    bannerView.removeFromSuperview()
                }
            }
            if let _ = trailingTitleLbl {
                self.trailingTitleLbl.constant = -50
            }
        } else {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = false
            }
            if let _ = trailingTitleLbl {
                self.trailingTitleLbl.constant = 40
            }
        }
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
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }

    
    // MARK: - User defined Functions
    
    @IBAction func funcPlayAgain(_ sender: UIButton) {
        digitClock = 1
        subIndex = 1
        playSound()
    }
    
    
    @IBAction func funcBackToHome(_ sender: UIButton) {
        stopTimer()
         fromHomeClick = true
         if defaults.bool(forKey:"IsPrimeUser") {
             navigationController?.popViewController(animated: true)
         } else {
             self.viewTransperent.isHidden = false
             self.imgViewLoader.isHidden = false
             if Reachability.isConnectedToNetwork() {
                 DispatchQueue.main.async {
                     self.interstitial = self.createAndLoadInterstitial()
                 }
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                     if !self.viewTransperent.isHidden {
                         self.viewTransperent.isHidden = true
                         self.imgViewLoader.isHidden = true
                         self.navigationController?.popViewController(animated: true)
                     }
                 }
             } else {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                     self.funcHideLoader()
                     let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                         self.navigationController?.popViewController(animated: true)
                     }))
                     self.present(alert, animated: true, completion: nil)
                 })
             }
         }
     }
    
    @IBAction func funcSound_ON_OFF(_ sender: Any) {
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
            player.stop()
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        }
        appDelegate.IS_Sound_ON = !appDelegate.IS_Sound_ON
    }
    
    @IBAction func func_Forward_Clicked(_ sender: UIButton) {
        digitClock = 1
        if !(defaults.bool(forKey:"IsPrimeUser")) {
            clickCount = clickCount + 1
           // print("!!!!!!!!!!!!clickCount",clickCount)
            if clickCount >= 10 {
                clickCount = 0
                callInterstitialOn10Tap()
            }
        }
        var getIndex = currentIndex + 1
        if !(getIndex >= (CommanCode.learnClock_Array.count)) {
            if (getIndex == (CommanCode.learnClock_Array.count-1)) {
                btnForward.isHidden = true
            } else {
                btnForward.isHidden = false
            }
            currentIndex = getIndex
           // setTimeInQuestion()
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            viewParent.layer.add(transition, forKey: nil)
//            playSet()
        } else {
            btnForward.isHidden = true
        }
        btnBackward.isHidden = false
        textViewFeatures.attributedText = CommanCode.learnClock_Array[currentIndex]
        subIndex = 1
        playSound()
        
    }
    
    @IBAction func func_Backward_Clicked(_ sender: UIButton) {
        digitClock = 1
        if !(defaults.bool(forKey:"IsPrimeUser")) {
            clickCount = clickCount + 1
           // print("!!!!!!!!!!!!clickCount",clickCount)
            if clickCount >= 10 {
                clickCount = 0
                callInterstitialOn10Tap()
            }
        }
        let getIndex = currentIndex - 1
        if !(getIndex < 0) {
            if getIndex == 0 {
                btnBackward.isHidden = true
            } else {
                btnBackward.isHidden = false
            }
            currentIndex = getIndex
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            viewParent.layer.add(transition, forKey: nil)
//            playSet()
        } else {
            btnBackward.isHidden = true
        }
        btnForward.isHidden = false
        textViewFeatures.attributedText = CommanCode.learnClock_Array[currentIndex]
        subIndex = 1
        playSound()
    }
}
extension LearnViewController : AVAudioPlayerDelegate {
    
}

extension LearnViewController : LevelSelectionlProtocol {
    func showNextQuestion() {
        self.btnForward.sendActions(for: .touchUpInside)
    }
}
extension LearnViewController : PayementForParentProtocol {
    @IBAction func funcNoAds(_ sender: Any) {
        showPaymentScreen()
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
    func funcHideLoader() {
        self.viewTransperent.isHidden = true
        self.imgViewLoader.isHidden = true
    }
}
extension LearnViewController: GADBannerViewDelegate {
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
      //print("adViewDidReceiveAd")
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
extension LearnViewController {
    @objc func alarmToLoadBannerAds(){
       // print("Inside alarmToLoadBannerAds")
        if Reachability.isConnectedToNetwork() {
            if bannerView != nil {
             //   print("Inside Load bannerView")
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
            }
        }
    }
    func callInterstitialOn10Tap(){
        self.viewTransperent.isHidden = false
        self.imgViewLoader.isHidden = false
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                self.interstitial = self.createAndLoadInterstitial()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if !self.viewTransperent.isHidden {
                    self.viewTransperent.isHidden = true
                    self.imgViewLoader.isHidden = true
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.funcHideLoader()
                let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: CommanCode.Interstitial_AdUnitId)

        guard let interstitial = interstitial else {
            return nil
        }

        let request = GADRequest()
        // Remove the following line before you upload the app
        interstitial.load(request)
        interstitial.delegate = self

        return interstitial
    }

    func stopTimer() {
        //print("Inside stopTimer")
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}
extension LearnViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //print("Interstitial loaded successfully")
        funcHideLoader()
        ad.present(fromRootViewController: self)
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        funcHideLoader()
        //print("Fail to receive interstitial")
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        funcHideLoader()
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
       // print("dismiss interstitial")
    }
}
extension LearnViewController  {
    func play_1(getInt : Int) {
        if currentIndex == 0 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
                if getInt != 1 {
                    imgViewLearnGif.stopAnimating()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        } else if currentIndex == 1 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        } else if currentIndex == 2 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        } else if currentIndex == 3 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        } else if currentIndex == 4 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        } else if currentIndex == 5 {
            let path = Bundle.main.path(forResource: "Screen_\(currentIndex)_" + "\(getInt)", ofType : "mp3")!
            let url = URL(fileURLWithPath : path)
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                if appDelegate.IS_Sound_ON {
                    player.play()
                }
            } catch {
                print ("There is an issue with this code!")
            }
        }
    }

    func playOclock(getInt : Int) {
        let path = Bundle.main.path(forResource: "\(getInt)"+"_OClock", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
            if getInt < 12 {
                player.delegate = self
            }  else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }

        } catch {
            print ("There is an issue with this code!")
        }
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if currentIndex == 0 {
            if subIndex == 1 {
                subIndex = 2
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                       self.imgViewLearnGif.alpha = 0.0
                       }, completion: {
                           (finished: Bool) -> Void in
            
                        // Fade in
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                            self.imgViewLearnGif.layer.removeAllAnimations()
                            self.imgViewLearnGif.image = UIImage(named: "Screen1_1.png")

                            self.imgViewLearnGif.alpha = 1.0
                               }, completion: nil)
                   })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.play_1(getInt: 2)
                    }
            } else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }
        } else if currentIndex == 1 {
            if subIndex == 1 {
                subIndex = 2
                self.play_1(getInt: 2)
            } else if subIndex == 2 {
                subIndex = 3
                self.play_1(getInt: 3)
            } else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }
        } else if currentIndex == 2 {
            if subIndex == 1 {
                subIndex = 2
                self.play_1(getInt: 2)
            } else if subIndex == 2 {
                subIndex = 3
                self.play_1(getInt: 3)
            } else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }
        } else if currentIndex == 3 {
            if subIndex == 1 {
                subIndex = 2
                self.play_1(getInt: 2)
            } else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }
        } else if currentIndex == 4 {
            if subIndex == 1 {
                subIndex = 2
                self.gifOOOO(strGif: "LearnClock5", repeatCount : 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    self.playOclock(getInt : self.digitClock)
                }
            } else {
                digitClock = digitClock + 1
                var delaySec = 0.25
                if digitClock > 9 {
                    delaySec = 0.35
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + delaySec) {
                    self.playOclock(getInt : self.digitClock)
                }
            }
        } else if currentIndex == 5 {
            if subIndex == 1 {
                subIndex = 2
                self.play_1(getInt: 2)
            } else if subIndex == 2 {
                subIndex = 3
                self.play_1(getInt: 3)
            } else {
                self.btnPlayAgain.alpha = 1.0
                self.btnPlayAgain.isUserInteractionEnabled = true
            }
        }
    }
}
