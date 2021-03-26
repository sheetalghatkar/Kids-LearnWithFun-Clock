//
//  PlayWithClockController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 26/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class PlayWithClockController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIGestureRecognizerDelegate {
    @IBOutlet weak var viewClocket : PlayClocket!
    @IBOutlet weak var viewExtend: UIView!
    @IBOutlet weak var viewParent: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var trailingTitleLbl: NSLayoutConstraint!
    @IBOutlet weak var lblComplexTime: UILabel!
    @IBOutlet weak var imgVwComplexTime: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPlayComplexTextSound: UIButton!
    @IBOutlet weak var lblNote1: UILabel!
    @IBOutlet weak var lblNote2: UILabel!
    @IBOutlet weak var widthViewParent: NSLayoutConstraint!

    var paymentDetailVC : PaymentDetailViewController?
    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var viewTransperent: UIView!
    @IBOutlet weak var topLblNote: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime1: NSLayoutConstraint!
    @IBOutlet weak var topImgVwTime2: NSLayoutConstraint!
    @IBOutlet weak var pickerViewHour: UIPickerView!
    @IBOutlet weak var pickerViewMinute: UIPickerView!

    let defaults = UserDefaults.standard
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var player = AVAudioPlayer()
    @IBOutlet weak var lblDigitalHour: UILabel!
    @IBOutlet weak var lblDigitalSemicolon: UILabel!
    @IBOutlet weak var lblDigitalMinute: UILabel!

    //Sound flags
    var fromSet = false
    var fromHour = false
    var fromHalfPast = false
    var fromQuarterPast = false
    var fromQuarterTo = false
    var fromPast = false
    var fromTo = false
    var fromDigit = false

    
    var previousLevel_1 = true // To set sound play preference
    var iCountQuestionArray = 0
    var indexQuestion = 0
    let fontTime = UIFont(name: "ChalkboardSE-Bold", size: 25)
