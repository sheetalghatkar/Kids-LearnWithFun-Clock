//
//  SetClocket.swift
//  SetClocket
//
//  Created by Andrey Filonov on 08/11/2018.
//  Copyright © 2018 Andrey Filonov. All rights reserved.
//

import UIKit


open class SetClocket: UIView, UIGestureRecognizerDelegate {
    
    private let translateToRadian = Double.pi/180.0
    open var secondHandLength: CGFloat = 0.9
    open var secondHandWidth: CGFloat = 0.03
    open var secondHandColor: UIColor = UIColor(red: 232/255, green: 60/255, blue: 60/255, alpha: 1.0)
    open var secondHandCircleDiameter: CGFloat = 4.0
    
    open var handTailLength: CGFloat = 0.2
    private var lineWidthCoefficient: CGFloat = 100.0
    private var lineWidth: CGFloat { return diameter / lineWidthCoefficient }
    private var diameter: CGFloat { return min(bounds.width, bounds.height) }
    
    @IBInspectable open var displayRealTime: Bool = false
    @IBInspectable open var reverseTime: Bool = false
    @IBInspectable open var manualTimeSetAllowed: Bool = true
    @IBInspectable open var countDownTimer: Bool = false
    @IBInspectable open var handShadow: Bool = true
    var isHourHandTouch = false
    var isMinuteHandTouch = false
    var isFrom = false

    
    var viewHourHand = UIView()
    var hourHandFirstSubview = UIView()
    var hourHandSecondSubview = UIImageView()

    var viewMinuteHand  = UIView()
    var minuteHandFirstSubview = UIView()
    var minuteHandSecondSubview = UIImageView()
//-------------
    //Code for set hands
    var setManualHourAngle = CommanCode.hourAngleArray[10]
    var setManualMinuteAngle = CommanCode.minuteAngleArray[0]
    var controlFromZeroDiff = true
    var isPreviousValueNegative = true
    var idChageHourVal = true
    var isHandsMove = false

   // var hourRangeIndex = 10
//-------------
    var mainGestureRecognizer = UITapGestureRecognizer()
    var subGestureRecognizer =  UITapGestureRecognizer()
    var isMinuteShouldbeNegative = false  // If minute hadn is treversing from
    public struct LocalTime {
        var hour: Int?
        var minute: Int?
        var second: Int = 1
    }
    
    open var localTime = LocalTime()
    open var timer = Timer()
    open var refreshInterval: TimeInterval = 1.0
    
