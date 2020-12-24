//
//  UIButtonExtension.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 16/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit

class ButtonCardOptionExt: UIButton {
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    func setupView() {
        //self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 1
        self.layer.borderColor = CommanCode.Card_BUTTON_BORDER_COLOR.cgColor
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
       // self.clipsToBounds = false
        self.layer.masksToBounds = true

        self.setTitleColor(UIColor.black, for: .normal)
        
     /* self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
      self.layer.shadowOffset = CGSize(width: 0, height: 3)
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 10.0
      self.layer.masksToBounds = true*/
        
       /* self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 30.0
        self.layer.masksToBounds = true*/

    }
    
//    private var shadowLayer: CAShapeLayer!

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
//            shadowLayer.fillColor = UIColor.white.cgColor
//
//            shadowLayer.shadowColor = UIColor.darkGray.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 2.0, height: 2.0)
//            shadowLayer.shadowOpacity = 0.8
//            shadowLayer.shadowRadius = 2
//
//            layer.insertSublayer(shadowLayer, at: 0)
//            //layer.insertSublayer(shadowLayer, below: nil) // also works
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
}
class ButtonHomeMenuExt: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView() {
        titleLabel!.layer.shadowColor = UIColor.black.cgColor
        titleLabel!.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        titleLabel!.layer.shadowOpacity = 2.0
        titleLabel!.layer.shadowRadius = 1
        titleLabel!.layer.masksToBounds = false
    }
}
