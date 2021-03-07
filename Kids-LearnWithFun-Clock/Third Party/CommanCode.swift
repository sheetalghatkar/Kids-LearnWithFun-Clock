//
//  CommanCode.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 09/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration


class CommanCode {
    static let APP_BACKGROUND_COLOR = UIColor(red: (237/255), green: (74/255), blue: (66/255), alpha: 1.0) //Red Dark
    static let Tile_BACKGROUND_COLOR = UIColor(red: (238/255), green: (130/255), blue: (211/255), alpha: 1.0)

//    static let Tile_BACKGROUND_COLOR = UIColor(red: (142/255), green: (45/255), blue: (39/255), alpha: 1.0)  //Red faint
    
//    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (247/255), blue: (0/255), alpha: 1.0)  // Yellow
    
    
//    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (244/255), blue: (79/255), alpha: 1.0)  // Yellow
    
    
    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (254/255), blue: (122/255), alpha: 1.0)  // Yellow
//    static let Card_BUTTON_COLOR = UIColor(red: (255/255), green: (213/255), blue: (96/255), alpha: 1.0)  //Border Yellow Dark
    static let Card_BUTTON_BORDER_COLOR = UIColor(red: (254/255), green: (195/255), blue: (184/255), alpha: 1.0)  //Yellow Dark
    static let Correct_Option_COLOR = UIColor(red: (127/255), green: (255/255), blue: (0/255), alpha: 1.0)  //Green
    static let Correct_Option_Border_COLOR = UIColor(red: (50/255), green: (205/255), blue: (50/255), alpha: 1.0)  //Green dark
    //------------------------------------------------------------------------
    static let Current_Card_Border_COLOR = UIColor.white
        //UIColor(red: (238/255), green: (139/255), blue: (204/255), alpha: 1.0)  //Pink dark
    
