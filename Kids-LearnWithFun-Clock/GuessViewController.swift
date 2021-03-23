//
//  GuessViewController.swift
//  Sharp Kido
//
//  Created by sheetal shinde on 13/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

extension UILabel {
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.8, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.0 })
    }
}

class GuessViewController: UIViewController, PictureCardViewProtocol {
    var pictureCardWidth = UIScreen.main.bounds.width * 0.9
    var pictureCardHeight : CGFloat = 0.0
    var startYCard : CGFloat = 0.0
    var startXCard : CGFloat = 0.0
    var APIRequestIndex = 20 //This number will decide when to give call for next page i.e how much cards are there in deck when we are calling API for next page
    var originalXVal : CGFloat  = 0.0
    var originalYVal : CGFloat = 0.0
    var centerOfParentContainer = CGPoint(x: 0.0, y: 0.0)
    var point = CGPoint(x: 0.0, y: 0.0)
    var newCard : PictureCardView?
    var cards = [PictureCardView]()
    let cardInteritemSpacing: CGFloat = 20
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    var cardIsHiding = false
    var divisor : CGFloat = 0
    var rotation : CGFloat = 0.0
    var previousRotation : CGFloat =  0.0 //To increment percent of alpha for cross and check button on discovery card
   // @IBOutlet weak var lblPictureName: UILabel!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet var gifImageview : UIImageView!
    var birdImageArray: [UIImage] = [
        UIImage(named: "Pigeon.png")!,
        UIImage(named: "Owl.png")!,
        UIImage(named: "Kingfisher.png")!,
        UIImage(named: "Peacock.png")!,
        UIImage(named: "Sparrow.png")!,
        UIImage(named: "Crow.png")!,
        UIImage(named: "Ostrich.png")!,
        UIImage(named: "Cuckoo.png")!,
        UIImage(named: "Hen.png")!
    ]
    var birdNameArray: [String] = ["Pigeon",
        "Owl","Kingfisher","Peacock","Sparrow","Crow","Ostrich","Cuckoo","Hen"]

    @IBOutlet weak var bgScreen: UIImageView!
    @IBOutlet weak var picViewcontainer: UIView!
    @IBOutlet weak var btnSound: UIButton!
    var player = AVAudioPlayer()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNoAds: UIButton!
    @IBOutlet weak var imgViewLoader: UIImageView!
    @IBOutlet weak var viewTransperent: UIView!
    @IBOutlet weak var trailingTitlelable: NSLayoutConstraint!
    var paymentDetailVC : PaymentDetailViewController?
    let defaults = UserDefaults.standard
    var interstitial: GADInterstitial?
    var bannerView: GADBannerView!

    var timer: Timer?
    var clickCount = 0
    var checkCurrentindex = 0
    var fromHomeClick = false
    var currentindex = 0
    var fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 30)

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Guess Time"
        lblTitle.textColor = UIColor.white   //CommanCode.paymentBtnTextColor
        lblTitle.layer.shadowColor = UIColor.black.cgColor
        lblTitle.layer.shadowRadius = 1.0
        lblTitle.layer.shadowOpacity = 1.0
        lblTitle.layer.shadowOffset = CGSize(width: 2, height: 2)
        lblTitle.layer.masksToBounds = false
        
        if UIScreen.main.bounds.height < 750 {
            fontLblTime = UIFont(name: "ChalkboardSE-Bold", size: 27)
        }

        lblTitle.font = fontLblTime

        let loaderGif = UIImage.gifImageWithName("Loading")
        imgViewLoader.image = loaderGif
        imgViewLoader.backgroundColor = UIColor.white
        imgViewLoader.layer.borderWidth = 1
        imgViewLoader.layer.borderColor =
            CommanCode.paymentBtnTextColor.cgColor

        
      //  print("!!!!minuteCalculationArray",CommanCode.minuteCalculationArray.count)

       /* print("!!!!minuteAngleArray",CommanCode.minuteAngleArray.count)
        print("!!!!minuteCalculationArray",CommanCode.minuteCalculationArray.count)
        print("!!!!hourAngleArray",CommanCode.hourAngleArray.count)
        print("!!!!hourCalculationArray",CommanCode.hourCalculationArray.count)*/

        // Do any additional setup after loading the view.
