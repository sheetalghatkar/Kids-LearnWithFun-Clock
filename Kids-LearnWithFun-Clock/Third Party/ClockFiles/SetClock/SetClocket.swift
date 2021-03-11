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
    var isPreviousValueNegative = false

    
    var viewHourHand = UIView()
    var hourHandFirstSubview = UIView()
    var hourHandSecondSubview = UIImageView()

    var viewMinuteHand  = UIView()
    var minuteHandFirstSubview = UIView()
    var minuteHandSecondSubview = UIImageView()
//-------------
    //Code for set hands
    var setManualHourAngle = CommanCode.hourAngleArray[10]
    var setManualMinuteAngle = CommanCode.minuteAngleArray[10]
    var hourRangeIndex = 10
//-------------
    var mainGestureRecognizer = UITapGestureRecognizer()
    var subGestureRecognizer =  UITapGestureRecognizer()
    var idChageHourVal = false
    var isHourComplete = true // to work reverse minute hand
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
    weak open var clockDelegate: SetClocketDelegate?
    var setHourHandIndex = 10

    
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
//        setupHands()
        setupClockFace()
        setupGestures()
    }
    
    private func setupClockFace() {
        clockFace = SetClockFace(frame: frame)
     /*   if UIDevice.current.hasNotch */
        addSubview(clockFace)
//      clockFace.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor).isActive = true
//      clockFace.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
//      clockFace.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
//      clockFace.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor).isActive = true
        
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
        hourHandSecondSubview = UIImageView(frame: CGRect(x: hourHandFirstSubview.frame.width , y: 0, width: (viewHourHand.frame.width)/2, height: viewHourHand.frame.height))
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
//        centerImageView.center.y = ((self.clockFace.frame.size.height)/2)
//        centerImageView.image = CommanCode.CLOCK_CENTER_IMG
        
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
            print("Hour image touched")
            viewMinuteHand.alpha = 0.7
            viewHourHand.alpha = 1.0
            isHourHandTouch = true
            isMinuteHandTouch = false
        } else if touch.view == viewMinuteHand {
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
        //let distanceToCenter = sqrt(pow((tapLocation.x - center.x), 2) + pow((tapLocation.y - center.y), 2))

       /* //tap within the circle smaller than hand tail to set the second hand to zero
        if distanceToCenter < min(10.0, viewSize/10.0) {
            if localTime.second != 0 {
                secondHand.updateHandAngle(angle: CGFloat(0), duration: 0.5)
            } else {
                secondHand.updateHandAngle(angle: CGFloat(2*Double.pi/3), duration: 1.0)
                secondHand.updateHandAngle(angle: CGFloat(4*Double.pi/3), duration: 1.0)
                secondHand.updateHandAngle(angle: CGFloat(0.0), duration: 1.0)
            }
            localTime.second = 0
            clockDelegate?.timeIsSetManually()
            return
        }*/
        let handRadianAngle = Double(Float.pi/2 - atan2((Float(tapLocation.x - center.x)),
                                                       (Float(tapLocation.y - center.y))))
            
//            let handRadianAngle = atan2((Float(tapLocation.x - center.x)),
//                                                           (Float(tapLocation.y - center.y)))

                  
                  
                var getLocationDiff = Double(atan2((Float(tapLocation.x - center.x)),
                                     (Float(tapLocation.y - center.y))))
            
            let divisor = pow(10.0, Double(2.0))
            getLocationDiff = (round(Double(getLocationDiff) * divisor) / divisor)

//            print("#####atan2", getLocationDiff)
            

            
            
            


//            print("@@@@@@@@handRadianAngle",handRadianAngle)
//            print("tapLocation.x-----",tapLocation.x)
//            print("tapLocation.y-----",tapLocation.y)
           /* print("Float.pi-----",Float.pi)
            print("center.x-----",center.x)
            print("center.y-----",center.y)*/

            

        //tap or pan on the outer area of the clockface to set the minute hand
//        if distanceToCenter / max(10.0, viewSize/2) > hourHandLength * 1.1 {
        if isMinuteHandTouch {
         //   setHourHandPosition()
           // print("@@@------isMinuteHandTouch---------", Double(getLocationDiff))

            setManualMinuteAngle = Double(getLocationDiff)
           // print("setManualMinuteAngle --",getLocationDiff)

            funcResetHourAsPerMinuteHand()
            viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
//            let newMinuteValue = Int(0.5 + handRadianAngle * 30 / (Double.pi/2)) % 60
           /* let newMinuteValue = Int(handRadianAngle * 6 / (Double.pi/2)) % 60

            if newMinuteValue == 0 && localTime.minute == 59 {
                localTime.hour = ((localTime.hour ?? 1) + 1) % 12
            } else if newMinuteValue == 59 && localTime.minute == 0 {
                localTime.hour = ((localTime.hour ?? 1) - 1) % 12
            }
            localTime.minute = newMinuteValue*/
            
//            print("Minute value", localTime.minute)

            //tap or pan on the area of the clockface between the center and the edge to set the hour hand
        }
        
        else if isHourHandTouch {
           // print("@@@------isHourHandTouch---------", Double(getLocationDiff))
            setManualHourAngle = Double(getLocationDiff)
          //  print("setManualHourAngle --",setManualHourAngle)
            viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
      /*  //} else if distanceToCenter / (viewSize/2) < hourHandLength {
            localTime.hour = Int(handRadianAngle * 6 / Double.pi)
            let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
           // print("###hourDegree###",hourDegree)
            viewHourHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian), duration: 0.5)*/
        }
        clockDelegate?.timeIsSetManually()
        } else {
            print("Touch parent view")
        }
    }

    func setHourHandPosition() {
     /*   var startNumber = (CommanCode.hourAngleRangeArray[hourRangeIndex])[0]
        var endNumber = (CommanCode.hourAngleRangeArray[hourRangeIndex])[1]
        var numberRange = startNumber...endNumber
        if numberRange  ~= setManualHourAngle {
            print("######--- 10 O'clock")
        } else {
            print("######--- 10 O'clock")
        }
        for iCount in 0..<CommanCode.minuteCalculationArray.count {
            let minValue = CommanCode.minuteCalculationArray[iCount]
            let startNumber = minValue[0]
            let endNumber = minValue[1]
            let numberRange = startNumber...endNumber
            if numberRange  ~= setManualMinuteAngle {
                
            }
        }*/
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
       // secondHand.updateHandAngle(angle: CGFloat(Double(localTime.second * 6) * translateToRadian))
        viewHourHand.updateHandAngle(angle: CGFloat(Double((localTime.minute ?? 1) * 6) * translateToRadian))
        let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
        viewMinuteHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian))
    }
    
    
    private func countDownTimerAlert() {
        //implement any alert actions here for the countDown timer expiring
        clockDelegate?.countDownExpired()
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
                print("heyyyyyyyyyy")
                funcResetHourHandToMagicNumber()
                setManualMinuteAngle = CommanCode.minuteAngleArray[0]
                print("heyyyyyyyyyy-------",setManualMinuteAngle)
                let handRadianAngle = Double(Float.pi/2 - Float(setManualMinuteAngle))
                viewMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
                isHourComplete = true
            }
            if isMinuteHandTouch {
                funcResetMinuteHandToMagicNumber()
            }
            
            isHourHandTouch = false
            isMinuteHandTouch = false
            clockDelegate?.timeIsSetManually()
        default:
            break
        }
    }
    
}