//    let fontTime = UIFont.boldSystemFont(ofSize: 30)

    var fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 24)
    var fontDigitalClock = UIFont(name: "ChalkboardSE-Bold", size: 40)
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
    var setComplexTextRadioPreference = false
    let hourArray = ["1", "2", "3", "4", "5" , "6", "7" , "8", "9", "10", "11", "12"]
    let minuteArray = ["00","01", "02", "03", "04", "05" , "06", "07" , "08", "09", "10", "11", "12" , "13", "14", "15", "16", "17" , "18", "19" , "20", "21", "22", "23", "24" , "25", "26", "27", "28", "29" , "30", "31" , "32", "33", "34", "35", "36" , "37", "38", "39", "40", "41" , "42", "43" , "44", "45", "46", "47", "48" , "49", "50", "51" , "52", "53", "54", "55", "56" , "57", "58" , "59"]

    var pickerSelectedHour = 9  // Get selected Hour value of picker so that the value we can set on clock
    var pickerSelectedMinute = 10 // Get selected Minute value of picker so that the value we can set on clock

    var isHourPickScrolling = false //To always to hour pickerview while scrolling
    var isMinutePickScrolling = false //To always to minute pickerview while scrolling
    var isFirstTimeHourPickerShow = true //To initial Hide Hour pickerview
    var isFirstTimeMinutePickerShow = true //To initial Hide Hour pickerview

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerViewHour {
            return hourArray.count
        } else {
            return minuteArray.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("didSelectRow")
        if pickerView == pickerViewHour {
            lblDigitalHour.text = "\(hourArray[row])"
            self.lblDigitalHour.isHidden = false
            self.pickerViewHour.isHidden = true
            pickerSelectedHour = row
            isHourPickScrolling = false
            setClockTime(getHr: pickerSelectedHour, getMin: pickerSelectedMinute)
            if pickerSelectedMinute != 0 {
                viewClocket.funcResetHourAsPerMinuteHand()
            }
        } else {
            lblDigitalMinute.text = "\(minuteArray[row])"
            self.lblDigitalMinute.isHidden = false
            self.pickerViewMinute.isHidden = true
            pickerSelectedMinute = row
            isMinutePickScrolling = false
            setClockTime(getHr: pickerSelectedHour, getMin: pickerSelectedMinute)
            viewClocket.funcResetHourAsPerMinuteHand()
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//       let row = hourArray[row]
//       return row
        print("Picker screool")
        
        if pickerView == pickerViewHour {
            self.lblDigitalMinute.isHidden = false
            self.pickerViewMinute.isHidden = true
            if !isFirstTimeHourPickerShow  {
                self.lblDigitalHour.isHidden = true
                self.pickerViewHour.isHidden = false
            }
            isHourPickScrolling = true
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = fontDigitalClock
    //data source means your ui picker view items array
            label.text =  hourArray[row]
            label.textAlignment = .center
            
//            if !isFirstTimeHourPickerShow  {
//                pickerSelectedHour = Int(hourArray[row])!
//                setClockTime(getHr: pickerSelectedHour, getMin: pickerSelectedMinute)
//                if pickerSelectedMinute != 0 {
//                    viewClocket.funcResetHourAsPerMinuteHand()
//                }
//            }

            return label
        } else {
            self.lblDigitalHour.isHidden = false
            self.pickerViewHour.isHidden = true
            if !isFirstTimeMinutePickerShow  {
                self.lblDigitalMinute.isHidden = true
                self.pickerViewMinute.isHidden = false
            }
            isMinutePickScrolling = true
            var label = UILabel()
            if let v = view {
                label = v as! UILabel
            }
            label.font = fontDigitalClock
    //data source means your ui picker view items array
            label.text =  minuteArray[row]
            label.textAlignment = .center
            
//            if !isFirstTimeMinutePickerShow  {
//                pickerSelectedMinute = Int(minuteArray[row])!
//                setClockTime(getHr: pickerSelectedHour, getMin: pickerSelectedMinute)
//                viewClocket.funcResetHourAsPerMinuteHand()
//            }

            return label

        }

    }
    @objc func tapOnLblTap(_ sender: UITapGestureRecognizer) {
        print("labelTapped")
        if sender.view?.tag == 100 {
            isFirstTimeHourPickerShow = false
            self.lblDigitalHour.isHidden = true
            self.pickerViewHour.isHidden = false
            self.lblDigitalMinute.isHidden = false
            self.pickerViewMinute.isHidden = true

        } else {
            isFirstTimeMinutePickerShow = false
            self.lblDigitalMinute.isHidden = true
            self.pickerViewMinute.isHidden = false
            self.lblDigitalHour.isHidden = false
            self.pickerViewHour.isHidden = true
        }
    }
    @objc func tapOnPickerTap(_ sender: UITapGestureRecognizer) {
        print("tapOnPickerTap")
        if sender.view?.tag == 500 {
            if lblDigitalHour.isHidden {
                self.lblDigitalHour.isHidden = false
                self.pickerViewHour.isHidden = true
            } else {
                self.lblDigitalHour.isHidden = true
                self.pickerViewHour.isHidden = false
            }
        } else {
            if lblDigitalMinute.isHidden {
                self.lblDigitalMinute.isHidden = false
                self.pickerViewMinute.isHidden = true
            } else {
                self.lblDigitalMinute.isHidden = true
                self.pickerViewMinute.isHidden = false
            }
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // return
        return true
    }

    func setupPickerTap() {
        let pickerTapHour = UITapGestureRecognizer(target: self, action: #selector(self.tapOnPickerTap(_:)))
        pickerTapHour.delegate = self
        self.pickerViewHour.tag = 500
        self.pickerViewHour.isUserInteractionEnabled = true
        self.pickerViewHour.addGestureRecognizer(pickerTapHour)
        
        let pickerTapHour1 = UITapGestureRecognizer(target: self, action: #selector(self.tapOnPickerTap(_:)))
        pickerTapHour1.delegate = self
        self.pickerViewMinute.tag = 600
        self.pickerViewMinute.isUserInteractionEnabled = true
        self.pickerViewMinute.addGestureRecognizer(pickerTapHour1)

    }
    func setupHourLblTap() {
        self.lblDigitalHour.tag = 100
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnLblTap(_:)))
        self.lblDigitalHour.isUserInteractionEnabled = true
        self.lblDigitalHour.addGestureRecognizer(labelTap)
        
        self.lblDigitalMinute.tag = 200
        let labelTap1 = UITapGestureRecognizer(target: self, action: #selector(self.tapOnLblTap(_:)))
        self.lblDigitalMinute.isUserInteractionEnabled = true
        self.lblDigitalMinute.addGestureRecognizer(labelTap1)
    }
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void{
       if gesture.direction == .up || gesture.direction == .down {
           // print("Swipe Up")
            print("taggggg",gesture.view?.tag ?? 0)
        
            if gesture.view?.tag ?? 0 == 100 {
                isFirstTimeHourPickerShow = false
                self.lblDigitalHour.isHidden = true
                self.pickerViewHour.isHidden = false
            } else {
                isFirstTimeMinutePickerShow = false
                self.lblDigitalMinute.isHidden = true
                self.pickerViewMinute.isHidden = false
            }
       }
    }

    func setPickerView() {
        pickerViewHour.delegate = self
        pickerViewHour.dataSource = self
        self.pickerViewHour.isHidden = true
        
        pickerViewMinute.delegate = self
        pickerViewMinute.dataSource = self
        self.pickerViewMinute.isHidden = true

    }
    func setInitilValuePicker() {
        pickerViewHour.selectRow(pickerSelectedHour, inComponent: 0, animated: true)
        pickerViewMinute.selectRow(pickerSelectedMinute, inComponent: 0, animated: true)
    }
    func setPickerSwipeGesture() {
        let swipeUpHour = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUpHour.direction = .up
        swipeUpHour.delegate = self
        self.lblDigitalHour.tag = 100
        self.lblDigitalHour.addGestureRecognizer(swipeUpHour)

        let swipeDownHour = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDownHour.direction = .down
        swipeDownHour.delegate = self
        self.lblDigitalHour.tag = 100
        self.lblDigitalHour.addGestureRecognizer(swipeDownHour)

        let swipeUpMinute = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUpMinute.direction = .up
        swipeUpMinute.delegate = self
        self.lblDigitalMinute.tag = 200
        self.lblDigitalMinute.addGestureRecognizer(swipeUpMinute)

        let swipeDownMinute = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDownMinute.direction = .down
        swipeDownMinute.delegate = self
        self.lblDigitalMinute.tag = 200
        self.lblDigitalMinute.addGestureRecognizer(swipeDownMinute)

    }
    func setStyleToNoteLbl(getstr: String) ->NSMutableAttributedString  {
        let strNote =  getstr
        let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string:strNote)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 42, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "ChalkboardSE-Regular", size: 30)!,range: NSRange(location: 2, length: (strNote.count - 2)))
        } else {
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 24, weight: .bold),range: NSRange(location: 0, length:2))
        
        texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "ChalkboardSE-Regular", size: 19)!,range: NSRange(location: 2, length: (strNote.count - 2)))
        }
        return texViewAttrString
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setPickerView()
        setInitilValuePicker()
        setPickerSwipeGesture()


        setupHourLblTap()
        setupPickerTap()
        // Do any additional setup after loading the view.
        lblTitle.text = "Play With Clock"
        lblTitle.textColor = UIColor.white   //CommanCode.paymentBtnTextColor
        lblTitle.layer.shadowColor = UIColor.black.cgColor
        lblTitle.layer.shadowRadius = 1.0
        lblTitle.layer.shadowOpacity = 1.0
        lblTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
        lblTitle.layer.masksToBounds = false
        if UIScreen.main.bounds.height < 750 {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 20)
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 35)
            fontDigitalClock = UIFont(name: "ChalkboardSE-Bold", size: 40)
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
        
        
        lblNote2.textColor = UIColor.white
        lblNote2.layer.shadowColor = UIColor.black.cgColor
        lblNote2.layer.shadowRadius = 3.0
        lblNote2.layer.shadowOpacity = 1.0
        lblNote2.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblNote2.layer.masksToBounds = false

        

        viewClocket.playClockDelegate = self
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        }
        
        
        lblDigitalHour.text = "10"
        lblDigitalHour.font = fontDigitalClock

        lblDigitalSemicolon.text = ":"
        lblDigitalSemicolon.font = fontDigitalClock
        
        lblDigitalMinute.text = "10"
        lblDigitalMinute.font = fontDigitalClock

        //---------------------------------------------------------
        //Initial Clock value set
        setClockTime(getHr: pickerSelectedHour, getMin: pickerSelectedMinute)
        if defaults.bool(forKey:"IsPrimeUser") {
            self.trailingTitleLbl.constant = -50
        } else {
            self.trailingTitleLbl.constant = 10
        }
        
        
        lblNote1.attributedText = setStyleToNoteLbl(getstr: "# Tap clock hands to move")
        lblNote2.attributedText = setStyleToNoteLbl(getstr: "# Tap digits to change time")

        print("######Device size:",UIScreen.main.bounds.height)
        widthViewParent.constant = CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT_PLAY

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
        let roAngle = CGFloat.pi / 10
        print("rotation angle !!!!",roAngle)
        lblNote2.transform = CGAffineTransform(rotationAngle: roAngle)
        lblDigitalHour.transform = CGAffineTransform(rotationAngle: roAngle)
        lblDigitalSemicolon.transform = CGAffineTransform(rotationAngle: roAngle)
        lblDigitalMinute.transform = CGAffineTransform(rotationAngle: roAngle)
        pickerViewHour.transform = CGAffineTransform(rotationAngle: roAngle)
        pickerViewMinute.transform = CGAffineTransform(rotationAngle: roAngle)
    }
    func setComplexTime(getHr: Int,getMin: Int) {
        var  ComplextTimefontSize = CGFloat(23)
        if UIDevice.current.userInterfaceIdiom == .pad {
            ComplextTimefontSize = CGFloat(30)
        }
        var getHr = getHr
        var getMin = getMin
        
        if getHr == 0 {
            getHr = 12
        }

//        var getHr = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]
//        var getMin = CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]
        if getMin == 0 {
            
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: String(getHr)+"\(clockTitle)")

            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .regular),range: NSRange(location: 2, length:(clockTitle.count-1)))
            
            lblComplexTime.attributedText = texViewAttrString
        }
        else if getMin == 15 {
            let setStrTime = "Quarter Past \(getHr) "
            
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 0, length:12))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 12, length:(setStrTime.count - 12)))

            lblComplexTime.attributedText = texViewAttrString
        } else if getMin == 30 {
            let setStrTime = "Half Past \(getHr) "
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 0, length:10))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 10, length:(setStrTime.count-10)))

            lblComplexTime.attributedText = texViewAttrString
        } else if getMin < 30 {
            let setStrTime = "\(getMin) Past \(getHr)"
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 0, length:2))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 2, length:5))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 7, length:(setStrTime.count - 7)))


            lblComplexTime.attributedText = texViewAttrString
        } else if getMin == 45 {
            if getHr == 12 {
                getHr = 1
            } else {
                getHr = getHr + 1
            }
            let setStrTime = "Quarter To \(getHr)"
            let texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: setStrTime)
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 0, length:10))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 10, length:(setStrTime.count-10)))

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
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 0, length:2))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .bold),range: NSRange(location: 2, length:3))
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: ComplextTimefontSize, weight: .medium),range: NSRange(location: 5, length:(setStrTime.count - 5)))

            lblComplexTime.attributedText = texViewAttrString
        }
        lblComplexTime.textColor = UIColor.white
    }

    func setClockTime(getHr:Int, getMin:Int) {
        var changeHrTo = getHr
        let changeMinTo = getMin

        changeHrTo = changeHrTo+1
        if changeHrTo == 12 {
            changeHrTo = 0
        }
        setComplexTime(getHr: changeHrTo, getMin: changeMinTo)

        let getHourAngle = CommanCode.hourAngleArray[changeHrTo]
        viewClocket.setManualHourAngle = getHourAngle
        var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        let getMinuteAngle = CommanCode.minuteAngleArray[changeMinTo]
        viewClocket.setManualMinuteAngle = getMinuteAngle
        handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        if UIScreen.main.bounds.height > 750 {
            self.topLblNote.constant = 15
            self.topImgVwTime1.constant = 35
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.topLblNote.constant = 18
            self.topImgVwTime1.constant = 25
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
//            if let _ = trailingTitleLbl {
//                self.trailingTitleLbl.constant = -50
//            }
        } else {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = false
            }
//            if let _ = trailingTitleLbl {
//                self.trailingTitleLbl.constant = 40
//            }
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
    @IBAction func funcBackToHome(_ sender: UIButton) {                          self.navigationController?.popViewController(animated: true)
}
//    {stopTimer()
//         fromHomeClick = true
//         if defaults.bool(forKey:"IsPrimeUser") {
//             navigationController?.popViewController(animated: true)
//         } else {
//             self.viewTransperent.isHidden = false
//             self.imgViewLoader.isHidden = false
//             if Reachability.isConnectedToNetwork() {
//                 DispatchQueue.main.async {
//                     self.interstitial = self.createAndLoadInterstitial()
//                 }
//                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//                     if !self.viewTransperent.isHidden {
//                         self.viewTransperent.isHidden = true
//                         self.imgViewLoader.isHidden = true
//                         self.navigationController?.popViewController(animated: true)
//                     }
//                 }
//             } else {
//                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
//                     self.funcHideLoader()
//                     let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
//                     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
//                         self.navigationController?.popViewController(animated: true)
//                     }))
//                     self.present(alert, animated: true, completion: nil)
//                 })
//             }
//         }
//     }
    
    @IBAction func funcSound_ON_OFF(_ sender: Any) {
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
            player.stop()
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        }
        appDelegate.IS_Sound_ON = !appDelegate.IS_Sound_ON
    }
    
    @IBAction func func_Play_Sound_Clicked(_ sender: UIButton) {
        if (Int(lblDigitalMinute.text ?? "0")! != 0) {
                if (Int(lblDigitalMinute.text ?? "0")! == 30) {
                    playHalfPast()
                    fromHalfPast = true
                } else if (Int(lblDigitalMinute.text ?? "0")! == 15) {
                    playQuarterPast()
                    fromQuarterPast = true
                } else if (Int(lblDigitalMinute.text ?? "0")! == 45) {
                    playQuarterTo()
                    fromQuarterTo = true
                } else if (Int(lblDigitalMinute.text ?? "0")! < 30) {
                    playFirstDigitPast()
                    fromDigit = true
                } else if (Int(lblDigitalMinute.text ?? "0")! > 30) {
                    playFirstDigitTo()
                    fromDigit = true
                }
        } else {
            playHour()
        }
    }
    
    
    

}
extension PlayWithClockController : AVAudioPlayerDelegate {
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
        let setHourClock = Int(lblDigitalHour.text ?? "12")
        
