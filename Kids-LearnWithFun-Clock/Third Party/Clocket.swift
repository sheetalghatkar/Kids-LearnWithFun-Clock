//
//  Clocket.swift
//  Clocket
//
//  Created by Andrey Filonov on 08/11/2018.
//  Copyright © 2018 Andrey Filonov. All rights reserved.
//

import UIKit


open class Clocket: UIView, UIGestureRecognizerDelegate {
    
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

    
    var viewpHourHand = UIView()
    var hourHandFirstSubview = UIView()
    var hourHandSecondImage = UIImageView()

    var viewpMinuteHand  = UIView()
    var minuteHandFirstSubview = UIView()
    var minuteHandSecondImage = UIImageView()

    public struct LocalTime {
        var hour: Int?
        var minute: Int?
        var second: Int = 1
    }
    
    open var localTime = LocalTime()
    open var timer = Timer()
    open var refreshInterval: TimeInterval = 1.0
    
    private var clockFace = UIImageView()
    private var secondHandCircle = UIImageView()
    weak open var clockDelegate: ClocketDelegate?
    
    
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
        clockFace = ClockFace(frame: frame)
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
        viewpHourHand.frame.size = CGSize(width: (CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT) - 120, height: 52.0)
        viewpHourHand.backgroundColor = UIColor.clear
        viewpHourHand.center.x = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewpHourHand.center.y = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewpHourHand.isUserInteractionEnabled = true
        self.addSubview(viewpHourHand)
        
        hourHandFirstSubview.isUserInteractionEnabled = true
        hourHandFirstSubview = UIView(frame: CGRect(x: 0, y: 0, width: ((viewpHourHand.frame.width)/2)-15, height: viewpHourHand.frame.height))
        hourHandFirstSubview.backgroundColor = UIColor.clear
        viewpHourHand.addSubview(hourHandFirstSubview)
        
        hourHandSecondImage.isUserInteractionEnabled = true
        hourHandSecondImage = UIImageView(frame: CGRect(x: hourHandFirstSubview.frame.width , y: 0, width: (viewpHourHand.frame.width)/2, height: viewpHourHand.frame.height))
        hourHandSecondImage.image = CommanCode.HOUR_HAND_IMG
        minuteHandSecondImage.contentMode = .scaleAspectFill

