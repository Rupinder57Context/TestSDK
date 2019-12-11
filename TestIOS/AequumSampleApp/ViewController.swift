//
//  ViewController.swift
//  PocIOS
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import UIKit
import AequumTech
import CoreLocation



class ViewController: UIViewController {

    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    @IBAction func aequumQuickStatus(_ sender: Any) {
        AequumMaster.shared.launchAequumQuickStatus(self)
    }

    
}

