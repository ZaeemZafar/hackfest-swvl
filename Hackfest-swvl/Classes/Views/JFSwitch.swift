//
//  JFSwitch.swift
//  Hackfest-swvl
//
//  Created by zaktech on 7/23/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

class JFSwitch: UISwitch {
    
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