//    static let Clock_Digit_Color = UIColor(red: (239/255), green: (134/255), blue: (208/255), alpha: 1.0)  //Pink
    static let Clock_Digit_Color = UIColor(red: (180/255), green: (158/255), blue: (243/255), alpha: 1.0)  //Blue
    static let Screen_Blue_Color = UIColor(red: (178/255), green: (156/255), blue: (246/255), alpha: 1.0)  //Blue

    
    static let Clock_Dial_COLOR = UIColor(red: (30/255), green: (144/255), blue: (255/255), alpha: 1.0)  // Yellow
    
    
    static let CLock_didgit_Shadow = UIColor(red: (135/255), green: (206/255), blue: (250/255), alpha: 1.0)
    static let RED_Color = UIColor(red: (255/255), green: (52/255), blue: (52 / 255), alpha: 1.0)
    
    static let ORANGE_Color = UIColor(red: (239/255), green: (140/255), blue: (207/255), alpha: 1.0)
    static let CLOCK_TICK_Color = UIColor(red: (255/255), green: (20/255), blue: (147/255), alpha: 1.0)



    //------------------------------------------------------------------------
    static var guessTimeArray: [[Int]] = [[3,0,1],[11,30,0],[12,15,2],[9,45,3],[4,50,1],[1,20,0],[10,10,3],[12,0,2],[7,30,1],[4,45,0],[2,15,3],[8,20,1],[11,55,2],[12,5,2],[6,25,1],[10,41,3],[8,1,0],[3,27,0],[1,48,1],[5,59,3],[4,11,1],[7,46,0],[9,0,2],[2,58,2],[11,14,3],[1,6,1],[5,43,2],[9,52,3],[8,21,0],[11,11,1],[3,6,0],[4,0,1],[1,31,3],[2,30,2],[8,45,0],[12,15,1],[10,0,2],[5,30,0],[11,50,3],[7,0,1]]
    //------------------------------------------------------------------------
    static var minuteAngleArray: [Double] = [3.14,3.02,2.91,2.81,2.71,2.60,2.49,2.39,2.29,2.19,2.08,1.98,1.88,1.78,1.68,1.57,1.48,1.35,1.26,1.15,1.04,0.94,0.83,0.73,0.62,0.52,0.42,0.31,0.20,0.10,0.00,-0.10,-0.20,-0.32,-0.42,-0.53,-0.63,-0.73,-0.83,-0.94,-1.05,-1.16,-1.26,-1.37,-1.48,-1.58,-1.68,-1.78,-1.88,-1.99,-2.11,-2.21,-2.31,-2.41,-2.51,-2.63,-2.73,-2.84,-2.94,-3.05]
    
    static var minuteCalculationArray: [[Double]] = [[3.14,3.08,3.02],[3.02,2.96,2.91],[2.91,2.86,2.81],[2.81,2.76,2.71],[2.71,2.65,2.60],[2.60,2.54,2.49],[2.49,2.44,2.39],[2.39,2.34,2.29],[2.29,2.24,2.19],[2.19,2.13,2.08],[2.08,2.03,1.98],[1.98,1.93,1.88],[1.88,1.83,1.78],[1.78,1.73,1.68],[1.68,1.62,1.57],[1.57,1.52,1.48],[1.48,1.41,1.35],[1.35,1.30,1.26],[1.26,1.20,1.15],[1.15,1.09,1.04],[1.04,0.99,0.94],[0.94,0.88,0.83],[0.83,0.78,0.73],[0.73,0.67,0.62],[0.62,0.57,0.52],[0.52,0.47,0.42],[0.42,0.36,0.31],[0.31,0.25,0.20],[0.20,0.15,0.10],[0.10,0.05,0.00],[0.00,-0.05,-0.10],[-0.10,-0.15,-0.20],[-0.20,-0.26,-0.32],[-0.32,-0.36,-0.42],[-0.42,-0.47,-0.53],[-0.53,-0.58,-0.63],[-0.63,-0.68,-0.73],[-0.73,-0.78,-0.83],[-0.83,-0.88,-0.94],[-0.94,-0.99,-1.05],[-1.05,-1.10,-1.16],[-1.16,-1.21,-1.26],[-1.26,-1.31,-1.37],[-1.37,-1.42,-1.48],[-1.48,-1.53,-1.58],[-1.58,-1.63,-1.68],[-1.68,-1.73,-1.78],[-1.78,-1.83,-1.88],[-1.88,-1.93,-1.99],[-1.99,-2.05,-2.11],[-2.11,-2.16,-2.21],[-2.21,-2.26,-2.31],[-2.31,-2.36,-2.41],[-2.41,-1.23,-2.51],[-2.51,-2.57,-2.63],[-2.63,-2.68,-2.73],[-2.73,-2.78,-2.84],[-2.84,-2.89,-2.94],[-2.94,-2.99,-3.05],[-3.05,-3.09,-3.14]]

    //------------------------------------------------------------------------
    static var hourAngleArray: [Double] = [3.14,2.60,2.07,1.56,1.05,0.55,-0.02,-0.56,-1.04,-1.60,-2.10,-2.60]
    //------------------------------------------------------------------------
    static var hourAngleRangeArray: [[Double]] = [[3.14,2.60],[2.60,2.07],[2.07,1.56],[1.56,1.05],[1.05,0.55],[0.55,-0.02],[-0.02,-0.56],[-0.56,-1.04],[-1.04,-1.60],[-1.60,-2.10],[-2.10,-2.60],[-2.60,-3.13]]
    //------------------------------------------------------------------------
    static var hourCalculationArray = [[3.14,3.00,2.87,2.73,2.60],[2.60,2.46,2.33,2.20,2.07], [2.07,1.94,1.81,1.68,1.56],[1.56,1.43,1.30,1.17,1.05],[1.05,0.92,0.80, 0.67,0.55], [0.55,0.40,0.26,0.12,-0.02],[-0.02,-0.15,-0.29,-0.42,-0.56], [-0.56,-0.68,-0.80,-0.92,-1.04], [-1.04,-1.18,-1.32,-1.46,-1.60],[-1.60,-1.72,-1.85,-1.97,-2.10],[-2.10,-2.22,-2.35,-2.47,-2.60], [-2.60,-2.73,-2.86,-2.99,-3.13]]

    static var minuteQuarterDiffArray = [[3.14,1.05],[1.06,-1.04],[-1.05,-3.13]]
    //------------------------------------------------------------------------
    static var hourAngleDiffArray: [Double] = [0.54,0.53,0.51,0.51,0.50,0.53,-0.54,-0.48,-0.56,-0.50,-0.50,-0.52]
    //------------------------------------------------------------------------

    //Questions
    static var hourMinutequestLevel_1_Array: [[Int]] = [[4,0],[6,0],[9,30],[2,0],[5,30],[11,0],[1,30],[8,0],[5,0],[12,12]]
    static var hourMinutequestLevel_2_Array: [[Int]] = [[3,15],[5,45],[9,5],[11,30],[5,30],[6,45],[7,10],[1,45],[12,30],[2,15],[4,20],[8,40],[3,50],[6,45],[10,10]]

    
//    static var guessTimeArray = [[]]
    
   /* int[ ] numbers = { 25,30,35 };
    int max = numbers.length;
    int random = (int)(Math.random() * max);
    int randomNumer = numbers[random];*/
    