extension UIView {
    func updateHandAngle(angle: CGFloat, duration: Double = 0.5) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { self.transform = CGAffineTransform(rotationAngle: angle) },
                       completion: { (finished: Bool) in
                        return
        })
    }
}


public protocol SetClocketDelegate: AnyObject {
    
    func timeIsSetManually()
    
    func clockStopped()
    
    func countDownExpired()
}


extension SetClocket {
  /*   var hourAngleArray: [Double] = [3.12,2.60,2.07,1.56,1.05,0.55,-0.02,-0.56,-1.04,-1.60,-2.10,-2.60]
    //------------------------------------------------------------------------
    var hourAngleRangeArray: [[Double]] = [[3.12,2.60],[2.60,2.07],[2.07,1.56],[1.56,1.05],[1.05,0.55],[0.55,-0.02],[-0.02,-0.56],[-0.56,-1.04],[-1.04,-1.60],[-1.60,-2.10],[-2.10,-2.60],[-2.60,-3.12]]
    //------------------------------------------------------------------------
    var hourCalculationArray = [[3.12,2.99,2.86,2.73,2.60],[2.60,2.46,2.33,2.20,2.07], [2.07,1.94,1.81,1.68,1.56],[1.56,1.43,1.30,1.17,1.05],[1.05,0.92,0.80, 0.67,0.55], [0.55,0.40,0.26,0.12,-0.02],[-0.02,-0.15,-0.29,-0.42,-0.56], [-0.56,-0.68,-0.80,-0.92,-1.04], [-1.04,-1.18,-1.32,-1.46,-1.60],[-1.60,-1.72,-1.85,-1.97,-2.10],[-2.10,-2.22,-2.35,-2.47,-2.60], [-2.60,-2.73,-2.86,-2.99,-3.12]]*/
    
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
        if setManualMinuteAngle < 0.0 {
            for iCount in 31..<CommanCode.minuteCalculationArray.count {
                let minunteValue = CommanCode.minuteCalculationArray[iCount]
                let startNumber = minunteValue[2]
                let endNumber = minunteValue[0]
                let numberRange = startNumber...endNumber
                if numberRange  ~= setManualMinuteAngle {
                    getMinuteAngleRangeIndex = iCount
                }
            }
        } else {
            for iCount in 0..<31 {
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
            if getMinuteAngleRangeIndex == 59 {
                getMinuteAngleRangeIndex = 0
            } else {
                getMinuteAngleRangeIndex = getMinuteAngleRangeIndex + 1
            }
        }
        setManualMinuteAngle = CommanCode.minuteAngleArray[getMinuteAngleRangeIndex]
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
          /*  if isMinuteShouldbeNegative{
                if getHourIndex == 11 {
                    getHourIndex = 0
                    print("inside 11 isMinuteShouldbeNegative------------",getHourIndex)
                } else {
                    getHourIndex = getHourIndex+1
                    print("inside isMinuteShouldbeNegative------------",getHourIndex)
                }
                setNewHrVal = CommanCode.hourAngleArray[getHourIndex]
            }*/
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
        let diviso1 = pow(10.0, Double(2.0))
        getDiff = Double(round(Double(getDiff) * diviso1) / diviso1)

        if getDiff == 0.00 || getDiff == -0.00  {
            
            if isMinuteShouldbeNegative {
                print("@@@@@@@@@--Inside isMinuteShouldbeNegative--@@@")
                isMinuteShouldbeNegative = false
                setManualHourAngle = setNewHrVal
                setManualHourAngle = Double(round(Double(setManualHourAngle) * divisor) / divisor)
                setHourHandIndex = getHourIndex
                let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
                viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
            }

            
            
            isHourComplete = true
            print("@@@@@@@@@getDiff is zero@@@")

            if !idChageHourVal {
                isMinuteShouldbeNegative = false
                idChageHourVal = true
                if isPreviousValueNegative {
                    print("getDiff  zer0idChageHourVal")
                    if getHourIndex == 11 {
                        print("getDiff is zero$$$$$$$---11")
                        getHourIndex = 0
                        setManualHourAngle = CommanCode.hourAngleArray[getHourIndex]
                    } else {
                        getHourIndex = getHourIndex+1
                        setManualHourAngle = CommanCode.hourAngleArray[getHourIndex]
                        print("getDiff is zero$$$$$---else", setManualHourAngle, getHourIndex)
                    }
                    setManualHourAngle = Double(round(Double(setManualHourAngle) * divisor) / divisor)
                    setHourHandIndex = getHourIndex
                    let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
                    viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
                } else {
                    isMinuteShouldbeNegative = true
                    if getHourIndex == 0 {
                        print("Reverse getDiff is zero$$$$$$$---11")
                       // getHourIndex = 11
                        setManualHourAngle = CommanCode.hourAngleArray[getHourIndex]
                    } else {
                        //getHourIndex = getHourIndex-1
                        setManualHourAngle = CommanCode.hourAngleArray[getHourIndex]
                        print("Reverse getDiff is zero$$$$$---else", setManualHourAngle, getHourIndex)
                    }
                    setManualHourAngle = Double(round(Double(setManualHourAngle) * divisor) / divisor)
                    setHourHandIndex = getHourIndex
//                    let handRadianAngle = Double(Float.pi/2 - Float(setManualHourAngle))
//                    viewHourHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.0)
                }
            }
        } else {
            isMinuteShouldbeNegative = false
            if setManualMinuteAngle < 0.0 {
                isPreviousValueNegative = true
            } else {
                isPreviousValueNegative = false
            }

            
//            if isHourComplete {
//                print("@@@@@@@@@getDiff  isHourComplete")
//                isHourComplete = false
//                if setManualMinuteAngle < 0.0 {
//                    print("@@@@@@@@@getDiff --ourComp < 0.0",getHourIndex)
//                    if getHourIndex == 0 {
//                        getHourIndex = 11
//                    } else {
//                        getHourIndex = getHourIndex - 1
//                    }
//                    setNewHrVal = CommanCode.hourAngleArray[getHourIndex]
//                  /*  getDiff = CommanCode.hourAngleDiffArray[getHourIndex]
//                    getDiff = (getDiff * Double(getMinuteAngleRangeIndex))/60.0
//                    let diviso1 = pow(10.0, Double(2.0))
//                    getDiff = Double(round(Double(getDiff) * diviso1) / diviso1)*/
//                }
//            }
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
//        print("================setNewHrVal", setNewHrVal, getHourIndex)
//        print("====================getDiff", getDiff)

       // print("Final Hour Set @@@@@@@@@@@@", setManualHourAngle)
    }
}
