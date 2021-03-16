//
//  SetTimeViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 26/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation

class SetTimeViewController: UIViewController {
    @IBOutlet weak var viewClocket : SetClocket!
    @IBOutlet weak var viewExtend: UIView!

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!

//    @IBOutlet weak var lblHourTime: UILabel!
//    @IBOutlet weak var lblHour: UILabel!
//    @IBOutlet weak var lblMinuteTime: UILabel!
//    @IBOutlet weak var lblMinute: UILabel!
    @IBOutlet weak var trailingHourLbl: NSLayoutConstraint!
    @IBOutlet weak var lblSimpleTime: UILabel!
    @IBOutlet weak var lblComplexTime: UILabel!


    var paymentDetailVC : PaymentDetailViewController?
    let defaults = UserDefaults.standard
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var player = AVAudioPlayer()
    var fromSet = false
    var fromHour = false
    var iCountQuestionArray = 0
    var levelNumber = 1
    var indexQuestion = 0
    let fontTime = UIFont(name: "ChalkboardSE-Bold", size: 30)
    let fontLblTime = UIFont(name: "ChalkboardSE-Regular", size: 25)
    var clockTitle = " O'Clock "
    var minuteTitle = " Minutes"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        }
        //----------------------------------------------------------------------------------------
        //Initial Clock value set
        setInitialTime()
        setsimpleLabel()
        btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        lblSimpleTime.textColor = UIColor.white
        
       /* lblHour.textColor = UIColor.white
        lblMinute.textColor = UIColor.white
        lblHour.font = fontLblTime
        lblMinute.font = fontLblTime

        lblHourTime.textColor = UIColor.white
        lblMinuteTime.textColor = UIColor.white
        lblHourTime.font = fontTime
        lblMinuteTime.font = fontTime
        
        lblHour.text = "O'Clock"
        lblHourTime.text = String((CommanCode.hourMinutequestLevel_1_Array[0])[0])
        lblMinute.text = "Minute"
        lblMinuteTime.text = String((CommanCode.hourMinutequestLevel_1_Array[0])[1])
        if (levelNumber == 1) {
//            lblHour.backgroundColor = UIColor.yellow
            trailingHourLbl.constant = -85
            lblMinute.isHidden = true
            lblMinuteTime.isHidden = true
        }*/

        
        

//        for getQuestionTime in CommanCode.hourMinutequestLevel_1_Array {
//            //----------------------------------------------------------------------------------------
//            var getHrVal = getQuestionTime[0]
//            var getMinVal = getQuestionTime[1]
//            //Initial Clock value set
//            let getHourAngle = CommanCode.hourAngleArray[getHrVal]
//            var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
//            viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
//
//            let getMinuteAngle = CommanCode.minuteAngleArray[getMinVal]
//            handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
//            viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
//            //----------------------------------------------------------------------------------------
//        }

        
     /*   lblSetTime.layer.shadowColor = UIColor.white.cgColor
        lblSetTime.layer.shadowRadius = 3.0
        lblSetTime.layer.shadowOpacity = 1.0
        lblSetTime.layer.shadowOffset = CGSize(width: 4, height: 4)
        lblSetTime.layer.masksToBounds = false*/

        playSet()

//        viewClocket.clockFace.tintColor = UIColor.green
        
  //      \\\ = CommanCode.ORANGE_Color
        
//        let loaderGif1 = UIImage.gifImageWithName("Lady_Teaching")
//        imgView.image = loaderGif1
    }