//    static let arr2 = Array(0...guessTimeArray.count)

    
    
   // static var imgSoundOn = UIImage(named: "Sound-On.png")
  //  static var imgSoundOff = UIImage(named: "Sound-Off.png")
    
    static var HOUR_HAND_IMG = UIImage(named: "HourHandShadow.png")
    static var MINUTE_HAND_IMG = UIImage(named: "MinuteHandShadow.png")
    static var CLOCK_CENTER_IMG = UIImage(named: "CenterClockImg1.png")
    static var CLOCK_BG = UIImage(named: "OffWhite_bg.png")
    
    
    static var SCREEN_WIDTH = UIScreen.main.bounds.width
    static var SCREEN_HEIGHT = UIScreen.main.bounds.height
    static var CLOCKET_WIDTH_PERCENT = CGFloat(0.85)
    
    
    //Learn clock theme
    static let CLOCK_ORANGE_BG_Color = UIColor(red: (255/255), green: (69/255), blue: (0/255), alpha: 1.0)
    static let CLOCK_PISTA_Color = UIColor(red: (76/255), green: (223/255), blue: (148/255), alpha: 1.0)
    
    static var imgCancelSubscription = UIImage(named: "PaymentDetail.png")!
    static var imgCancelSubscription1 = UIImage(named: "PaymentDetail-1.png")!
    static var imgSoundOn = UIImage(named: "Sound-On_home.png")!
    static var imgSoundOff = UIImage(named: "Sound-Off_home.png")!
    static var imageRadioCheck = UIImage(named: "radio_check.png")
    static var imageRadioUncheck = UIImage(named: "radio_uncheck.png")
    static var imgSoundOn1 = UIImage(named: "Sound-On_home1.png")!
    static var imgSoundOff1 = UIImage(named: "Sound-Off_home1.png")!


    //------------------------------------------------------------------------
    //Related to review and rating
    static let app_AppStoreLink = URL(string: "https://apps.apple.com/app/id1553584897")

    
    //Colors
    static var settingBgColor = UIColor(red: (255/255), green: (110/255), blue: (199/255), alpha: 1.0)
    static var paymentModeBgColor = UIColor(red: (239/255), green: (133/255), blue: (205/255), alpha: 1.0)
    static var paymentBtnTextColor = UIColor(red: (235/255), green: (28/255), blue: (136/255), alpha: 1.0)

    //Related to Ads Production
    static var Banner_AdUnitId = "ca-app-pub-7546454767986772/6129485386"
    static var Interstitial_AdUnitId = "ca-app-pub-7546454767986772/7817245225"
    static var Ad_App_ID = "ca-app-pub-7546454767986772~3783357791"
    
    
    
    //Related to Ads Sandbox/Test
   /*  static var Banner_AdUnitId = "ca-app-pub-3940256099942544/2934735716"
     static var Interstitial_AdUnitId = "ca-app-pub-3940256099942544/4411468910"
     static var Ad_App_ID = "ca-app-pub-3940256099942544~1458002511"*/
    
    //Related to InAppPurchase
    static var environment = AppleReceiptValidator.VerifyReceiptURLType.sandbox
    static var secretKey = "45a93632e6974dff854368d031b747eb"
    
    static var productId_Year_Auto_Recurring = "com.mobiapps360.LearnClockTime.YearlyAutoRenewable"
    static var productId_Year_Non_Recurring = "com.mobiapps360.LearnClockTime.YearlyNonRecurring"
    static var productId_Month_Auto_Recurring = "com.mobiapps360.LearnClockTime.MonthlyAutoRenewable"
    static var productId_Month_Non_Recurring = "com.mobiapps360.LearnClockTime.MonthlyNonRecurring"

    
    static var timerForAds = 15.0

    static var animateCard = 0.1
}
extension UIDevice {
    var hasNotch: Bool
    {
        if #available(iOS 11.0, *)
        {
            let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
            return bottom > 0
        } else
        {
            // Fallback on earlier versions
            return false
        }
    }
}
public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
extension Array {
    func indexExists(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
}
extension UIWindow {
    /// Returns the currently visible view controller if any reachable within the window.
    public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
    }

    /// Recursively follows navigation controllers, tab bar controllers and modal presented view controllers starting
    /// from the given view controller to find the currently visible view controller.
    ///
    /// - Parameters:
    ///   - viewController: The view controller to start the recursive search from.
    /// - Returns: The view controller that is most probably visible on screen right now.
    public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)

        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)

        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)

        default:
            return viewController
        }
    }
}