    open var clockFace = UIImageView()
    private var secondHandCircle = UIImageView()
    weak open var setClockDelegate: SetClocketProtocol?
    var setHourHandIndex = 10
    var levelNumber = 1

    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        setupClockFace()
        setupGestures()
    }
    
    private func setupClockFace() {
        clockFace = SetClockFace(frame: frame)
        addSubview(clockFace)
        setUpHourHand()
        setUpMinuteHand()
        clockFace.layer.masksToBounds = false
        clockFace.layer.cornerRadius = 8; // if you like rounded corners
        clockFace.layer.shadowOffset = CGSize(width: 5, height: 5)
        clockFace.layer.shadowRadius = 5;
        clockFace.layer.shadowOpacity = 0.5;
    }
    func setUpHourHand() {
        viewHourHand.frame.size = CGSize(width: (CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT) - 120, height: 52.0)
        viewHourHand.backgroundColor = UIColor.clear
        viewHourHand.center.x = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewHourHand.center.y = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewHourHand.isUserInteractionEnabled = true
        viewHourHand.isHidden = false
        self.addSubview(viewHourHand)
        
        hourHandFirstSubview.isUserInteractionEnabled = true
        hourHandFirstSubview = UIView(frame: CGRect(x: 0, y: 0, width: ((viewHourHand.frame.width)/2)-15, height: viewHourHand.frame.height))
        hourHandFirstSubview.backgroundColor = UIColor.clear
        viewHourHand.addSubview(hourHandFirstSubview)
        
        hourHandSecondSubview.isUserInteractionEnabled = true
        hourHandSecondSubview = UIImageView(frame: CGRect(x: hourHandFirstSubview.frame.width-13 , y: 0, width: (viewHourHand.frame.width)/2, height: viewHourHand.frame.height))
        hourHandSecondSubview.image = CommanCode.HOUR_HAND_IMG
        hourHandSecondSubview.contentMode = .scaleAspectFill

        hourHandSecondSubview.backgroundColor = UIColor.clear
        viewHourHand.addSubview(hourHandSecondSubview)
        viewHourHand.alpha = 0.7
    }
    
    func setUpMinuteHand() {
        let centerImageView = UIImageView()
        centerImageView.frame.size = CGSize(width: 45, height: 45)
        centerImageView.frame.origin.x = ((self.frame.size.width)/2) - (centerImageView.frame.size.width/2)
        centerImageView.frame.origin.y = (self.frame.size.height)/2 - (centerImageView.frame.size.height/2)
        centerImageView.backgroundColor = UIColor.blue
        centerImageView.layer.cornerRadius = 23.5
        viewMinuteHand.alpha = 0.3
        viewMinuteHand.frame.size = CGSize(width: (CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT), height: 15)
        viewMinuteHand.backgroundColor = UIColor.clear
        viewMinuteHand.center.x = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewMinuteHand.center.y = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewMinuteHand.isUserInteractionEnabled = true
        viewMinuteHand.backgroundColor = UIColor.clear
        self.addSubview(viewMinuteHand)

        minuteHandFirstSubview.isUserInteractionEnabled = true
        minuteHandFirstSubview = UIView(frame: CGRect(x: 0, y: 0, width: (viewMinuteHand.frame.width)/2, height: viewMinuteHand.frame.height))
        minuteHandFirstSubview.backgroundColor = UIColor.clear
        viewMinuteHand.addSubview(minuteHandFirstSubview)
        
        minuteHandSecondSubview.isUserInteractionEnabled = true
        minuteHandSecondSubview = UIImageView(frame: CGRect(x: (minuteHandFirstSubview.frame.width)+15 , y: 0, width: ((viewMinuteHand .frame.width)/2), height: viewMinuteHand .frame.height))
        minuteHandSecondSubview.image = CommanCode.MINUTE_HAND_IMG
        minuteHandSecondSubview.contentMode = .scaleAspectFill
        minuteHandSecondSubview.backgroundColor = UIColor.clear
        viewMinuteHand.addSubview(minuteHandSecondSubview)
        
       /* let tap = UITapGestureRecognizer(target: self, action: #selector(self.minuteHandFirstSubClicked(sender:)))
        tap.cancelsTouchesInView = false
        minuteHandFirstSubview.addGestureRecognizer(tap)*/
        
//        self.addSubview(centerImageView)
        viewMinuteHand.alpha = 0.7
    }
   /* @objc func minuteHandFirstSubClicked(sender:UITapGestureRecognizer) {
        print("Inside minuteHandFirstSubClicked")
//        self.viewHourHand.bringSubviewToFront(viewMinuteHand)
    }*/

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
       // print("-----touchesBegan-------",touch.view)
        if touch.view == viewHourHand {
            setClockDelegate?.didHandSMove()
            print("Hour image touched")
            viewMinuteHand.alpha = 0.7
            viewHourHand.alpha = 1.0
            isHourHandTouch = true
            isMinuteHandTouch = false
        } else if touch.view == viewMinuteHand {
            setClockDelegate?.didHandSMove()
            isMinuteHandTouch = true
            isHourHandTouch = false
            viewHourHand.alpha = 0.7
            viewMinuteHand.alpha = 1.0
            print("Minute image touched")
        }
    }


    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        print("-----touchesEnded-------")

            if touch.view == viewHourHand {
                print("Hour image released")
                isHourHandTouch = false
                viewMinuteHand.alpha = 0.7
            } else if touch.view == viewMinuteHand {
                print("Minute image released")
                isMinuteHandTouch = false
                viewHourHand.alpha = 0.7
            }
    }
    @objc private func handleTap(recognizer: UIPanGestureRecognizer){
      //  print("##########################################")
        if isMinuteHandTouch || isHourHandTouch {
         // print("Inside handleTap")
        if !manualTimeSetAllowed {return}
        let tapLocation = recognizer.location(in: self)
        guard let view = recognizer.view else { return }
        let viewSize = min(view.bounds.size.width, view.bounds.size.height)
        let center = CGPoint(x: viewSize/2.0, y: viewSize/2.0)
        let handRadianAngle = Double(Float.pi/2 - atan2((Float(tapLocation.x - center.x)),
                                                       (Float(tapLocation.y - center.y))))
                var getLocationDiff = Double(atan2((Float(tapLocation.x - center.x)),
                                     (Float(tapLocation.y - center.y))))
            
            let divisor = pow(10.0, Double(2.0))
            getLocationDiff = (round(Double(getLocationDiff) * divisor) / divisor)
        if isMinuteHandTouch {
            setManualMinuteAngle = Double(getLocationDiff)
            if levelNumber != 1 {
                funcResetHourAsPerMinuteHand()
            }
            viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        }
        
        else if isHourHandTouch {
            setManualHourAngle = Double(getLocationDiff)
            viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        }
        //clockDelegate?.timeIsSetManually()
        } else {
            print("Touch parent view")
        }
    }

    func setHourHandPosition() {
    }
    
    private func setupGestures() {
        let panRecognizer = UIPanGestureRecognizer(target: self, action:#selector(handlePan(recognizer:)))
        panRecognizer.delegate = self
        self.addGestureRecognizer(panRecognizer)
    }


    
    open func setLocalTime(hour: Int, minute: Int, second: Int) {
        localTime.hour = hour % 12
        localTime.minute = minute % 60
        localTime.second = second % 60
        updateHands()
    }
    
    
    open func startClock() {
        if timer.isValid {
            timer.invalidate()
            return
        }
        if displayRealTime {
            refreshInterval = 1.0
        }
        if countDownTimer {
            reverseTime = true
        }
        timer = Timer.scheduledTimer(timeInterval: refreshInterval, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }
    
    
    open func stopClock() {
        timer.invalidate()
    }
    
    
    @objc private func tick() {
        if displayRealTime {
            let localTimeComponents: Set<Calendar.Component> = [.hour, .minute, .second]
            let realTimeComponents = Calendar.current.dateComponents(localTimeComponents, from: Date())
            localTime.second = realTimeComponents.second ?? 0
            localTime.minute = realTimeComponents.minute ?? 10
            localTime.hour = realTimeComponents.hour ?? 10
        } else {
            localTime.second += reverseTime ? -1 : 1
            if localTime.second == 60 {
                localTime.second = 0
                localTime.minute = ((localTime.minute ?? 1) + 1) % 60
                if localTime.minute == 0 {
                    localTime.hour = ((localTime.hour ?? 1) + 1) % 12
                }
            } else if localTime.second == -1 {
                localTime.second = 59
                localTime.minute! -= 1
                if localTime.minute == -1 {
                    localTime.minute = 59
                    localTime.hour = ((localTime.hour ?? 1) - 1) % 12
                }
            }
            if countDownTimer {
                if localTime.hour ?? 1 <= 0 && localTime.minute ?? 1 <= 0 && localTime.second <= 0 {
                    setLocalTime(hour: 0, minute: 0, second: 0)
                    stopClock()
                    countDownTimerAlert()
                    return
                }
            }
        }
        updateHands()
    }
    
    
    private func updateHands() {
        viewHourHand.updateHandAngle(angle: CGFloat(Double((localTime.minute ?? 1) * 6) * translateToRadian))
        let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
        viewMinuteHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian))
    }
    
    
    private func countDownTimerAlert() {
        //implement any alert actions here for the countDown timer expiring
       // clockDelegate?.countDownExpired()
    }
    
    @objc private func handlePan(recognizer: UIPanGestureRecognizer) {
        if !manualTimeSetAllowed {return}
        switch recognizer.state {
        case .changed:
            handleTap(recognizer: recognizer)
            break
        case .ended:
            viewHourHand.alpha = 0.7
            viewMinuteHand.alpha = 0.7
            
            if isHourHandTouch {
//                print("heyyyyyyyyyy")
                funcResetHourHandToMagicNumber()
                if levelNumber != 1 {
                    funcResetHourHandToMagicNumber()
                    funcResetHourAsPerMinuteHand()

                  /*  setManualMinuteAngle = CommanCode.minuteAngleArray[0]
//                    print("heyyyyyyyyyy-------",setManualMinuteAngle)
                    let handRadianAngle = Double(Float.pi/2 - Float(setManualMinuteAngle))
                    viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)*/
                }
            }
            if isMinuteHandTouch {
                funcResetMinuteHandToMagicNumber()
            }
            
            isHourHandTouch = false
            isMinuteHandTouch = false
           // clockDelegate?.timeIsSetManually()
        default:
            break
        }
    }
    
}

