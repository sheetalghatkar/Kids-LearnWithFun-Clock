//
//  GuessTimeCardView.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 11/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import FLAnimatedImage

class GuessTimeCardView: UIView {
        @IBOutlet weak var pictureImageView: FLAnimatedImageView!
        @IBOutlet var guessTimeCardView: UIView!
        @IBOutlet var parentCardView: UIView!
        var nibName = "GuessTimeCardView"
        var cardWidth = GetScreenSize.screenSize.width * 0.90
        var cardHeight = GetScreenSize.screenSize.height * 0.6
    override func awakeFromNib()
    {
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(("handleTap1:"))))
    }

    func handleTap1(gestureRecognizer: UITapGestureRecognizer)
    {
        print("Here")
    }


            override init(frame: CGRect) {
                // properties
                super.init(frame: frame)
                
                // Set anything that uses the view or visible bounds
                setup()
            }
            
            required init?(coder aDecoder: NSCoder) {
                // properties
                super.init(coder: aDecoder)
                
                // Setup
                setup()
            }
            
            override func layoutIfNeeded() {
                self.superview?.layoutIfNeeded()
            }
          
            func setup() {
                guessTimeCardView = loadViewFromNib()
               // guessTimeCardView.frame = bounds
//                guessTimeCardView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//                guessTimeCardView.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
                guessTimeCardView.isUserInteractionEnabled = true
                //self.backgroundColor = UIColor.green
                guessTimeCardView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
                addSubview(guessTimeCardView)
                
                
//                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//
//                parentCardView.addGestureRecognizer(tap)
//
               // parentCardView.isUserInteractionEnabled = true


                // function which is triggered when handleTap is called

        //        self.layer.cornerRadius = 20
        //        guessTimeCardView.layer.cornerRadius = 20
//                pictureImageView.layer.cornerRadius = 30
//                pictureImageView.layer.borderWidth = 1
//                pictureImageView.layer.borderColor = UIColor.white.cgColor
               // setupOptions()
                let EEEE = UIView(frame: CGRect(x: 0, y: 400, width: 100, height: 100))

                let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
                EEEE.backgroundColor = UIColor.yellow
                self.addGestureRecognizer(tap)

                EEEE.isUserInteractionEnabled = true

                //self.addSubview(EEEE)

            }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
     }

            func loadViewFromNib() -> UIView {
                
                let bundle = Bundle(for: type(of: self))
                let nib = UINib(nibName: nibName, bundle: bundle)
                let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
                
                return view
            }

    }
