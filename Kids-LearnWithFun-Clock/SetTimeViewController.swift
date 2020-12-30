//
//  SetTimeViewController.swift
//  Kids-LearnWithFun-Clock
//
//  Created by Sheetal Ghatkar on 26/12/20.
//  Copyright © 2020 sheetal shinde. All rights reserved.
//

import UIKit

class SetTimeViewController: UIViewController {
    @IBOutlet weak var viewClocket : Clocket!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewClocket.setLocalTime(hour: 10, minute: 10, second: 1)

    }
    
    @IBAction func funcBackToHome(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
