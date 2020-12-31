//
//  LearnViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 31/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit

class LearnViewController: UIViewController {
    @IBOutlet weak var viewClocket : Clocket!
    @IBOutlet weak var viewBgClocket : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBgClocket.backgroundColor = CommanCode.CLOCK_PISTA_Color
    }
    
    @IBAction func funcBackToHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