public protocol SetClocketProtocol: AnyObject {
    func didHandSMove()
    /*func timeIsSetManually()
    
    func clockStopped()
    
    func countDownExpired()*/
}


extension SetClocket {
    func funcResetHourHandToMagicNumber() {
       // print("@@@@@@@@@@@@@@@@@@---funcResetHourHandToMagicNumber")
        var gethourAngleRangeIndex = 0
        if setManualHourAngle < 0.0 {
            for iCount in 5..<CommanCode.hourCalculationArray.count {
                let hourValue = CommanCode.hourCalculationArray[iCount]
                let startNumber = hourValue[4]
                let endNumber = hourValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualHourAngle {
                    gethourAngleRangeIndex = iCount
                }
            }
        } else {
            for iCount in 0..<6 {
                let hourValue = CommanCode.hourCalculationArray[iCount]
                let startNumber = hourValue[4]
                let endNumber = hourValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualHourAngle {
                    gethourAngleRangeIndex = iCount
                }
            }
        }
        let hourrangeVal = CommanCode.hourCalculationArray[gethourAngleRangeIndex]
        if setManualHourAngle > hourrangeVal[2] {
            setManualHourAngle = CommanCode.hourAngleArray[gethourAngleRangeIndex]
        } else {
            if gethourAngleRangeIndex == 11 {
                gethourAngleRangeIndex = 0
                setManualHourAngle = CommanCode.hourAngleArray[gethourAngleRangeIndex]
            } else {
                gethourAngleRangeIndex = gethourAngleRangeIndex + 1
                setManualHourAngle = CommanCode.hourAngleArray[gethourAngleRangeIndex]
            }
        }
        setHourHandIndex =  gethourAngleRangeIndex
       // print("setManualHourAngle --",setManualHourAngle)
        let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
        viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
    }
    func funcResetMinuteHandToMagicNumber() {
        var getMinuteAngleRangeIndex = 0
        print("!!!!setManualMinuteAngle",setManualMinuteAngle)
        if setManualMinuteAngle < 0.0 {
            for iCount in 30..<CommanCode.minuteCalculationArray.count {
                print("!!!!@@@@@@@@@@@@@@@@@@@@1",iCount)
                let minunteValue = CommanCode.minuteCalculationArray[iCount]
                let startNumber = minunteValue[2]
                let endNumber = minunteValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualMinuteAngle {
                    getMinuteAngleRangeIndex = iCount
                }
            }
        } else {
            for iCount in 0..<30 {
                print("!!!!@@@@@@@@@@@@@@@@@@@@2",iCount)
                let minunteValue = CommanCode.minuteCalculationArray[iCount]
                let startNumber = minunteValue[2]
                let endNumber = minunteValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualMinuteAngle {
                    getMinuteAngleRangeIndex = iCount
                }
            }
        }
        
        let minAngleVal = CommanCode.minuteCalculationArray[getMinuteAngleRangeIndex]
        if  setManualMinuteAngle <  minAngleVal[1] {
            print("------------------ 59")
            if getMinuteAngleRangeIndex == 59 {
                print("------------if 59")
                getMinuteAngleRangeIndex = 0
            } else {
                print("------------else 59")
                getMinuteAngleRangeIndex = getMinuteAngleRangeIndex + 1
            }
        }
        setManualMinuteAngle = CommanCode.minuteAngleArray[getMinuteAngleRangeIndex]
        print("------------setManualMinuteAngle",setManualMinuteAngle)
        let handRadianAngle = Double(Float.pi/2 - Float(setManualMinuteAngle))
        viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
    }
    func funcResetHourAsPerMinuteHand() {
        print("-------------------------------------------setHourHandIndex",setHourHandIndex)
        var getHourIndex = 0
        let hourValue1 = CommanCode.hourCalculationArray[setHourHandIndex]
        let startNumber1 = hourValue1[4]
        let endNumber1 = hourValue1[0]
        let numberRange1 = startNumber1...endNumber1
        if numberRange1  ~= setManualHourAngle {
            getHourIndex = setHourHandIndex
                print("!!!!---------------1-Hour",getHourIndex,setManualHourAngle)
        } else {
            if (CommanCode.hourAngleArray).contains(setManualHourAngle) {
                getHourIndex = (CommanCode.hourAngleArray).firstIndex(of: setManualHourAngle) ?? 0
                print("!!!!---------------2-Hour",getHourIndex,setManualHourAngle)

            } else {
                if setManualHourAngle < 0.0 {
                    for iCount in 5..<CommanCode.hourCalculationArray.count {
                        let hourValue = CommanCode.hourCalculationArray[iCount]
                        let startNumber = hourValue[4]
                        let endNumber = hourValue[0]
                        let numberRange = startNumber...endNumber
                        if numberRange  ~= setManualHourAngle {
                            getHourIndex = iCount
                        }
                    }
                    print("!!!!--------------3-Hour",getHourIndex,setManualHourAngle)
                } else {
                    for iCount in 0..<6 {
                        let hourValue = CommanCode.hourCalculationArray[iCount]
                        let startNumber = hourValue[4]
                        let endNumber = hourValue[0]
                        let numberRange = startNumber...endNumber
                        if numberRange  ~= setManualHourAngle {
                            getHourIndex = iCount
                        }
                    }
                    print("!!!!--------------4-Hour",getHourIndex,setManualHourAngle)

                }
            }
        }
        var setNewHrVal = CommanCode.hourAngleArray[getHourIndex]
       //-------------------------------------------------------------------------------
        //Minute caluclation part
        let divisor = pow(10.0, Double(2.0))
        setManualMinuteAngle = Double(round(Double(setManualMinuteAngle) * divisor) / divisor)
            print("-------------Minute_Get_Val",setManualMinuteAngle)
        var getMinuteAngleRangeIndex = 0
        if setManualMinuteAngle < 0.0 {
            isMinuteShouldbeNegative = false
            for iCount in 30..<CommanCode.minuteCalculationArray.count {
                let minunteValue = CommanCode.minuteCalculationArray[iCount]
                let startNumber = minunteValue[2]
                let endNumber = minunteValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualMinuteAngle {
                    getMinuteAngleRangeIndex = iCount
                }
            }
            print("!!!!--------------5-Mint",getMinuteAngleRangeIndex,setManualMinuteAngle)

        } else {
            for iCount in 0..<30 {
                let minunteValue = CommanCode.minuteCalculationArray[iCount]
                let startNumber = minunteValue[2]
                let endNumber = minunteValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualMinuteAngle {
                    getMinuteAngleRangeIndex = iCount
                }
            }
            print("!!!!--------------6-Mint",getMinuteAngleRangeIndex,setManualMinuteAngle)
        }
        
        let minAngleVal = CommanCode.minuteCalculationArray[getMinuteAngleRangeIndex]
        if  setManualMinuteAngle <  minAngleVal[1] {
            if getMinuteAngleRangeIndex == 59 {
                getMinuteAngleRangeIndex = 0
            } else {
                getMinuteAngleRangeIndex = getMinuteAngleRangeIndex + 1
            }
            print("!!!!--------------7-Mint",getMinuteAngleRangeIndex,setManualMinuteAngle)
        }
        

        var getDiff = CommanCode.hourAngleDiffArray[getHourIndex]
        getDiff = (getDiff * Double(getMinuteAngleRangeIndex))/60.0
        var diviso1 = pow(10.0, Double(2.0))
        getDiff = Double(round(Double(getDiff) * diviso1) / diviso1)

        if getDiff == 0.00 || getDiff == -0.00  {
            controlFromZeroDiff = true
            if !idChageHourVal {
                if isPreviousValueNegative {
                    idChageHourVal = true
                    if getHourIndex == 11 {
                        getHourIndex = 0
                    } else {
                        getHourIndex = getHourIndex+1
                    }
                    setHourHandIndex = getHourIndex
                    setManualHourAngle = CommanCode.hourAngleArray[setHourHandIndex]
                    setManualHourAngle = Double(round(Double(setManualHourAngle) * divisor) / divisor)
                    let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
                    viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
                } else {
                    
                }
            }
        } else {
            if setManualMinuteAngle < 0.0 {
                isPreviousValueNegative = true
            } else {
                isPreviousValueNegative = false
            }
            if controlFromZeroDiff {
                controlFromZeroDiff = false
                if setManualMinuteAngle < 0.0 {
                    if getHourIndex == 0 {
                        getHourIndex = 11
                    } else {
                        getHourIndex = getHourIndex-1
                    }
                    setNewHrVal = CommanCode.hourAngleArray[getHourIndex]
                    getDiff = CommanCode.hourAngleDiffArray[getHourIndex]
                    getDiff = (getDiff * Double(getMinuteAngleRangeIndex))/60.0
                    diviso1 = pow(10.0, Double(2.0))
                    getDiff = Double(round(Double(getDiff) * diviso1) / diviso1)
                }
            }
            
            idChageHourVal = false
            if setNewHrVal > 0.0 {
                print("==========Plus=============")
                setManualHourAngle = setNewHrVal-getDiff
            } else {
                print("==========Minus=============")
                setManualHourAngle = setNewHrVal+getDiff
            }
            setManualHourAngle = Double(round(Double(setManualHourAngle) * divisor) / divisor)
            setHourHandIndex = getHourIndex
            let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
            viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
        }
    }
}
