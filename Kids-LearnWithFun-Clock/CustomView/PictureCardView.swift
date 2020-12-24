//
//  PictureCardView.swift
//  Sharp Kido
//
//  Created by sheetal shinde on 13/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import FLAnimatedImage
import AVFoundation

@IBDesignable class PictureCardView: UIView {
    @IBOutlet weak var pictureCardView: UIView!
    @IBOutlet weak var bgPictureCardView: UIImageView!
    @IBOutlet var clocketView : Clocket!
    
    @IBOutlet weak var btnOption1 : ButtonCardOptionExt!
    @IBOutlet weak var btnOption2 : UIButton!
    @IBOutlet weak var btnOption3 : UIButton!
    @IBOutlet weak var btnOption4 : UIButton!
    
    var hour : Int = 12
    var minute : Int = 12
    
    var player = AVAudioPlayer()

    var nibName = "PictureCardView"

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
            pictureCardView = loadViewFromNib()
            pictureCardView.frame = bounds
            pictureCardView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
            addSubview(pictureCardView)
            bgPictureCardView.layer.cornerRadius = 30
            bgPictureCardView.layer.borderWidth = 1
            bgPictureCardView.layer.borderColor = CommanCode.Card_BUTTON_BORDER_COLOR.cgColor
           // setupOptions()
//            btnOption1.setTitle("10 Hour 12 Minute", for: .normal)
//            btnOption2.setTitle("1 Hour 15 Minute", for: .normal)
//            btnOption3.setTitle("7 Hour 30 Minute", for: .normal)
//            btnOption4.setTitle("9 Hour 46 Minute", for: .normal)
        }
        
        func loadViewFromNib() -> UIView {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: nibName, bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
            return view
        }
    
    // MARK: - User defined Functions
    
    func playSoundOnButtonClick(isTrue: Bool) {
        var url : URL?
        if isTrue {
            let path = Bundle.main.path(forResource: "WellDone", ofType : "mp3")!
            url = URL(fileURLWithPath : path)
        } else {
            let path = Bundle.main.path(forResource: "Wrong_Option_Clip", ofType : "mp3")!
            url = URL(fileURLWithPath : path)
        }
        do {
            player = try AVAudioPlayer(contentsOf: url!)
//            if !btnSound.currentBackgroundImage!.isEqual(UIImage(named: "Sound-Off.png")) {
                self.player.play()
//            }
        } catch {
            print ("There is an issue with this code!")
        }
    }
    @IBAction func funcBtnOption1(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "Red_Bubble"), for: .normal)
        sender.showsTouchWhenHighlighted = true
        playSoundOnButtonClick(isTrue: false)
    }
    @IBAction func funcBtnOption2(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "Red_Bubble"), for: .normal)
        sender.showsTouchWhenHighlighted = true
        playSoundOnButtonClick(isTrue: false)
    }
    @IBAction func funcBtnOption3(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "Green_Bubble"), for: .normal)
        sender.showsTouchWhenHighlighted = true
        sender.layer.borderColor = CommanCode.Correct_Option_Border_COLOR.cgColor
        playSoundOnButtonClick(isTrue: true)
    }
    @IBAction func funcBtnOption4(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        sender.setBackgroundImage(UIImage(named: "Red_Bubble"), for: .normal)
        playSoundOnButtonClick(isTrue: false)
    }
}

