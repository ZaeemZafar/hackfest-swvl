//
//  DemoViewController.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/16/18.
//  Copyright © 2018 maskers. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var midMessageLabel: UILabel!
    @IBOutlet weak var noteLablel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "You have successfully Login into Hackfest-swvl"
        midMessageLabel.text = "Development of dashboard screen will start soon"
        noteLablel.text = "Note: Kindly Re-Launch the App for further testing"
    }
    
    

}