        let path = Bundle.main.path(forResource:String(setHourClock!)+"_o'clock", ofType : "mp3")!
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
        let setMinClock = Int(lblDigitalMinute.text ?? "0")
        let path = Bundle.main.path(forResource: String(setMinClock!)+"_Minutes", ofType : "mp3")!
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
        let getSoundText = Int(lblDigitalHour.text ?? "12")
        let path = Bundle.main.path(forResource: String(getSoundText!), ofType : "mp3")!
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
        let getSoundText = Int(lblDigitalHour.text ?? "12")
        let path = Bundle.main.path(forResource: String(getSoundText!), ofType : "mp3")!
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
        var getSoundText = Int(lblDigitalHour.text ?? "12")
        if getSoundText == 12 {
            getSoundText = 1
        } else {
            getSoundText = getSoundText! + 1
        }

        let path = Bundle.main.path(forResource: String(getSoundText!), ofType : "mp3")!
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
        let setSoundText = Int(lblDigitalMinute.text ?? "0")
        let path = Bundle.main.path(forResource: String(setSoundText!), ofType : "mp3")!
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
        let setSoundText = Int(lblDigitalHour.text ?? "12")
        let path = Bundle.main.path(forResource: String(setSoundText!), ofType : "mp3")!
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
        var setSoundText = Int(lblDigitalMinute.text ?? "0")
        setSoundText = (Int(60.0) - setSoundText!)

