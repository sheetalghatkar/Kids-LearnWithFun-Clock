//
//  UILabelExtension.swift
//  Kids-LearnWithFun3
//
//  Created by sheetal shinde on 25/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable class UILabelExtension: UILabel {

private var _shadowRadius: CGFloat = 0
private var _isShowShadow = false


    @IBInspectable var shadowRadius: CGFloat {
        set {
            _shadowRadius = newValue
            setShadowRadius(value: newValue)
        }
        get {
            return self._shadowRadius
        }
    }
    private func setShadowRadius(value: CGFloat) {
        self.layer.shadowRadius =  value //self._borderWidth
    }
    
    @IBInspectable var isShowShadow: Bool {
        set {
            _isShowShadow = newValue
            makeShodow()
        }
        get {
            return self._isShowShadow
        }
    }


    
    private func makeShodow() {
        if self.isShowShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.highlightedTextColor = UIColor.red
            self.layer.shadowRadius = 1.0
            self.layer.shadowOpacity = 1.0
            self.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.layer.masksToBounds = false
        }
    }

}
