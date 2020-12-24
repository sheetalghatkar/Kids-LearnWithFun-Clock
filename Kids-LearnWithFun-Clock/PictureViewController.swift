//
//  PictureViewController.swift
//  Sharp Kido
//
//  Created by sheetal shinde on 13/06/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit
import FLAnimatedImage
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

class PictureViewController: UIViewController {
//    @IBOutlet var picCardView: PictureCardView!
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


    override func viewDidLoad() {
        super.viewDidLoad()
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
            self.layoutCards()
        //})
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.SOUND_OFF_IMG, for: .normal)
        } else {
            btnSound.setBackgroundImage(CommanCode.SOUND_ON_IMG, for: .normal)
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
        
        var arrayArryAllIndexCount = Array(0...CommanCode.guessTimeArray.count)
        var arrayModifiyIndexCount = arrayArryAllIndexCount

        for iCount in 0 ..< CommanCode.guessTimeArray.count {//Done
//            arrayModifiyIndexCount.remove(at: iCount)
            var selectedArrayOfIndexs = [iCount]
           // for _ in arr
            
            var max = arrayModifiyIndexCount.count
            var random = Int.random(in: 0 ..< max)
            
         //   selectedArrayOfIndexs.append(<#T##newElement: Int##Int#>)
            print("Get Random:",random)
            let card = PictureCardView(frame: CGRect(x: 0, y: 0, width: self.pictureCardWidth, height : self.pictureCardHeight))
            card.clocketView.setLocalTime(hour: CommanCode.guessTimeArray[iCount][0], minute: CommanCode.guessTimeArray[iCount][1], second: 1)
            card.layer.shadowColor = UIColor(red:32/255, green:32/255, blue:32/255, alpha:1.00).cgColor
            card.layer.shadowOffset = CGSize(width: 2, height: 5)
            card.layer.shadowOpacity = 0.8
            card.layer.shadowRadius = 6.0
            card.clocketView.isUserInteractionEnabled = false
            self.cards.append(card)
        }

        print("Inside layoutCards**********", self.picViewcontainer.frame.height / 2)
        // frontmost card (first card of the deck)
        let firstCard = cards[0]
        self.picViewcontainer.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center.x = self.picViewcontainer.center.x
        firstCard.center.y = GetScreenSize.screenSize.height / 2
            //self.picViewcontainer.frame.height / 2  + getYMarginForCard()
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
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
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.picViewcontainer.center.x
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
        print("Inside  removeOldFrontCard")
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
            print("handleCardPan########", tag)

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
                    print("Inside began")
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
                        print("------ended-fail-------")
                    }
                    //------------------------------------------------------------
                                  if (cards[0].center.y < originalYVal - 100.0)||((cards[0].center.x) > (originalXVal + 100.0))||(cards[0].center.x < originalXVal - 100.0) {
                                    print("Left")
                                    UIView.animate(withDuration: 0.2) {
                                        self.cards[0].center = CGPoint(x: self.centerOfParentContainer.x + self.point.x + 200, y: self.centerOfParentContainer.y + self.point.y + 75)
                                        self.cards[0].alpha = 0
                                        self.showNextCard()
                                        self.hideFrontCard()
                                        
                                      /*  if self.cards.count == 1 {
                                            self.lblPictureName.text = ""
                                        } else {
                                            self.lblPictureName.text = self.birdNameArray[self.birdNameArray.count - self.cards.count+1]
                                        }*/

//                                        if tag! == (self.birdImageArray.count - 1) {
//                                            self.lblPictureName.text = ""
//                                        } else {
//                                            self.lblPictureName.text = self.birdNameArray[tag! + 1]
//                                        }
//                                        self.lblPictureName.blink()
                                    }
                                } else {
                                    print("Nothing happens")
                                    UIView.animate(withDuration: 0.2) {
                                        self.cards[0].transform = .identity
                                        self.cards[0].center = CGPoint(x: self.picViewcontainer.frame.width / 2, y: (self.picViewcontainer.frame.height / 2) + self.getYMarginForCard())
                                    }
                                }
                //--------------------------------------------------------------------
                default:
                    break
                }
            }
        }
    func hideFrontCard() {
            print("Inside  hideFrontCard")
            if #available(iOS 10.0, *) {
                var cardRemoveTimer: Timer? = nil
                cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] (_) in
                  //  print("Inside  cardRemoveTimer")
                    guard self != nil else {
                        print("Inside  hideFrontCard nil")
                        return }
                   // print("Inside  self  delegate", self)

    //                if (!(self!.view.bounds.contains(self!.cards[0].center))) || AppManager.shared.isDetailCardProcessed {
                        print("Inside  hideFrontCard if")
                        cardRemoveTimer!.invalidate()
                        self?.cardIsHiding = true
                        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                            self?.cards[0].alpha = 0.0
                            print("Inside  hideFrontCard view 1")
                        }, completion: { (_) in
                            print("Inside  hideFrontCard view 2")
                            self?.removeOldFrontCard()
                            self?.cardIsHiding = false
                        })
                })
            } else {
                // fallback for earlier versions
                print("fallback for earlier versions")
                UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                    print("Inside  hideFrontCard view 0")
                    self.cards[0].alpha = 0.0
                }, completion: { (_) in
                    print("Inside  hideFrontCard view 5")

                    self.removeOldFrontCard()
                })
            }
        }
    
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...2 {
            print("********2001***********")
            if i > (cards.count - 1) {
                print("********2002*********** Count",i)
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
    }
    
    @IBAction func funcBackToHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - User defined Functions
    
    @IBAction func funcSound_ON_OFF(_ sender: Any) {
        if appDelegate.IS_Sound_ON {
            btnSound.setBackgroundImage(CommanCode.SOUND_OFF_IMG, for: .normal)
            player.stop()
        } else {
            btnSound.setBackgroundImage(CommanCode.SOUND_ON_IMG, for: .normal)
        }
        appDelegate.IS_Sound_ON = !appDelegate.IS_Sound_ON
    }

}
