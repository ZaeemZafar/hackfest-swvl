//
//  JFPrivacyButton.swift
//  Hackfest-swvl
//
//  Created by zaktech on 4/15/18.
//  Copyright © 2018 Citrusbits. All rights reserved.
//

import UIKit

// @IBDesignable
class JFPrivacyButton: UIButton {
    
    @IBInspectable var normalImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var selectedImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var select: Bool = false {
        didSet {
            self.isSelected = select
            if select {
                titleLabel?.font = UIFont.medium(fontSize: 17.0)
            } else {
                titleLabel?.font = UIFont.light(fontSize: 17.0)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setImage(normalImage, for: .normal)
        setImage(selectedImage, for: .selected)
        
        layer.borderWidth = 2.0
        layer.cornerRadius = 4.0
        
        contentHorizontalAlignment = .left
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)
    }
    
}