        let path = Bundle.main.path(forResource: String(setSoundText!), ofType : "mp3")!
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
        var setSoundText = Int(lblDigitalHour.text ?? "12")
        if setSoundText == 12 {
            setSoundText = 1
        } else {
            setSoundText = setSoundText! + 1
        }

        let path = Bundle.main.path(forResource: String(setSoundText!), ofType : "mp3")!
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
//        if ((CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) != 0) {
        
        if Int(lblDigitalMinute.text ?? "0") != 0 {
                if (Int(lblDigitalMinute.text ?? "0")! == 30) {
                    if fromHalfPast {
                        fromHalfPast = false
                        playHalfPastDigit()
                    }
                } else if (Int(lblDigitalMinute.text ?? "0")! == 15) {
                    if fromQuarterPast {
                        fromQuarterPast = false
                        playQuarterPastDigit()
                    }
                } else if (Int(lblDigitalMinute.text ?? "0")! == 45) {
                    if fromQuarterTo {
                        fromQuarterTo = false
                        playQuarterToDigit()
                    }
                } else if (Int(lblDigitalMinute.text ?? "0")! < 30) {
                     if fromDigit {
                        fromDigit = false
                        playPast()
                    } else if fromPast {
                        fromPast = false
                        playLastDigitPast()
                    }
                } else if (Int(lblDigitalMinute.text ?? "0")! > 30) {
                    if fromDigit {
                        fromDigit = false
                        playTo()
                    } else if fromTo {
                        fromTo = false
                        playLastDigitTo()
                    }
                }
        }
    }
}

