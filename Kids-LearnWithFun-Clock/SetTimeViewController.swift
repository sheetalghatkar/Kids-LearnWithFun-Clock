//
//  SetTimeViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 26/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class SetTimeViewController: UIViewController {
    @IBOutlet weak var viewClocket : SetClocket!
    @IBOutlet weak var viewExtend: UIView!
    @IBOutlet weak var viewParent: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var trailingTitleLbl: NSLayoutConstraint!
    @IBOutlet weak var lblSimpleTime: UILabel!
    @IBOutlet weak var lblComplexTime: UILabel!
    @IBOutlet weak var imgVwComplexTime: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLevelNumber: UILabel!
    @IBOutlet weak var topConstraintDoneBtn: NSLayoutConstraint!
    @IBOutlet weak var levelTitle: UILabel!
    @IBOutlet weak var btnPlaySimpleTextSound: UIButton!
    @IBOutlet weak var btnPlayComplexTextSound: UIButton!
    @IBOutlet weak var lblNote1: UILabel!
    @IBOutlet weak var lblNote2: UILabel!

    var paymentDetailVC : PaymentDetailViewController?
    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var viewTransperent: UIView!
    @IBOutlet weak var topLblNote: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime1: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime2: NSLayoutConstraint!
    @IBOutlet weak var topDoneBtn: NSLayoutConstraint!

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

    
    var iCountQuestionArray = 0
    var levelNumber = 1
    var indexQuestion = 0
    let fontTime = UIFont(name: "ChalkboardSE-Bold", size: 25)
