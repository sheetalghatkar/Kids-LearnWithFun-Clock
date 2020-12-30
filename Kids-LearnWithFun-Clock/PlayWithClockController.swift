//
//  PlayWithClockController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 27/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit

class PlayWithClockController: UIViewController {
    var midViewX = CGFloat()
    var midViewY = CGFloat()

    var circlePath2 = UIBezierPath()
//    var shapeLayer2 = CAShapeLayer()
    var shapeLayer3 = CAShapeLayer()
    public struct LocalTime {
        var hour: Int?     //= 7
        var minute: Int?
        var second: Int = 1
    }
    private let translateToRadian = Double.pi/180.0
    open var localTime = LocalTime()
    var xyz : UIView?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        midViewX = self.view.frame.midX
        midViewY = self.view.frame.midY
        // Do any additional setup after loading the view, typically from a nib.
       let circlePath = UIBezierPath(arcCenter: CGPoint(x: midViewX,y: midViewY), radius: CGFloat(100), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 3.0
        view.layer.addSublayer(shapeLayer)
        /*xyz = UIView(frame : CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: 100, height: 20))
        xyz?.backgroundColor = UIColor.yellow
        self.view.addSubview(xyz!)
       /* var angleEarth: Double = 180
        var angleEarthAfterCalculate: CGFloat = CGFloat(angleEarth*M_PI/180) - CGFloat(M_PI/2)
        var earthX = midViewX + cos(angleEarthAfterCalculate)*100
        var earthY = midViewY + sin(angleEarthAfterCalculate)*100
        circlePath2 = UIBezierPath(arcCenter: CGPoint(x: earthX,y: earthY), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)*/
        shapeLayer2.path = circlePath2.cgPath
        shapeLayer2.fillColor = UIColor.blue.cgColor
        shapeLayer2.strokeColor = UIColor.clear.cgColor
        shapeLayer2.lineWidth = 7
       // view.layer.addSublayer(shapeLayer2)*/
        
        shapeLayer3.path = UIBezierPath(roundedRect: CGRect(x: self.midViewX, y: self.midViewY, width: 80, height: 15), cornerRadius: 50).cgPath
        shapeLayer3.fillColor = UIColor.green.cgColor
        view.layer.addSublayer(shapeLayer3)

        let dragBall = UIPanGestureRecognizer(target: self, action:#selector(dragBall(recognizer:)))
        view.addGestureRecognizer(dragBall)

    }
    
  /*  @objc func dragBall(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self.view)
        let earthX = Double(point.x)
        let earthY = Double(point.y)
        let midViewXDouble = Double(midViewX)
        let midViewYDouble = Double(midViewY)
        let angleX = (earthX - midViewXDouble)
        let angleY = (earthY - midViewYDouble)
        //let angle = tan(angleY/angleX)
        let angle = atan2(angleY, angleX)
        let earthX2 = midViewXDouble + cos(angle)*100
        let earthY2 = midViewYDouble + sin(angle)*100
        circlePath2 = UIBezierPath(arcCenter: CGPoint(x: self.midViewX, y: self.midViewY), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
       // shapeLayer2.path = circlePath2.cgPath
        shapeLayer3.path = circlePath2.cgPath
    }*/
    
 /*   @objc func dragBall(recognizer: UIPanGestureRecognizer) {
      /*  let point = recognizer.location(in: self.view);
        let earthX = Double(point.x)
        let earthY = Double(point.y)
        let midViewXDouble = Double(midViewX)
        let midViewYDouble = Double(midViewY)
        let angleX = (earthX - midViewXDouble)
        let angleY = (earthY - midViewYDouble)
        //let angle = tan(angleY/angleX)
        let angle = atan2(angleY, angleX)
        let earthX2 = midViewXDouble + cos(angle)*100
        let earthY2 = midViewYDouble + sin(angle)*100
        circlePath2 = UIBezierPath(roundedRect: CGRect(x: self.midViewX, y: self.midViewY, width: 80, height: 15), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 16, height: 16))
        shapeLayer3.path = circlePath2.cgPath*/
        
        let tapLocation = recognizer.location(in: self.view)
        guard let view = recognizer.view else { return }
        let viewSize = min(view.bounds.size.width, view.bounds.size.height)
        let center = CGPoint(x: viewSize/2.0, y: viewSize/2.0)
        let distanceToCenter = sqrt(pow((tapLocation.x - center.x), 2) + pow((tapLocation.y - center.y), 2))
        let handRadianAngle = Double(Float.pi - atan2f((Float(tapLocation.x - center.x)),
                                                       (Float(tapLocation.y - center.y))))
        localTime.hour = Int(handRadianAngle * 6 / Double.pi)
        let hourDegree = Double(localTime.hour ?? 1) * 30.0 + Double(localTime.minute ?? 1) * 0.5
//        print("###hourDegree###",hourDegree)
        self.updateHandAngle1(angle: CGFloat(hourDegree * translateToRadian), duration: 0.5)
    }
    
    func updateHandAngle1(angle: CGFloat, duration: Double = 0.5) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveEaseInOut,
                       animations: { self.xyz!.transform = CGAffineTransform(rotationAngle: angle) },
                       completion: { (finished: Bool) in
                        return
        })
    }*/

    @objc func dragBall(recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: self.view);
        let earthX = Double(point.x)
        let earthY = Double(point.y)
        
        let midViewXDouble = Double(midViewX)
        let midViewYDouble = Double(midViewY)
        
        let angleX = (earthX - midViewXDouble)
        let angleY = (earthY - midViewYDouble)

        let angle = atan2(angleY, angleX)
        
        let earthX2 = midViewXDouble + cos(angle)*100
        let earthY2 = midViewYDouble + sin(angle)*100
        
        print("--earthX--", earthX)

//        print("earthX---midViewXDouble--angleX--earthX2", earthX, midViewXDouble, angleX, earthX2)
      //  print("earthY-----midViewYDouble----angleY-----earthY2", earthY, midViewYDouble, angleY, earthY2)

//        circlePath2 = UIBezierPath(roundedRect: CGRect(x: self.midViewX, y: self.midViewY, width: 80, height: 15), cornerRadius: 50).cgPath

//        circlePath2 = UIBezierPath()

        
        circlePath2 = UIBezierPath(arcCenter: CGPoint(x: earthX2,y: earthY2), radius: CGFloat(20), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
//        circlePath2 = UIBezierPath(roundedRect: CGRect(x: earthX2, y: earthY2, width: 80, height: 15), cornerRadius: 50)

        shapeLayer3.path = circlePath2.cgPath
    }

    
    
//    @objc func dragBall(recognizer: UIPanGestureRecognizer) {
//        let point = recognizer.location(in: self.view);
//        let earthX = Double(point.x)
//        let earthY = Double(point.y)
//        let midViewXDouble = Double(midViewX)
//        let midViewYDouble = Double(midViewY)
//        let angleX = (earthX - midViewXDouble)
//        let angleY = (earthY - midViewYDouble)
//        //let angle = tan(angleY/angleX)
//        let angle = atan2(angleY, angleX)
//        let earthX2 = midViewXDouble + cos(angle)*100
//        let earthY2 = midViewYDouble + sin(angle)*100
//        circlePath2 = UIBezierPath(arcCenter: CGPoint(x: earthX2,y: earthY2), radius: CGFloat(10), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
//        shapeLayer3.path = circlePath2.cgPath
//    }


}
