//
//  PictureCardView.swift
//  Sharp Kido
//
//  Created by sheetal shinde on 13/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
//import FLAnimatedImage
import AVFoundation

protocol PictureCardViewProtocol : class {
    func addGestureToCard()
    func disableContainedCardView()
}

@IBDesignable class PictureCardView: UIView {
    @IBOutlet weak var pictureCardView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var bgPictureCardView: UIImageView!
    @IBOutlet var clocketView : GuessClocket!
    weak var delegatePictureCardProtocol : PictureCardViewProtocol?
    @IBOutlet weak var parentClockView: UIView!


    @IBOutlet weak var btnOption1 : ButtonCardOptionExt!
    @IBOutlet weak var btnOption2 : UIButton!
    @IBOutlet weak var btnOption3 : UIButton!
    @IBOutlet weak var btnOption4 : UIButton!
    var successIndex = 0 
    
    var hour : Int = 12
    var minute : Int = 12
    
    var player = AVAudioPlayer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
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
            bgPictureCardView.layer.borderColor = CommanCode.Current_Card_Border_COLOR.cgColor
           // setupOptions()
            parentClockView.layer.cornerRadius = (UIScreen.main.bounds.width * 0.50)/2
            
            btnOption1.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
            btnOption2.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
            btnOption3.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
            btnOption4.layer.borderColor = CommanCode.Clock_Dial_COLOR.cgColor
            
//            btnOption1.layer.borderWidth = 2.0
//            btnOption2.layer.borderWidth = 2.0
//            btnOption3.layer.borderWidth = 2.0
//            btnOption4.layer.borderWidth = 2.0
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
        if successIndex == 0 {
            successButton(getButtonInstance: sender, isSuccess: true)
        } else {
            successButton(getButtonInstance: sender, isSuccess: false)
        }
    }
    @IBAction func funcBtnOption2(_ sender: UIButton) {
        if successIndex == 1 {
            successButton(getButtonInstance: sender, isSuccess: true)
        } else {
            successButton(getButtonInstance: sender, isSuccess: false)
        }
//        let gifImageView = UIImageView()
//        gifImageView.frame.size  = CGSize(width: 300, height: 300)
//        gifImageView.center = sender.center
//        let crackerGif = UIImage.gifImageWithName("fireworks03")
//        gifImageView.image  = crackerGif
//        self.buttonView.addSubview(gifImageView)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
//            gifImageView.removeFromSuperview()
//        }
    }
    @IBAction func funcBtnOption3(_ sender: UIButton) {
        if successIndex == 2 {
            successButton(getButtonInstance: sender, isSuccess: true)
        } else {
            successButton(getButtonInstance: sender, isSuccess: false)
        }
    }
    @IBAction func funcBtnOption4(_ sender: UIButton) {
        if successIndex == 3 {
            successButton(getButtonInstance: sender, isSuccess: true)
        } else {
            successButton(getButtonInstance: sender, isSuccess: false)
        }
    }
    
    func successButton(getButtonInstance : UIButton, isSuccess: Bool) {
        if isSuccess {
            getButtonInstance.setBackgroundImage(UIImage(named: "Green_Bubble"), for: .normal)
            getButtonInstance.showsTouchWhenHighlighted = true
            getButtonInstance.layer.borderColor = CommanCode.Correct_Option_Border_COLOR.cgColor
            let gifImageView = UIImageView()
            gifImageView.frame.size  = CGSize(width: 300, height: 300)
            gifImageView.center = getButtonInstance.center
           /* let crackerGif = UIImage.gifImageWithName("GreenCracker")
            gifImageView.image  = crackerGif
            self.buttonView.addSubview(gifImageView)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                gifImageView.removeFromSuperview()
            }*/
            if appDelegate.IS_Sound_ON {
                playSoundOnButtonClick(isTrue: true)
            }
            
            self.delegatePictureCardProtocol?.disableContainedCardView()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                self.delegatePictureCardProtocol?.addGestureToCard()
            }
        } else {
            getButtonInstance.showsTouchWhenHighlighted = true
            getButtonInstance.layer.borderColor = UIColor.red.cgColor
            getButtonInstance.setBackgroundImage(UIImage(named: "Red_Bubble"), for: .normal)
            if appDelegate.IS_Sound_ON {
                playSoundOnButtonClick(isTrue: false)
            }
        }
    }
}