//    let fontTime = UIFont.boldSystemFont(ofSize: 30)

    var fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 30)
   // let fontLblNote = UIFont(name: "ChalkboardSE-Regular", size: 20)

    var clockTitle = " o'clock "
    var minuteTitle = " minutes"
    var fontLevel = UIFont(name: "System-Bold", size: 30)
    var levelCompleteVC : LevelSelectionlViewController?
    var arraylevel1CorrectAnsCnt : [Int] = []
    var arraylevel2CorrectAnsCnt : [Int] = []
    var isLevel1Cross = false
    var isLevel2Cross = false
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial?
    var timer: Timer?
    var fromHomeClick = false
    var clickCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        lblTitle.text = "Set Time"
        lblTitle.textColor = UIColor.white   //CommanCode.paymentBtnTextColor
        lblTitle.layer.shadowColor = UIColor.black.cgColor
        lblTitle.layer.shadowRadius = 1.0
        lblTitle.layer.shadowOpacity = 1.0
        lblTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
        lblTitle.layer.masksToBounds = false
        if UIScreen.main.bounds.height < 750 {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 27)
        }

        lblTitle.font = fontLblTime
        
        let loaderGif = UIImage.gifImageWithName("Loading")
        imgViewLoader.image = loaderGif
        imgViewLoader.backgroundColor = UIColor.white
        imgViewLoader.layer.borderWidth = 1
        imgViewLoader.layer.borderColor =
            CommanCode.paymentBtnTextColor.cgColor

        
        lblNote1.textColor = UIColor.white
        lblNote1.layer.shadowColor = UIColor.black.cgColor
        lblNote1.layer.shadowRadius = 3.0
        lblNote1.layer.shadowOpacity = 1.0
        lblNote1.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblNote1.layer.masksToBounds = false
        
        lblLevelNumber.text = "LEVEL - 1"
        lblLevelNumber.font = fontLevel
        lblLevelNumber.textColor = UIColor.white
       // levelTitle.text = "𒆜ʟɛʋɛʟ 1𒆜"
        levelTitle.textColor = CommanCode.CLOCK_TICK_Color

        viewClocket.setClockDelegate = self
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        }
        //---------------------------------------------------------
        //Initial Clock value set
        setInitialTime()
        btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        lblSimpleTime.textColor = UIColor.white
        btnBackward.isHidden = true
        viewClocket.levelNumber = 1
        playSet()
        if defaults.bool(forKey:"IsPrimeUser") {
            self.trailingTitleLbl.constant = -50
        } else {
            self.trailingTitleLbl.constant = 40
        }
        let strNote = "# Tap clock hands to move"
        let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string:strNote)

        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .bold),range: NSRange(location: 0, length:2))
        
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "ChalkboardSE-Regular", size: 20)!,range: NSRange(location: 2, length: (strNote.count - 2)))
        lblNote1.attributedText = texViewAttrString
        print("######Device size:",UIScreen.main.bounds.height)
        
        
        
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
    }
    func setLevelTitleText() {
        let shadow1 = NSShadow()
        shadow1.shadowColor = UIColor.white
        shadow1.shadowBlurRadius = 2
        var setString = "𒆜ʟɛʋɛʟ 1𒆜"
        
        if (indexQuestion >= 11) && (indexQuestion < 26){
            setString = "𒆜ʟɛʋɛʟ 2𒆜"
        } else if indexQuestion >= 26 {
            setString = "𒆜ʟɛʋɛʟ 3𒆜"
        }

        let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string:setString)

        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14, weight: .regular),range: NSRange(location: 0, length:2))
        
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 25, weight: .bold),range: NSRange(location: 2, length: 9))
        texViewAttrString.addAttribute(NSAttributedString.Key.shadow, value: shadow1,range: NSRange(location: 2, length: 7))

        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14, weight: .regular),range: NSRange(location: 9, length:2))
        
        texViewAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: CommanCode.Clock_Dial_COLOR,range: NSRange(location: 0, length:2))

        texViewAttrString.addAttribute(NSAttributedString.Key.foregroundColor, value: CommanCode.Clock_Dial_COLOR,range: NSRange(location: 9, length:2))

        levelTitle.attributedText = texViewAttrString
    }
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
    func setComplexTime() {
        var getHr = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        var getMin = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]
        if getMin == 15 {
            let setStrTime = "Quarter Past \(getHr) "
            
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:12))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 12, length:(setStrTime.count - 12)))

            lblComplexTime.attributedText = texViewAttrString
        } else if getMin == 30 {
            let setStrTime = "Half Past \(getHr) "
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:10))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 10, length:(setStrTime.count-10)))

            lblComplexTime.attributedText = texViewAttrString
        } else if getMin < 30 {
            let setStrTime = "\(getMin) Past \(getHr)"
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 0, length:2))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 2, length:5))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 7, length:(setStrTime.count - 7)))


            lblComplexTime.attributedText = texViewAttrString
        } else if getMin == 45 {
            if getHr == 12 {
                getHr = 1
            } else {
                getHr = getHr + 1
            }
            let setStrTime = "Quarter To \(getHr)"
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:10))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 10, length:(setStrTime.count-10)))

            lblComplexTime.attributedText = texViewAttrString
        } else {
            if getHr == 12 {
                getHr = 1
            } else {
                getHr = getHr + 1
            }
            getMin = (Int(60.0) - getMin)
            let setStrTime = "\(getMin) To \(getHr)"
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 0, length:2))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 2, length:3))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .medium),range: NSRange(location: 5, length:(setStrTime.count - 5)))

            lblComplexTime.attributedText = texViewAttrString
        }
        lblComplexTime.textColor = UIColor.white
    }

    func setInitialTime() {
        setsimpleLabel()
        if indexQuestion >= 11 {
            levelNumber = 2
            viewClocket.levelNumber = 2
            setComplexTime()
        } else {
            levelNumber = 1
            viewClocket.levelNumber = 1
        }
        let getHourAngle = CommanCode.hourAngleArray[10]
        viewClocket.setManualHourAngle = getHourAngle
        var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        let getMinuteAngle = CommanCode.minuteAngleArray[10]
        viewClocket.setManualMinuteAngle = getMinuteAngle
        handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        if  levelNumber == 1{
            self.topConstraintDoneBtn.constant = -45
            self.imgVwComplexTime.isHidden = true
            self.lblComplexTime.isHidden = true
            self.btnPlayComplexTextSound.isHidden = true
            
            
            if UIScreen.main.bounds.height < 700 {
                self.lblNote1.isHidden = false
                self.topImgVwTime1.constant = 10
            }
        } else {
            self.topConstraintDoneBtn.constant = 15
            if UIScreen.main.bounds.height < 700 {
                self.lblNote1.isHidden = true
                self.topImgVwTime1.constant = -20
           }
            
            self.imgVwComplexTime.isHidden = false
            self.lblComplexTime.isHidden = false
            self.btnPlayComplexTextSound.isHidden = false
        }
        if UIScreen.main.bounds.height > 750 {
            self.topLblNote.constant = 15
            self.topImgVwTime1.constant = 15
            self.topImgVwTime2.constant = 15
//            self.topDoneBtn.constant = 15
        }
        setLevelTitleText()
    }
    
    func setsimpleLabel() {
        if (CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) != 0 {
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])+"\(clockTitle)")

            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(clockTitle.count-1)))
            
            
            let texViewAttrString1: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1])+"\(minuteTitle)")


            texViewAttrString1.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString1.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(minuteTitle.count)-1))
            
            let concate = NSMutableAttributedString(attributedString: texViewAttrString)
            concate.append(texViewAttrString1)
            lblSimpleTime.attributedText = concate
        } else {
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])+"\(clockTitle)")

            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(clockTitle.count-1)))
            
            lblSimpleTime.attributedText = texViewAttrString

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
        if !(defaults.bool(forKey:"IsPrimeUser")) {
            clickCount = clickCount + 1
           // print("!!!!!!!!!!!!clickCount",clickCount)
            if clickCount >= 10 {
                clickCount = 0
                callInterstitialOn10Tap()
            }
        }
        btnDone.setBackgroundImage(CommanCode.Done_Gray_IMG, for: .normal)
        btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        var getIndex = indexQuestion + 1
        if !(getIndex >= (CommanCode.hourMinutequestLevel_1_Array.count)) {
            if (getIndex == (CommanCode.hourMinutequestLevel_1_Array.count-1)) {
                btnForward.isHidden = true
            } else {
                btnForward.isHidden = false
            }
            indexQuestion = getIndex
           // setTimeInQuestion()
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromRight
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            viewParent.layer.add(transition, forKey: nil)
            setInitialTime()
            playSet()
        } else {
            btnForward.isHidden = true
        }
        btnBackward.isHidden = false
    }
    
    @IBAction func func_Backward_Clicked(_ sender: UIButton) {
        if !(defaults.bool(forKey:"IsPrimeUser")) {
            clickCount = clickCount + 1
           // print("!!!!!!!!!!!!clickCount",clickCount)
            if clickCount >= 10 {
                clickCount = 0
                callInterstitialOn10Tap()
            }
        }
        btnDone.setBackgroundImage(CommanCode.Done_Gray_IMG, for: .normal)
        btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        let getIndex = indexQuestion - 1
        if !(getIndex < 0) {
            if getIndex == 0 {
                btnBackward.isHidden = true
            } else {
                btnBackward.isHidden = false
            }
            indexQuestion = getIndex
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = .push
            transition.subtype = .fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            viewParent.layer.add(transition, forKey: nil)
            setInitialTime()
            playSet()
        } else {
            btnBackward.isHidden = true
        }
        btnForward.isHidden = false
    }
    @IBAction func func_Play_SimpleText_Clicked(_ sender: UIButton) {
        fromComplexTextSound = false
        playSet()
    }
    @IBAction func func_Play_ComplexText_Clicked(_ sender: UIButton) {
        fromComplexTextSound = true
        playSet()
    }


    @IBAction func funcDoneClicked(_ sender: UIButton) {
        var checkHour = 0.0
        if CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0] == 12 {
            checkHour = CommanCode.hourAngleArray[0]
        } else {
            checkHour = CommanCode.hourAngleArray[CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]]
        }
        let checkMinute = CommanCode.minuteAngleArray [CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]]
        var isDone = 0
        
        
        if (levelNumber == 1) && (checkHour == viewClocket.setManualHourAngle){
            isDone = isDone + 1
        } else {
            var getHourInd = 0
            if !(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0] == 12) {
                getHourInd = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
            }
            let hourValue = CommanCode.hourCalculationArray[getHourInd]
            let startNumber = hourValue[4]
            let endNumber = hourValue[0]
            let numberRange = startNumber...endNumber
            if numberRange  ~= viewClocket.setManualHourAngle {
                isDone = isDone + 1
            }
        }
        if checkMinute == viewClocket.setManualMinuteAngle {
            isDone = isDone + 1
        }
        
        if isDone == 2 {
            print("Correct")
            self.view.isUserInteractionEnabled = false
            playSoundOnDoneClick(isTrue: true)
            btnDone.setBackgroundImage(CommanCode.Done_GREEN_IMG, for: .normal)
            btnDone.layer.borderColor = UIColor.green.cgColor
            if indexQuestion < 11 {
                if !arraylevel1CorrectAnsCnt.contains(indexQuestion) {
                    arraylevel1CorrectAnsCnt.append(indexQuestion)
                }
            } else if indexQuestion < 26 {
                if !arraylevel2CorrectAnsCnt.contains(indexQuestion) {
                    arraylevel2CorrectAnsCnt.append(indexQuestion)
                }
            }
            if (indexQuestion == 10) && arraylevel1CorrectAnsCnt.count == 11 {
                if !isLevel1Cross {
                    arraylevel1CorrectAnsCnt.removeAll()
                    self.showLevelCompleteScreen(level1Cross: true)
                }
            }  else if (indexQuestion == 25) && arraylevel2CorrectAnsCnt.count == 15 {
                if !isLevel2Cross {
                    arraylevel2CorrectAnsCnt.removeAll()
                    self.showLevelCompleteScreen(level1Cross: false)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9, execute: {
                    self.view.isUserInteractionEnabled = true
                    self.btnForward.sendActions(for: .touchUpInside)
                })
            }
        } else {
            btnDone.setBackgroundImage(CommanCode.Done_Gray_IMG, for: .normal)
            btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
            playSoundOnDoneClick(isTrue: false)
            btnDone.setBackgroundImage(CommanCode.Done_RED_IMG, for: .normal)
            btnDone.layer.borderColor = UIColor.red.cgColor
            print("Incorrect")
        }
        
        viewClocket.isHandsMove = true
    }
    
    func playSoundOnDoneClick(isTrue: Bool) {
        var url : URL?
        if isTrue {
            let path = Bundle.main.path(forResource: "WellDone", ofType : "mp3")!
            url = URL(fileURLWithPath : path)
        } else {
            let path = Bundle.main.path(forResource: "Wrong_Option_Clip", ofType : "mp3")!
            url = URL(fileURLWithPath : path)
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            self.player.play()
        } catch {
            print ("There is an issue with this code!")
        }
    }
    @IBAction func funcDropDown(_ sender: Any) {
    }
    
    

}
extension SetTimeViewController : AVAudioPlayerDelegate {
    func playSet() {
        let path = Bundle.main.path(forResource: "Set", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            fromSet = true
            player.delegate = self

            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    
    func playHour() {
        let setHourClock = (CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])
        
        let path = Bundle.main.path(forResource:String(setHourClock)+"_o'clock", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            fromHour = true
            player.delegate = self

            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    
    func playMinute() {
        let setMinClock = (CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1])
        let path = Bundle.main.path(forResource: String(setMinClock)+"_Minutes", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------
    func playHalfPast() {
        let path = Bundle.main.path(forResource: "HalfPast", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromHalfPast = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playHalfPastDigit() {
        let getSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        let path = Bundle.main.path(forResource: String(getSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------
    func playQuarterPast() {
        let path = Bundle.main.path(forResource: "QuarterPast", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromQuarterPast = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playQuarterPastDigit() {
        let getSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        let path = Bundle.main.path(forResource: String(getSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------
    func playQuarterTo() {
        let path = Bundle.main.path(forResource: "QuarterTo", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromQuarterTo = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playQuarterToDigit() {
        var getSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        if getSoundText == 12 {
            getSoundText = 1
        } else {
            getSoundText = getSoundText + 1
        }

        let path = Bundle.main.path(forResource: String(getSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------
    func playFirstDigitPast() {
        let setSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]
        let path = Bundle.main.path(forResource: String(setSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromDigit = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playPast() {
        let path = Bundle.main.path(forResource: "Past", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromPast = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playLastDigitPast() {
        let setSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        let path = Bundle.main.path(forResource: String(setSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------
    func playFirstDigitTo() {
        var setSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]
        setSoundText = (Int(60.0) - setSoundText)

        let path = Bundle.main.path(forResource: String(setSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromDigit = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playTo() {
        let path = Bundle.main.path(forResource: "To", ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            fromTo = true
            player = try AVAudioPlayer(contentsOf: url)
            player.delegate = self
            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    func playLastDigitTo() {
        var setSoundText = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
        if setSoundText == 12 {
            setSoundText = 1
        } else {
            setSoundText = setSoundText + 1
        }

        let path = Bundle.main.path(forResource: String(setSoundText), ofType : "mp3")!
        let url = URL(fileURLWithPath : path)
        do {
            player = try AVAudioPlayer(contentsOf: url)

            if appDelegate.IS_Sound_ON {
                player.play()
            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    //----------------------------------------------------------------

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished",indexQuestion)//It is working now! printed "finished"!
        if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) != 0) {
                if !fromComplexTextSound {
                    if fromSet {
                        fromSet = false
                        playHour()
                    } else if fromHour {
                        fromHour = false
                        playMinute()
                    }
                } else {
                    if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) == 30) {
                    if fromSet {
                        fromSet = false
                        playHalfPast()
                    } else if fromHalfPast {
                        fromHalfPast = false
                        playHalfPastDigit()
                    }
                } else if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) == 15) {
                    if fromSet {
                        fromSet = false
                        playQuarterPast()
                    } else if fromQuarterPast {
                        fromQuarterPast = false
                        playQuarterPastDigit()
                    }
                } else if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) == 45) {
                    if fromSet {
                        fromSet = false
                        playQuarterTo()
                    } else if fromQuarterTo {
                        fromQuarterTo = false
                        playQuarterToDigit()
                    }
                } else if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) < 30) {
                    if fromSet {
                        fromSet = false
                        playFirstDigitPast()
                    } else if fromDigit {
                        fromDigit = false
                        playPast()
                    } else if fromPast {
                        fromPast = false
                        playLastDigitPast()
                    }
                } else if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) > 30) {
                    if fromSet {
                        fromSet = false
                        playFirstDigitTo()
                    } else if fromDigit {
                        fromDigit = false
                        playTo()
                    } else if fromTo {
                        fromTo = false
                        playLastDigitTo()
                    }
                }
            }
        } else {
            if fromSet {
                fromSet = false
                playHour()
            } else if fromHour {
                fromHour = false
                if !(levelNumber == 1) {
                    playMinute()
                }
            }
        }
    }
}

extension SetTimeViewController : SetClocketProtocol {
    func didHandSMove() {
        if viewClocket.isHandsMove == true {
            viewClocket.isHandsMove = false
            btnDone.setBackgroundImage(CommanCode.Done_Gray_IMG, for: .normal)
            btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        } else {
            
        }
    }
}

extension SetTimeViewController : LevelSelectionlProtocol {
    func showNextQuestion() {
        self.btnForward.sendActions(for: .touchUpInside)
    }
}
extension SetTimeViewController : PayementForParentProtocol {
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
extension SetTimeViewController: GADBannerViewDelegate {
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
extension SetTimeViewController {
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
extension SetTimeViewController: GADInterstitialDelegate {
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
