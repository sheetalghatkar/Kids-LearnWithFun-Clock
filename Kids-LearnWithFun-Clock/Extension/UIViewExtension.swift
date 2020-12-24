//
//  UIViewExtension.swift
//  Kids-LearnWithFun
//
//  Created by sheetal shinde on 19/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class UIViewExtend: UIView {
    private var _round = false
    private var _borderColor = UIColor.clear
    private var _borderWidth: CGFloat = 0

    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }

    @IBInspectable var borderColor: UIColor {
        set {
            _borderColor = newValue
            setBorderColor()
        }
        get {
            return self._borderColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            _borderWidth = newValue
            setBorderWidth(value: _borderWidth)
        }
        get {
            return self._borderWidth
        }
    }

    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeRound()
        }
        get {
            return super.frame
        }
    }

    private func makeRound() {
        if self.round {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 4
        } else {
            self.layer.cornerRadius = 10
        }
    }

    private func setBorderColor() {
        self.layer.borderColor = self._borderColor.cgColor
    }
    
    
    @IBInspectable var cornerRadius: CGFloat {
        return self.cornerRadius
        
    }

    private func setBorderWidth(value: CGFloat) {
        self.layer.borderWidth =  value //self._borderWidth
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 1.0
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 0.5
            }, completion: nil)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: {
                self.alpha = 1.0
            }, completion: nil)
        }
    }
    
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
                self.layer.shadowRadius = 3.0
                self.layer.shadowOpacity = 1.0
                self.layer.shadowOffset = CGSize(width: 2, height: 2)
                self.layer.masksToBounds = false
               /* self.layer.shadowColor = UIColor.black.cgColor
                self.layer.shadowOpacity = 0.7
                self.layer.shadowOffset = CGSize.zero
                self.layer.shadowRadius = 4
                self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath*/

            }
        }

    
}