//        self.pictureCardWidth = UIScreen.main.bounds.width * 0.8

//        if UIScreen.main.bounds.height <= 667 {
//            self.pictureCardWidth = UIScreen.main.bounds.width * 0.78
//        }
//        if UIScreen.main.bounds.height == 736 {
//            self.pictureCardWidth = UIScreen.main.bounds.width * 0.83
//        }
        self.view.backgroundColor = CommanCode.APP_BACKGROUND_COLOR
        self.pictureCardHeight = self.pictureCardWidth + 50.0  //* 1.3
//        let jeremyGif = UIImage.gifImageWithName("Jungle")
//        self.bgScreen.image  = jeremyGif
        
        //DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
//            self.layoutCards()
        //})
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
        }
        if !defaults.bool(forKey:"IsPrimeUser") {
            self.trailingTitlelable.constant = 90
        } else {
            self.trailingTitlelable.constant = 40
        }

        if !(defaults.bool(forKey:"IsPrimeUser")) {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            addBannerViewToView(bannerView)
            bannerView.adUnitID = CommanCode.Banner_AdUnitId
            bannerView.rootViewController = self
            bannerView.delegate = self
            if Reachability.isConnectedToNetwork() {
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
            } else {
                let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    if self.timer == nil {
                        self.timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.layoutCards()
        if defaults.bool(forKey:"IsPrimeUser") {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = true
                if bannerView != nil {
                    bannerView.removeFromSuperview()
                }
            }
            if let _ = trailingTitlelable {
                self.trailingTitlelable.constant = 40
            }
        } else {
            if let _ = btnNoAds {
                self.btnNoAds.isHidden = false
            }
            if let _ = trailingTitlelable {
                self.trailingTitlelable.constant = 90
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if !defaults.bool(forKey:"IsPrimeUser") {
            if bannerView != nil {
                if timer == nil {
                    if Reachability.isConnectedToNetwork() {
                        DispatchQueue.main.async {
                            self.bannerView.load(GADRequest())
                        }
                    } else {
                        let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                            if self.timer == nil {
                                self.timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func getYMarginForCard() -> CGFloat {
        return 0.0

        
        if GetScreenSize.screenSize.height <= 667  || GetScreenSize.screenSize.height == 736 {
            return 15.0
        } else {
            return 0.0
        }
        

       /* else if UIScreen.main.bounds.height == 736 {
            return 10.0
        }
        else if UIScreen.main.bounds.height >= 812 {
            return view.frame.height * 0.04
        }
        else {
            return view.frame.height * 0.04
        }*/
    }

    func layoutCards() {
        let arrayArryAllIndexCount = Array(0 ..< CommanCode.guessTimeArray.count)
        for iCount in 0 ..< CommanCode.guessTimeArray.count {//Done
            var selectedArrayOfIndexs = [iCount]
            repeat {
                let max = arrayArryAllIndexCount.count
                let random = Int.random(in: 0 ..< max)
                if !selectedArrayOfIndexs.contains(random) {
                    selectedArrayOfIndexs.append(random)
                    //print("#####Random",random)
                }
            } while selectedArrayOfIndexs.count < 4
            //print("___________________________________________")
            let card = PictureCardView(frame: CGRect(x: 0, y: 0, width: self.pictureCardWidth, height : self.pictureCardHeight))
            card.clocketView.setLocalTime(hour: CommanCode.guessTimeArray[iCount][0], minute: CommanCode.guessTimeArray[iCount][1], second: 1)
            card.successIndex = CommanCode.guessTimeArray[iCount][2]
            card.delegatePictureCardProtocol = self
            if CommanCode.guessTimeArray[iCount][2] == 0 {
                
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) == 0 {
                    card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock ", for: .normal)
                } else {
                card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) == 0 {
                    card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock ", for: .normal)
                } else {
                    card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) == 0 {
                    card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) + " Minute ", for: .normal)
                }
                
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) == 0 {
                    card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) + " Minute ", for: .normal)
                }
            } else if CommanCode.guessTimeArray[iCount][2] == 1 {
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) == 0 {
                    card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) == 0 {
                    card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock ", for: .normal)
                } else {
                    card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) == 0 {
                    card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) == 0 {
                    card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock ", for: .normal)
                } else {
                    card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) + " Minute ", for: .normal)
                }
            } else if CommanCode.guessTimeArray[iCount][2] == 2 {
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) == 0 {
                    card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) == 0 {
                    card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock ", for: .normal)
                } else {


                card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) == 0 {
                    card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) == 0 {
                    card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) + " Minute ", for: .normal)
                }
            } else if CommanCode.guessTimeArray[iCount][2] == 3 {
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) == 0 {
                    card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption4.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[0]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) == 0 {
                    card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption1.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[1]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) == 0 {
                    card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption2.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[2]][1]) + " Minute ", for: .normal)
                }
                if (CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) == 0 {
                    card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock ", for: .normal)
                } else {

                card.btnOption3.setTitle(String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][0]) + " O'Clock " + String(CommanCode.guessTimeArray[selectedArrayOfIndexs[3]][1]) + " Minute ", for: .normal)
                }
            }

            card.layer.shadowColor = UIColor(red:32/255, green:32/255, blue:32/255, alpha:1.00).cgColor
            card.layer.shadowOffset = CGSize(width: 2, height: 5)
            card.layer.shadowOpacity = 0.8
            card.layer.shadowRadius = 6.0
            card.clocketView.isUserInteractionEnabled = false
            self.cards.append(card)
        }

       // print("Inside layoutCards**********", self.picViewcontainer.frame.height / 2)
        // frontmost card (first card of the deck)
        let firstCard = cards[0]
        self.picViewcontainer.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center.x = CommanCode.SCREEN_WIDTH / 2
        firstCard.center.y = GetScreenSize.screenSize.height / 2
            //self.picViewcontainer.frame.height / 2  + getYMarginForCard()
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        
        firstCard.layer.borderColor = CommanCode.Current_Card_Border_COLOR.cgColor
        firstCard.layer.cornerRadius = 30
        firstCard.layer.borderWidth = 2.0

        originalXVal = cards[0].center.x
        originalYVal = cards[0].center.y

        // the next 3 cards in the deck
        for i in 1...2 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            card.layer.zPosition = CGFloat(cards.count - i)
            // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 4 cards visible to the user
            let downscale = cardAttributes[i].downscale
            // let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = 1
            card.layer.borderColor = CommanCode.Current_Card_Border_COLOR.cgColor
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = CommanCode.SCREEN_WIDTH / 2
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            // workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 2 {
                card.frame.origin.y += 1.5   
            }
            self.picViewcontainer.addSubview(card)
        }
        // make sure that the first card in the deck is at the front
        self.picViewcontainer.bringSubviewToFront(cards[0])
        
        
    }
    
    func removeOldFrontCard() {
       // print("Inside  removeOldFrontCard")
        if cards.indexExists(0) {
            cards[0].removeFromSuperview()
            cards.remove(at: 0)
            
            if cards.count == 0 {
                layoutCards()
            }
        }
    }

    
        @objc func handleCardPan(sender: UIPanGestureRecognizer) {
            var tag = sender.view?.tag
           // print("handleCardPan########", tag)

            // if we're in the process of hiding a card, don't let the user interace with the cards yet
            if cardIsHiding { return }
            // change this to your discretion - it represents how far the user must pan up or down to change the option
    //        let optionLength: CGFloat = 60
            // distance user must pan right or left to trigger an option
    //        let requiredOffsetFromCenter: CGFloat = 15
         //   autoRefreshListTimer?.invalidate()
    //        let panLocationInView = sender.location(in: view)
            point = sender.translation(in: self.picViewcontainer)
            centerOfParentContainer = CGPoint(x: self.view.frame.width / 2, y: ((self.view.frame.height / 2) + getYMarginForCard()))
            //print("------originalXVal----------", originalXVal)

            divisor = ((self.view.frame.width / 2) / 0.61)

            if cards.count > 0 {
                cards[0].center = CGPoint(x: centerOfParentContainer.x + point.x, y: centerOfParentContainer.y + point.y)
                let distanceFromCenter = ((self.view.frame.width / 2) - cards[0].center.x)

                let panLocationInCard = sender.location(in: cards[0])
                switch sender.state {
                case .began:
                   // print("Inside began")
                    rotation = 0.0
                    previousRotation = 0.0
                case .changed:
                      print("------changed----")
//                    if cards.count > 0 {
//                        rotation = tan(point.x / (self.cards[0].frame.width * 2.0))
//                        cards[0].transform = CGAffineTransform(rotationAngle: rotation)
//                        print("------rotation---",rotation)
//        //                print("------point.x---",point.x)
//                        // Down swipe and refresh
//                        if point.y > 0 {
//                            if point.y > 30.0 && (point.x > -30.0 && point.x < 30.0) {
//                                if !(cards[0].imgViewRefresh.alpha >= 1.0) {
//                                    cards[0].setAlpha(option: .refresh, value: cards[0].imgViewRefresh.alpha + 0.02)
//                                } else if (cards[0].imgViewRefresh.alpha > 0.0) {
//                                    cards[0].setAlpha(option: .refresh, value: cards[0].imgViewRefresh.alpha - 0.02)
//                                }
//                                cards[0].setAlpha(option: .decideLater)
//                            } else {
//                                cards[0].setAlpha(option: .decideLater)
//                                cards[0].setAlpha(option: .refresh)
//                            }
//                        }
//                        // Up Swipe and ignore
//                        else {
//                            if point.y < -30.0 && (point.x > -30.0 && point.x < 30.0) {
//                                if !(cards[0].imgViewDecideLater.alpha >= 1.0) {
//                                    cards[0].setAlpha(option: .decideLater, value: cards[0].imgViewDecideLater.alpha + 0.02)
//                                } else if (cards[0].imgViewDecideLater.alpha > 0.0) {
//                                    cards[0].setAlpha(option: .decideLater, value: cards[0].imgViewDecideLater.alpha - 0.02)
//                                }
//                                cards[0].setAlpha(option: .refresh)
//                            } else {
//                                cards[0].setAlpha(option: .decideLater)
//                                cards[0].setAlpha(option: .refresh)
//                            }
//                        }
//                        //Right swipe and send request
//                        if point.x > 0 {
//                            if point.x > 30.0 && !(cards[0].center.y < originalYVal - 100.0) {
//                                if !(cards[0].imgViewConnect.alpha >= 1.0) && (rotation > previousRotation) {
//                                    cards[0].setAlpha(option: .connect, value: cards[0].imgViewConnect.alpha + 0.02)
//                                } else if (rotation < previousRotation) && (cards[0].imgViewConnect.alpha > 0.0){
//                                    cards[0].setAlpha(option: .connect, value: cards[0].imgViewConnect.alpha - 0.02)
//                                }
//                                cards[0].setAlpha(option: .remove)
//                            } else {
//                                cards[0].setAlpha(option: .connect)
//                                cards[0].setAlpha(option: .remove)
//                            }
//                        }
//                        //Left swipe and delete request
//                        else {
//                            if point.x < -30.0 && !(cards[0].center.y < originalYVal - 100.0) {
//                                if !(cards[0].imgViewRemove.alpha >= 1.0) && (rotation < previousRotation) {
//                                    cards[0].setAlpha(option: .remove, value: cards[0].imgViewRemove.alpha + 0.02)
//                                } else if (rotation > previousRotation) && (cards[0].imgViewRemove.alpha > 0.0){
//                                    cards[0].setAlpha(option: .remove, value: cards[0].imgViewRemove.alpha - 0.02)
//                                }
//                                cards[0].setAlpha(option: .connect)
//                            } else {
//                                cards[0].setAlpha(option: .connect)
//                                cards[0].setAlpha(option: .remove)
//                            }
//                        }
//                        previousRotation = rotation
//                    }
                case .ended:
                    if cards.count > 0 {
                      //  print("------ended----",cards[0])
                    } else {
                       // print("------ended-fail-------")
                    }
                    //------------------------------------------------------------
                                  if (cards[0].center.y < originalYVal - 100.0)||((cards[0].center.x) > (originalXVal + 100.0))||(cards[0].center.x < originalXVal - 100.0) {
                                   // print("Left")
                                    UIView.animate(withDuration: 0.2) {
                                        self.cards[0].center = CGPoint(x: self.centerOfParentContainer.x + self.point.x + 200, y: self.centerOfParentContainer.y + self.point.y + 75)
                                        self.cards[0].alpha = 0
                                        self.showNextCard()
                                        self.hideFrontCard()
                                        
                                      /*  if self.cards.count == 1 {
                                            self.lblPictureName.text = ""
                                        } else {
                                            self.lblPictureName.text =  self.birdNameArray[self.birdNameArray.count - self.cards.count+1]
                                        }*/

//                                        if tag! == (self.birdImageArray.count - 1) {
//                                            self.lblPictureName.text = ""
//                                        } else {
//                                            self.lblPictureName.text = self.birdNameArray[tag! + 1]
//                                        }
//                                        self.lblPictureName.blink()
                                    }
                                } else {
                                    //print("Nothing happens")
                                    UIView.animate(withDuration: 0.2) {
                                        self.cards[0].transform = .identity
//                                        self.cards[0].center = CGPoint(x: self.picViewcontainer.frame.width / 2, y: (self.picViewcontainer.frame.height / 2) + self.cardInteritemSpacing*4) //self.getYMarginForCard())
                                        
                                        self.cards[0].center.x = self.picViewcontainer.center.x
                                        self.cards[0].center.y = GetScreenSize.screenSize.height / 2

                                    }
                                }
                //--------------------------------------------------------------------
                default:
                    break
                }
            }
        }
    func hideFrontCard() {
           // print("Inside  hideFrontCard")
            if #available(iOS 10.0, *) {
                var cardRemoveTimer: Timer? = nil
                cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                  //  print("Inside  cardRemoveTimer")
                    guard self != nil else {
                      //  print("Inside  hideFrontCard nil")
                        return }
                   // print("Inside  self  delegate", self)

    //                if (!(self!.view.bounds.contains(self!.cards[0].center))) || AppManager.shared.isDetailCardProcessed {
                       // print("Inside  hideFrontCard if")
                        cardRemoveTimer!.invalidate()
                        self?.cardIsHiding = true
                        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                            self?.cards[0].alpha = 0.0
                           // print("Inside  hideFrontCard view 1")
                        }, completion: { (_) in
                           // print("Inside  hideFrontCard view 2")
                            self?.removeOldFrontCard()
                            self?.cardIsHiding = false
                        })
                })
            } else {
                // fallback for earlier versions
               // print("fallback for earlier versions")
                UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                   // print("Inside  hideFrontCard view 0")
                    self.cards[0].alpha = 0.0
                }, completion: { (_) in
                   // print("Inside  hideFrontCard view 5")

                    self.removeOldFrontCard()
                })
            }
        }
    
    func showNextCard() {
        if !(defaults.bool(forKey:"IsPrimeUser")) {
            clickCount = clickCount + 1
           // print("!!!!!!!!!!!!clickCount",clickCount)
            if clickCount >= 10 {
                clickCount = 0
                callInterstitialOn10Tap()
            }
        }
        let animationDuration: TimeInterval = 0.3
        // 1. animate each card to move forward one by one
        for i in 1...2 {
          //  print("********2001***********")
            if i > (cards.count - 1) {
              //  print("********2002*********** Count",i)
                continue
            }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            //let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = 1
                if i == 1 {
                   // print("********2003***********",card.lblName.text)
                    card.center = self.picViewcontainer.center
                    card.center.y = GetScreenSize.screenSize.height / 2
                        //self.picViewcontainer.frame.height/2 + self.getYMarginForCard()
                    card.layer.borderColor = CommanCode.Current_Card_Border_COLOR.cgColor
                    card.layer.cornerRadius = 30
                    card.layer.borderWidth = 2.0
                } else {
                  //  print("********2004***********",card.lblName.text)
                    card.center.x = self.picViewcontainer.center.x
                    card.center.y = self.picViewcontainer.frame.height/2 + self.getYMarginForCard()
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                   // print("********2005***********",card.lblName.text)
                    card.isUserInteractionEnabled = true
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
        }
        
        // 2. add a new card (now the 3th card in the deck) to the very back
        if 3 > (cards.count - 1) {
            if cards.count != 1 {
                self.picViewcontainer.bringSubviewToFront(cards[1])
            }
            return
        }
        newCard = cards[3]
        newCard?.layer.zPosition = CGFloat(cards.count - 3)
        let downscale = cardAttributes[3].downscale
        
        // initial state of new card
        newCard?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard?.alpha = 0
        newCard?.center.x = self.picViewcontainer.center.x
        newCard?.center.y = self.picViewcontainer.frame.height/2 + getYMarginForCard()
        newCard?.frame.origin.y = cards[1].frame.origin.y - (3 * cardInteritemSpacing)
        self.picViewcontainer.addSubview(newCard!)
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.newCard?.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            self.newCard?.alpha = 1
            self.newCard?.center.x = self.picViewcontainer.center.x
            self.newCard?.center.y = self.picViewcontainer.frame.height/2 + self.getYMarginForCard()
            self.newCard?.frame.origin.y = self.cards[1].frame.origin.y - (2 * self.cardInteritemSpacing) + 1.5
        }, completion: { (_) in
            
        })
        // first card needs to be in the front for proper interactivity
        self.picViewcontainer.bringSubviewToFront(self.cards[1])
        picViewcontainer.isUserInteractionEnabled = true
    }
    
   @IBAction func funcBackToHome(_ sender: UIButton) {
        stopTimer()
         fromHomeClick = true
         if defaults.bool(forKey:"IsPrimeUser") {
             navigationController?.popViewController(animated: true)
         } else {
             self.viewTransperent.isHidden = false
             self.imgViewLoader.isHidden = false
             if Reachability.isConnectedToNetwork() {
                 DispatchQueue.main.async {
                     self.interstitial = self.createAndLoadInterstitial()
                 }
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                     if !self.viewTransperent.isHidden {
                         self.viewTransperent.isHidden = true
                         self.imgViewLoader.isHidden = true
                         self.navigationController?.popViewController(animated: true)
                     }
                 }
             } else {
                 DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                     self.funcHideLoader()
                     let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                         self.navigationController?.popViewController(animated: true)
                     }))
                     self.present(alert, animated: true, completion: nil)
                 })
             }
         }
     }
    
    // MARK: - User defined Functions
    
    @IBAction func funcSound_ON_OFF(_ sender: Any) {
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.imgSoundOff, for: .normal)
            player.stop()
        } else {
            btnSound.setBackgroundImage(CommanCode.imgSoundOn, for: .normal)
        }
        appDelegate.IS_Sound_ON = !appDelegate.IS_Sound_ON
    }
    
    
    // MARK: - Protocol Method Implementation

    func addGestureToCard() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.cards[0].alpha = 0
        }
        UIView.transition(with: self.cards[0], duration: 2, options: .transitionCurlUp, animations: nil, completion: { (_) in
            self.cards[0].alpha = 0
            self.showNextCard()
            self.hideFrontCard()
        })
    }
    func disableContainedCardView() {
        picViewcontainer.isUserInteractionEnabled = false
    }

}

