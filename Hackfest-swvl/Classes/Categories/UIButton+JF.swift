//
//  UIButton+JF.swift
//  Hackfest-swvlDev
//
//  Created by zaktech on 4/5/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func customButton(titleColor: UIColor = UIColor.white, backGroundColor: UIColor, borderColor: UIColor = UIColor.clear, withRoundCorner: Bool = true, cornerRadius: CGFloat = 5) {
        
        if withRoundCorner {
            self.layer.cornerRadius = cornerRadius
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
        }
        self.backgroundColor = backGroundColor
        self.titleLabel?.textColor = titleColor
    }
    
    func addButtonSpacingWithTitle(spacing: CGFloat, title: String) {
        let attributedString = NSMutableAttributedString(string: title )
        attributedString.addAttribute(NSAttributedStringKey.kern, value: spacing, range: NSRange(location: 0, length: (title.count )))
        self.setAttributedTitle(attributedString, for: .normal)
        
    }
}
