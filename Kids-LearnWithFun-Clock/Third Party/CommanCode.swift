//
//  CommanCode.swift
//  Kids-LearnWithFun-Clock
//
//  Created by sheetal shinde on 09/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit

class CommanCode {
    static let APP_BACKGROUND_COLOR = UIColor(red: (237/255), green: (74/255), blue: (66/255), alpha: 1.0) //Red Dark
    static let Tile_BACKGROUND_COLOR = UIColor(red: (142/255), green: (45/255), blue: (39/255), alpha: 1.0)  //Red faint
    
//    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (247/255), blue: (0/255), alpha: 1.0)  // Yellow
    
    
//    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (244/255), blue: (79/255), alpha: 1.0)  // Yellow
    
    
    static let Card_BACKGROUND_COLOR = UIColor(red: (255/255), green: (254/255), blue: (122/255), alpha: 1.0)  // Yellow
//    static let Card_BUTTON_COLOR = UIColor(red: (255/255), green: (213/255), blue: (96/255), alpha: 1.0)  //Border Yellow Dark
    static let Card_BUTTON_BORDER_COLOR = UIColor(red: (254/255), green: (195/255), blue: (184/255), alpha: 1.0)  //Yellow Dark
    static let Correct_Option_COLOR = UIColor(red: (127/255), green: (255/255), blue: (0/255), alpha: 1.0)  //Green
    static let Correct_Option_Border_COLOR = UIColor(red: (50/255), green: (205/255), blue: (50/255), alpha: 1.0)  //Green dark
    //------------------------------------------------------------------------
    static var guessTimeArray: [[Int]] = [[3,0,1],[11,30,0],[12,15,2],[9,45,3],[4,50,1],[1,20,0],[10,10,3],[12,0,2],[7,30,1],[4,45,0],[2,15,3],[8,20,1],[11,55,2],[12,5,2],[6,25,1],[10,41,3],[8,1,0],[3,27,0],[1,48,1],[5,59,3],[4,11,1],[7,46,0],[9,0,2],[2,58,2],[11,14,3],[1,6,1],[5,43,2],[9,52,3],[8,21,0],[11,11,1],[3,6,0],[4,0,1],[1,31,3],[2,30,2],[8,45,0],[12,15,1],[10,0,2],[5,30,0],[11,50,3],[7,0,1]]
    //------------------------------------------------------------------------
    
//    static var guessTimeArray = [[]]
    
   /* int[ ] numbers = { 25,30,35 };
    int max = numbers.length;
    int random = (int)(Math.random() * max);
    int randomNumer = numbers[random];*/
    
//    static let arr2 = Array(0...guessTimeArray.count)

    
    
    static var SOUND_ON_IMG = UIImage(named: "Sound-On.png")
    static var SOUND_OFF_IMG = UIImage(named: "Sound-Off.png")
}