extension GuessViewController {
    @objc func alarmToLoadBannerAds(){
       // print("Inside alarmToLoadBannerAds")
        if Reachability.isConnectedToNetwork() {
            if bannerView != nil {
             //   print("Inside Load bannerView")
                DispatchQueue.main.async {
                    self.bannerView.load(GADRequest())
                }
            }
        }
    }
    func callInterstitialOn10Tap(){
        self.viewTransperent.isHidden = false
        self.imgViewLoader.isHidden = false
        if Reachability.isConnectedToNetwork() {
            DispatchQueue.main.async {
                self.interstitial = self.createAndLoadInterstitial()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                if !self.viewTransperent.isHidden {
                    self.viewTransperent.isHidden = true
                    self.imgViewLoader.isHidden = true
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                self.funcHideLoader()
                let alert = UIAlertController(title: "", message: "No Internet Connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                }))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    private func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: CommanCode.Interstitial_AdUnitId)

        guard let interstitial = interstitial else {
            return nil
        }

        let request = GADRequest()
        // Remove the following line before you upload the app
        interstitial.load(request)
        interstitial.delegate = self

        return interstitial
    }

    func stopTimer() {
        //print("Inside stopTimer")
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}


extension GuessViewController: GADBannerViewDelegate {
    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
          // In iOS 11, we need to constrain the view to the safe area.
          positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
          // In lower iOS versions, safe area is not available so we use
          // bottom layout guide and view edges.
          positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
     }

    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
      // Position the banner. Stick it to the bottom of the Safe Area.
      // Make it constrained to the edges of the safe area.
      let guide = view.safeAreaLayoutGuide
      NSLayoutConstraint.activate([
        guide.leftAnchor.constraint(equalTo: bannerView.leftAnchor),
        guide.rightAnchor.constraint(equalTo: bannerView.rightAnchor),
        guide.bottomAnchor.constraint(equalTo: bannerView.bottomAnchor)
      ])
    }

    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .leading,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .leading,
                                            multiplier: 1,
                                            constant: 0))
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .trailing,
                                            relatedBy: .equal,
                                            toItem: view,
                                            attribute: .trailing,
                                            multiplier: 1,
                                            constant: 0))
      view.addConstraint(NSLayoutConstraint(item: bannerView,
                                            attribute: .bottom,
                                            relatedBy: .equal,
                                            toItem: bottomLayoutGuide,
                                            attribute: .top,
                                            multiplier: 1,
                                            constant: 0))
    }

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      //print("adViewDidReceiveAd")
        if let visibleViewCtrl = UIApplication.shared.keyWindow?.visibleViewController {
            if(visibleViewCtrl.isKind(of: GuessViewController.self)){
                if timer == nil {
                   // print("adViewDidReceiveAd Success")
                    timer = Timer.scheduledTimer(timeInterval: CommanCode.timerForAds, target: self, selector: #selector(self.alarmToLoadBannerAds), userInfo: nil, repeats: true)
                }
            }
        }
    }
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
        didFailToReceiveAdWithError error: GADRequestError) {
      //print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
     // print("adViewWillPresentScreen")
    }

    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
     // print("adViewWillDismissScreen")
    }

    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
     // print("adViewDidDismissScreen")
    }

    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
      //print("adViewWillLeaveApplication")
    }
}
extension GuessViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        //print("Interstitial loaded successfully")
        funcHideLoader()
        ad.present(fromRootViewController: self)
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
    }

    func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        funcHideLoader()
        //print("Fail to receive interstitial")
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        funcHideLoader()
        if fromHomeClick {
            navigationController?.popViewController(animated: true)
        }
       // print("dismiss interstitial")
    }
}
extension GuessViewController : PayementForParentProtocol {
    @IBAction func funcNoAds(_ sender: Any) {
        showPaymentScreen()
    }
    
    //Delegate method implementation
    func showPaymentCostScreen() {
        paymentDetailVC?.view.removeFromSuperview()
        let PaymentCostVC = PaymentCostController(nibName: "PaymentCostController", bundle: nil)
        self.navigationController?.pushViewController(PaymentCostVC, animated: true)
    }
    func showSubscriptionDetailScreen() {
        
    }
    func showPaymentScreen(){
        paymentDetailVC = PaymentDetailViewController(nibName: "PaymentDetailViewController", bundle: nil)
        paymentDetailVC?.view.frame = self.view.bounds
        paymentDetailVC?.delegatePayementForParent = self
        self.view.addSubview(paymentDetailVC?.view ?? UIView())
    }
    
    func appstoreRateAndReview() {
    }
    
    func shareApp() {
        
    }
    func funcHideLoader() {
        self.viewTransperent.isHidden = true
        self.imgViewLoader.isHidden = true
    }
}
