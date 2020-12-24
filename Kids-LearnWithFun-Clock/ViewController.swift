//
//  ViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 09/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var imgViewGif: UIImageView!
    @IBOutlet weak var viewLearnClock: UIView!
    @IBOutlet weak var viewGuessClock: UIView!
    @IBOutlet weak var viewSetClock: UIView!
    @IBOutlet weak var viewPlayWithClock: UIView!
    @IBOutlet weak var viewTestClock: UIView!
    
    
    @IBOutlet weak var btnLearnClock: UIButton!
    @IBOutlet weak var btnGuessClock: UIButton!
    @IBOutlet weak var btnSetClock: UIButton!
    @IBOutlet weak var btnPlayWithClock: UIButton!
    @IBOutlet weak var btnTestClock: UIButton!
    
    var btnFontStyle = UIFont.systemFont(ofSize: 25, weight: .bold)
    let btnTitleColor = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUI()
    }
    func setUI() {
        self.view.backgroundColor = CommanCode.APP_BACKGROUND_COLOR
        self.imgViewGif.image  = UIImage.gifImageWithName("ClockLearn")
        self.viewLearnClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewGuessClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewSetClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewPlayWithClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        self.viewTestClock.backgroundColor = CommanCode.Tile_BACKGROUND_COLOR
        
        btnLearnClock.titleLabel?.font = btnFontStyle
        btnGuessClock.titleLabel?.font = btnFontStyle
        btnSetClock.titleLabel?.font = btnFontStyle
        btnPlayWithClock.titleLabel?.font = btnFontStyle
        btnTestClock.titleLabel?.font = btnFontStyle
        
        btnLearnClock.setTitleColor(btnTitleColor, for: .normal)
        btnGuessClock.setTitleColor(btnTitleColor, for: .normal)
        btnSetClock.setTitleColor(btnTitleColor, for: .normal)
        btnPlayWithClock.setTitleColor(btnTitleColor, for: .normal)
        btnTestClock.setTitleColor(btnTitleColor, for: .normal)
        
        
      /*  btnLearnClock.layer.shadowColor = UIColor.white.cgColor
        btnLearnClock.layer.shadowOffset = CGSize(width: 0, height: 3)
        btnLearnClock.layer.shadowOpacity = 1.0
        btnLearnClock.layer.shadowRadius = 30.0
        btnLearnClock.layer.masksToBounds = false*/
        


        
        btnLearnClock.setTitle(NSLocalizedString("Learn the Time", comment: ""), for: .normal)
        btnGuessClock.setTitle(NSLocalizedString("Guess the Time", comment: ""), for: .normal)
        btnSetClock.setTitle(NSLocalizedString("Set the Time", comment: ""), for: .normal)
        btnPlayWithClock.setTitle(NSLocalizedString("Play with Clock", comment: ""), for: .normal)
        btnTestClock.setTitle(NSLocalizedString("Test Your Learning", comment: ""), for: .normal)
        btnTestClock.alpha = 0.8
    }
    //IBAction Learn Time
    @IBAction func funcLearnTime(_ sender: UIButton) {
        let clockLearnVC = ShowClockViewController(nibName: "ShowClockViewController", bundle: nil)
          self.navigationController?.pushViewController(clockLearnVC, animated: true)
   }
    //IBAction Guess Time
    @IBAction func funcGuessTime(_ sender: UIButton) {
      /*  let guessVC = GuessTimeViewController(nibName: "GuessTimeViewController", bundle: nil)
        self.navigationController?.pushViewController(guessVC, animated: true)*/
        
        
       /* let pictureVC = PictureViewController(nibName: "PictureViewController", bundle: nil)
        self.navigationController?.pushViewController(pictureVC, animated: true)*/
        let pictureVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PictureViewController") as! PictureViewController
//        let setPictureVC = StoryboardsConstants.PicSoundViewStoryboard.getViewControllerInstance(identifier: "PictureViewController") as! PictureViewController
        self.navigationController?.pushViewController(pictureVC, animated: true)
    }
    //IBAction Set Time
    @IBAction func funcSetTime(_ sender: UIButton) {
    }
    //IBAction Match Time
    @IBAction func funcTestTime(_ sender: UIButton) {
    }
}