extension PlayWithClockController : PlayClocketProtocol {
    func didHandSMove() {
        if viewClocket.isHandsMove == true {
            viewClocket.isHandsMove = false
        } else {
            
        }
    }
    func setHourOnLabel(getHr: Int, getMin: Int) {
        var getHr = getHr
        setComplexTime(getHr: getHr, getMin: getMin)
        if getMin < 10 {
            lblDigitalMinute.text = "0\(getMin)"
        } else {
            lblDigitalMinute.text = "\(getMin)"
        }
        pickerSelectedMinute = getMin
        if getHr == 0 {
            getHr = 12
            pickerSelectedHour = 11
        } else {
            pickerSelectedHour = getHr - 1
        }
        lblDigitalHour.text = "\(getHr)"
        pickerViewHour.isHidden = true
        pickerViewMinute.isHidden = true
        lblDigitalHour.isHidden = false
        lblDigitalMinute.isHidden = false
        isFirstTimeHourPickerShow = true
        isFirstTimeMinutePickerShow = true
        setInitilValuePicker()
    }
    func setMinuteOnLabel(getHr: Int, getMin: Int) {
        setComplexTime(getHr: getHr, getMin: getMin)
    }
}

extension PlayWithClockController : PayementForParentProtocol {
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
extension PlayWithClockController: GADBannerViewDelegate {
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
extension PlayWithClockController {
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
extension PlayWithClockController: GADInterstitialDelegate {
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