        hourHandSecondImage.backgroundColor = UIColor.clear
        viewpHourHand.addSubview(hourHandSecondImage)
        viewpHourHand.alpha = 0.7
    }
    
    func setUpMinuteHand() {
        let centerImageView = UIImageView()
        centerImageView.frame.size = CGSize(width: 45, height: 45)
        centerImageView.frame.origin.x = ((self.frame.size.width)/2) - (centerImageView.frame.size.width/2)
        centerImageView.frame.origin.y = (self.frame.size.height)/2 - (centerImageView.frame.size.height/2)
        centerImageView.backgroundColor = UIColor.blue
        centerImageView.layer.cornerRadius = 23.5
        
//        centerImageView.center.y = ((self.clockFace.frame.size.height)/2)
//        centerImageView.image = CommanCode.CLOCK_CENTER_IMG
        
        viewpMinuteHand.frame.size = CGSize(width: (CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT), height: 52.0)
        viewpMinuteHand.backgroundColor = UIColor.clear
        viewpMinuteHand.center.x = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewpMinuteHand.center.y = ((CommanCode.SCREEN_WIDTH * CommanCode.CLOCKET_WIDTH_PERCENT)/2)
        viewpMinuteHand.isUserInteractionEnabled = true
        self.addSubview(viewpMinuteHand)

        minuteHandFirstSubview.isUserInteractionEnabled = true
        minuteHandFirstSubview = UIView(frame: CGRect(x: 0, y: 0, width: (viewpMinuteHand.frame.width)/2, height: viewpMinuteHand.frame.height))
        minuteHandFirstSubview.backgroundColor = UIColor.clear
        viewpMinuteHand.addSubview(minuteHandFirstSubview)
        
        minuteHandSecondImage.isUserInteractionEnabled = true
        minuteHandSecondImage = UIImageView(frame: CGRect(x: (minuteHandFirstSubview.frame.width)-15 , y: 0, width: ((viewpMinuteHand .frame.width)/2) - 20, height: viewpMinuteHand .frame.height))
        minuteHandSecondImage.image = CommanCode.MINUTE_HAND_IMG
        minuteHandSecondImage.contentMode = .scaleAspectFill
        minuteHandSecondImage.backgroundColor = UIColor.clear
        viewpMinuteHand.addSubview(minuteHandSecondImage)
        
//        self.addSubview(centerImageView)
        viewpMinuteHand.alpha = 0.7
    }
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
       // print("-----touchesBegan-------",touch.view)
        if touch.view == viewpHourHand {
            print("Hour image touched")
            viewpMinuteHand.alpha = 0.7
            viewpHourHand.alpha = 1.0
            isHourHandTouch = true
            isMinuteHandTouch = false
        } else if touch.view == viewpMinuteHand {
            isMinuteHandTouch = true
            isHourHandTouch = false
            viewpHourHand.alpha = 0.7
            viewpMinuteHand.alpha = 1.0
            print("Minute image touched")
        }
    }


    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
      //  print("-----touchesEnded-------",touch)

            if touch.view == viewpHourHand {
                print("Hour image released")
                isHourHandTouch = false
                viewpMinuteHand.alpha = 0.7
            } else if touch.view == viewpMinuteHand {
                print("Minute image released")
                isMinuteHandTouch = false
                viewpHourHand.alpha = 0.7
            }
    }
    @objc private func handleTap(recognizer: UIPanGestureRecognizer){
      //  print("##########################################")
        if isMinuteHandTouch || isHourHandTouch {
        print("Inside handleTap")
        if !manualTimeSetAllowed {return}
        let tapLocation = recognizer.location(in: self)
        guard let view = recognizer.view else { return }
        let viewSize = min(view.bounds.size.width, view.bounds.size.height)
        let center = CGPoint(x: viewSize/2.0, y: viewSize/2.0)
        let distanceToCenter = sqrt(pow((tapLocation.x - center.x), 2) + pow((tapLocation.y - center.y), 2))

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
        let handRadianAngle = Double(Float.pi - atan2f((Float(tapLocation.x - center.x)),
                                                       (Float(tapLocation.y - center.y))))

        //tap or pan on the outer area of the clockface to set the minute hand
//        if distanceToCenter / max(10.0, viewSize/2) > hourHandLength * 1.1 {
        if isMinuteHandTouch {
            viewpMinuteHand.updateHandAngle(angle: CGFloat(handRadianAngle), duration: 0.1)
            let newMinuteValue = Int(0.5 + handRadianAngle * 30 / Double.pi) % 60

            if newMinuteValue == 0 && localTime.minute == 59 {
                localTime.hour = ((localTime.hour ?? 1) + 1) % 12
            } else if newMinuteValue == 59 && localTime.minute == 0 {
                localTime.hour = ((localTime.hour ?? 1) - 1) % 12
            }
            localTime.minute = newMinuteValue

            //tap or pan on the area of the clockface between the center and the edge to set the hour hand
        } else if isHourHandTouch {
        //} else if distanceToCenter / (viewSize/2) < hourHandLength {
            localTime.hour = Int(handRadianAngle * 6 / Double.pi)
            let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
           // print("###hourDegree###",hourDegree)
            viewpHourHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian), duration: 0.5)
        }
        clockDelegate?.timeIsSetManually()
        } else {
            print("Touch parent view")
        }
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
        viewpHourHand.updateHandAngle(angle: CGFloat(Double((localTime.minute ?? 1) * 6) * translateToRadian))
        let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
        viewpMinuteHand.updateHandAngle(angle: CGFloat(hourDegree * translateToRadian))
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
            viewpHourHand.alpha = 0.7
            viewpMinuteHand.alpha = 0.7
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


public protocol ClocketDelegate: AnyObject {
    
    func timeIsSetManually()
    
    func clockStopped()
    
    func countDownExpired()
}