//    func setTimeInQuestion() {
//        let getHourAngle = CommanCode.hourAngleArray[CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0]]
//        var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
//        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
//        let getMinuteAngle = CommanCode.minuteAngleArray[CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]]
//        handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
//        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
//    }
    
    func setInitialTime() {
        let getHourAngle = CommanCode.hourAngleArray[10]
        var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        let getMinuteAngle = CommanCode.minuteAngleArray[10]
        handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
    }
    
    func setsimpleLabel() {
        if (CommanCode.hourMinutequestLevel_1_Array[indexQuestion][1]) != 0 {
            var texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])+"\(clockTitle)")

            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 27, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(clockTitle.count-1)))
            
            
            var texViewAttrString1: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])+"\(minuteTitle)")


            texViewAttrString1.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 27, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString1.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(minuteTitle.count)-1))
            
            var concate = NSMutableAttributedString(attributedString: texViewAttrString)
            concate.append(texViewAttrString1)
            lblSimpleTime.attributedText = concate
        } else {
            var texViewAttrString: NSMutableAttributedString = NSMutableAttributedString(string: String(CommanCode.hourMinutequestLevel_1_Array[indexQuestion][0])+"\(clockTitle)")

            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 27, weight: .bold),range: NSRange(location: 0, length:2))
            
            texViewAttrString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20, weight: .regular),range: NSRange(location: 2, length:(clockTitle.count-1)))
            
            lblSimpleTime.attributedText = texViewAttrString

        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if defaults.bool(forKey:"IsPrimeUser") {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = true
            }
        //                if bannerView != nil {
        //                    bannerView.removeFromSuperview()
        //                }

        } else {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = false
            }
        }
    }
    // MARK: - User defined Functions
    @IBAction func funcBackToHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    func nextQuestion() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//            self.viewExtend.alpha = 0
//        }
        UIView.transition(with: self.viewExtend, duration: 2, options: .transitionFlipFromTop, animations: nil, completion: { (_) in
           // self.viewExtend.alpha = 1
            self.setInitialTime()
        })
    }

    @IBAction func func_Forward_Clicked(_ sender: UIButton) {
        var getIndex = indexQuestion + 1
        if !(getIndex >= (CommanCode.hourMinutequestLevel_1_Array.count)) {
            if (getIndex == (CommanCode.hourMinutequestLevel_1_Array.count-1)) {
                btnForward.isHidden = true
            } else {
                btnForward.isHidden = false
            }
            indexQuestion = getIndex
           // setTimeInQuestion()
            setsimpleLabel()
            nextQuestion()
        } else {
            btnForward.isHidden = true
        }
        btnBackward.isHidden = false
    }
    @IBAction func func_Backward_Clicked(_ sender: UIButton) {
        var getIndex = indexQuestion - 1
        if !(getIndex <= 0) {
            if getIndex == 0 {
                btnBackward.isHidden = true
            } else {
                btnBackward.isHidden = false
            }
            indexQuestion = getIndex
            nextQuestion()
            setsimpleLabel()
        } else {
            btnBackward.isHidden = true
        }
        btnForward.isHidden = false
    }

    @IBAction func funcDoneClicked(_ sender: UIButton) {
      /*  var isHourCorrect = false
        var isMinuteCorrect = false
        
        if levelNumber == 1 {
            let getQuestionTime = CommanCode.hourMinutequestLevel_1_Array[iCountQuestionArray]
            
            let getHourAngle = CommanCode.hourAngleArray[getQuestionTime[0]]
            let getMinuteAngle = CommanCode.minuteAngleArray[getQuestionTime[1]]
            
            
            if getHourAngle == 0 {
                var  startNumber = CommanCode.hourAngleArray[11]
                var endNumber = CommanCode.hourAngleArray[1]
                var numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualHourAngle {
                    isHourCorrect = true
                }
            } else if getHourAngle == 11 {
                var  startNumber = CommanCode.hourAngleArray[11]
                var endNumber = CommanCode.hourAngleArray[1]
                var numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualHourAngle {
                    isHourCorrect = true
                }

            }
            
            if iCountQuestionArray == 0 {
                var  startNumber = CommanCode.hourAngleArray[11]
                var endNumber = CommanCode.hourAngleArray[1]
                var numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualHourAngle {
                    isHourCorrect = true
                }
                startNumber = CommanCode.minuteAngleArray[59]
                endNumber = CommanCode.minuteAngleArray[1]
                numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualMinuteAngle {
                    isMinuteCorrect = true
                }
            } else if iCountQuestionArray == (CommanCode.hourMinutequestLevel_1_Array.count - 1) {
                var  startNumber = CommanCode.hourAngleArray[11]
                var endNumber = CommanCode.hourAngleArray[1]
                var numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualHourAngle {
                    isHourCorrect = true
                }
                startNumber = CommanCode.minuteAngleArray[59]
                endNumber = CommanCode.minuteAngleArray[1]
                numberRange = startNumber...endNumber
                if numberRange  ~= viewClocket.setManualMinuteAngle {
                    isMinuteCorrect = true
                }
            } else {
                
            }
        }*/
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
        let path = Bundle.main.path(forResource: "15_Minutes", ofType : "mp3")!
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("finished")//It is working now! printed "finished"!
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
