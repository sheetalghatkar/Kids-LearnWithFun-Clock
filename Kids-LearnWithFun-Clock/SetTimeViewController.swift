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
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var lblHourTime: UILabel!
    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblMinuteTime: UILabel!
    @IBOutlet weak var lblMinute: UILabel!

    var paymentDetailVC : PaymentDetailViewController?
    let defaults = UserDefaults.standard
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var player = AVAudioPlayer()
    var fromSet = false
    var fromHour = false
    var iCountQuestionArray = 0
    var levelNumber = 1


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
       // viewClocket.setLocalTime(hour: 10, minute: 10, second: 1)
        let getHourAngle = CommanCode.hourAngleArray[10]
        var handRadianAngle = ((Float.pi/2) - Float(getHourAngle))
        viewClocket.viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)

        let getMinuteAngle = CommanCode.minuteAngleArray[10]
        handRadianAngle = ((Float.pi/2) - Float(getMinuteAngle))
        viewClocket.viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        //----------------------------------------------------------------------------------------
        
        var hourCalculation = [[3.12,2.99,2.86,2.73,2.60],[2.60,2.46,2.33,2.20,2.07], [2.07,1.94,1.81,1.68,1.56],[1.56,1.43,1.30,1.17,1.05],[1.05,0.92,0.80, 0.67,0.55], [0.55,0.40,0.26,0.12,-0.02],[-0.02,-0.15,-0.29,-0.42,-0.56], [-0.56,-0.68,-0.80,-0.92,-1.04], [-1.04,-1.18,-1.32,-1.46,-1.60],[-1.60,-1.72,-1.85,-1.97,-2.10],[-2.10,-2.22,-2.35,-2.47,-2.60], [-2.60,-1.73,-0.86,-1.99,-3.12]]
        
        
        
        
        
        
        
        btnDone.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
        let fontTime = UIFont(name: "ChalkboardSE-Bold", size: 30)
        let fontLblTime = UIFont(name: "ChalkboardSE-Regular", size: 25)
        
        
        lblHour.textColor = UIColor.white
        lblMinute.textColor = UIColor.white
        lblHour.font = fontLblTime
        lblMinute.font = fontLblTime

        lblHourTime.textColor = UIColor.white
        lblMinuteTime.textColor = UIColor.white
        lblHourTime.font = fontTime
        lblMinuteTime.font = fontTime

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
        let path = Bundle.main.path(forResource: "3-Hour", ofType : "mp3")!
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
        let path = Bundle.main.path(forResource: "15-Minutes", ofType : "mp3")!
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
            playMinute()
        }
    }
}
